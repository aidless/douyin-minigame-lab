# push-via-api.ps1
# 一次性工具：通过 GitHub REST API 直接推送本地仓库（绕过 git CLI 的 sh 环境问题）
# 用法：$env:GITHUB_TOKEN = "<新 token>"; .\tools\push-via-api.ps1

param(
    [string]$ProjectRoot = "D:\Projects\douyin-minigame-lab",
    [string]$Owner = "aidless",
    [string]$Repo = "douyin-minigame-lab",
    [string]$Branch = "main",
    [string]$CommitMessage = "chore: initial commit from local machine via REST API"
)

$ErrorActionPreference = "Stop"

# ============================================================
# 0. 读 token（优先 $args[0]，其次 env var）
# ============================================================
$token = $args[0]
if (-not $token) { $token = $env:GITHUB_TOKEN }
if (-not $token) {
    Write-Host "[ERROR] 缺少 GITHUB_TOKEN" -ForegroundColor Red
    Write-Host "请运行：`$env:GITHUB_TOKEN = '<your_token>'; .\tools\push-via-api.ps1"
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $token"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
    "User-Agent" = "douyin-minigame-lab-setup"
}

$apiBase = "https://api.github.com/repos/$Owner/$Repo"

# ============================================================
# 1. 验证身份
# ============================================================
Write-Host "[1/7] 验证 GitHub 身份..." -ForegroundColor Cyan
try {
    $user = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers -Method Get
    Write-Host "  身份: $($user.login)" -ForegroundColor Green
} catch {
    $code = $_.Exception.Response.StatusCode.value__
    Write-Host "  [FAIL] $code - Token 无效或权限不足" -ForegroundColor Red
    exit 1
}

# ============================================================
# 2. 检查远程 main ref
# ============================================================
Write-Host "[2/7] 检查远程 main ref..." -ForegroundColor Cyan
$parentSha = $null
$baseTree = $null
try {
    $refResp = Invoke-RestMethod -Uri "$apiBase/git/refs/heads/$Branch" -Headers $headers -Method Get
    $parentSha = $refResp.object.sha
    Write-Host "  远程 $Branch 当前 commit: $parentSha"

    $commitResp = Invoke-RestMethod -Uri "$apiBase/git/commits/$parentSha" -Headers $headers -Method Get
    $baseTree = $commitResp.tree.sha
    Write-Host "  远程 base tree: $baseTree"
} catch {
    $code = $null
    try { $code = $_.Exception.Response.StatusCode.value__ } catch {}
    if ($code -eq 404 -or $code -eq 409) {
        Write-Host "  远程 $Branch 不存在或仓库为空（状态 $code），将创建初始 commit"
    } else {
        throw
    }
}

# ============================================================
# 3. 收集所有本地文件
# ============================================================
Write-Host "[3/7] 收集本地文件..." -ForegroundColor Cyan

# 排除 .git 目录
$files = @()
Get-ChildItem $ProjectRoot -Recurse -File -Force | Where-Object {
    $fullName = $_.FullName
    -not ($fullName -match "[\\/]\.git[\\/]") -and
    -not ($fullName -match "[\\/]\.git$")
} | ForEach-Object {
    $relPath = $_.FullName.Substring($ProjectRoot.Length).TrimStart('\', '/') -replace "\\", "/"

    # 读 UTF-8 内容（自动处理 BOM）
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)

    $files += @{
        path = $relPath
        mode = "100644"
        type = "blob"
        content = $content
    }
}

Write-Host ("  共 {0} 个文件:" -f $files.Count)
foreach ($f in $files) {
    $size = $f.content.Length
    Write-Host ("    - {0} ({1} chars)" -f $f.path, $size)
}

# ============================================================
# 4. 创建 blobs
# ============================================================
Write-Host "[4/7] 创建 blobs..." -ForegroundColor Cyan
$blobEntries = @()
foreach ($f in $files) {
    $blobBody = @{
        content = $f.content
        encoding = "utf-8"
    } | ConvertTo-Json -Compress

    $blobResp = Invoke-RestMethod -Uri "$apiBase/git/blobs" -Headers $headers -Method Post -Body $blobBody -ContentType "application/json"
    $blobEntries += @{ path = $f.path; sha = $blobResp.sha }
    Write-Host "    [OK] $($f.path) -> $($blobResp.sha)"
}

# ============================================================
# 5. 创建 tree
# ============================================================
Write-Host "[5/7] 创建 tree..." -ForegroundColor Cyan
$treeBody = @{
    tree = $blobEntries
}
if ($baseTree) {
    $treeBody.base_tree = $baseTree
}
$treeBodyJson = $treeBody | ConvertTo-Json -Depth 10 -Compress

$treeResp = Invoke-RestMethod -Uri "$apiBase/git/trees" -Headers $headers -Method Post -Body $treeBodyJson -ContentType "application/json"
$treeSha = $treeResp.sha
Write-Host "  tree: $treeSha" -ForegroundColor Green

# ============================================================
# 6. 创建 commit
# ============================================================
Write-Host "[6/7] 创建 commit..." -ForegroundColor Cyan
$parents = @()
if ($parentSha) { $parents = @($parentSha) }

$commitBody = @{
    message = $CommitMessage
    tree = $treeSha
    parents = $parents
} | ConvertTo-Json -Compress

$commitResp = Invoke-RestMethod -Uri "$apiBase/git/commits" -Headers $headers -Method Post -Body $commitBody -ContentType "application/json"
$commitSha = $commitResp.sha
Write-Host "  commit: $commitSha" -ForegroundColor Green
Write-Host "  URL: $($commitResp.html_url)"

# ============================================================
# 7. 更新或创建 ref
# ============================================================
Write-Host "[7/7] 更新 ref..." -ForegroundColor Cyan
if ($parentSha) {
    $refBody = @{ sha = $commitSha } | ConvertTo-Json -Compress
    Invoke-RestMethod -Uri "$apiBase/git/refs/heads/$Branch" -Headers $headers -Method Patch -Body $refBody -ContentType "application/json" | Out-Null
    Write-Host "  已更新 $Branch -> $commitSha" -ForegroundColor Green
} else {
    $refBody = @{ ref = "refs/heads/$Branch"; sha = $commitSha } | ConvertTo-Json -Compress
    Invoke-RestMethod -Uri "$apiBase/git/refs" -Headers $headers -Method Post -Body $refBody -ContentType "application/json" | Out-Null
    Write-Host "  已创建 $Branch -> $commitSha" -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "[OK] Push 完成！" -ForegroundColor Green
Write-Host "  仓库: https://github.com/$Owner/$Repo"
Write-Host "  Commit: $commitSha"
Write-Host "  分支: $Branch"
Write-Host "============================================" -ForegroundColor Cyan
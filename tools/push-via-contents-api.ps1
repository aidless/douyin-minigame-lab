# push-via-contents-api.ps1
# 备选推送：通过 Contents API 创建文件（绕开空仓库对 Git Data API 的限制）
# 每个文件创建一个 commit，结果会多 commit 但保证成功

param(
    [string]$ProjectRoot = "D:\Projects\douyin-minigame-lab",
    [string]$Owner = "aidless",
    [string]$Repo = "douyin-minigame-lab"
)

$ErrorActionPreference = "Stop"

$token = $args[0]
if (-not $token) { $token = $env:GITHUB_TOKEN }
if (-not $token) {
    Write-Host "[ERROR] 缺少 GITHUB_TOKEN"
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $token"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
    "User-Agent" = "douyin-minigame-lab-setup"
}

$apiBase = "https://api.github.com/repos/$Owner/$Repo"

# 验证身份
Write-Host "[1/3] 验证身份..." -ForegroundColor Cyan
try {
    $user = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers -Method Get
    Write-Host "  身份: $($user.login)" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 收集本地文件
Write-Host "[2/3] 收集文件..." -ForegroundColor Cyan
$files = @()
Get-ChildItem $ProjectRoot -Recurse -File -Force | Where-Object {
    $fullName = $_.FullName
    -not ($fullName -match "[\\/]\.git[\\/]") -and
    -not ($fullName -match "[\\/]\.git$")
} | ForEach-Object {
    $relPath = $_.FullName.Substring($ProjectRoot.Length).TrimStart('\', '/') -replace "\\", "/"
    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
    $base64Content = [Convert]::ToBase64String($bytes)

    $files += @{
        path = $relPath
        content_b64 = $base64Content
    }
}
Write-Host "  共 $($files.Count) 个文件"

# 逐个 PUT 创建
Write-Host "[3/3] 创建文件（每个一个 commit）..." -ForegroundColor Cyan
$success = 0
$failed = 0
foreach ($f in $files) {
    $uri = "$apiBase/contents/$($f.path)"
    $body = @{
        message = "chore: add $($f.path)"
        content = $f.content_b64
    } | ConvertTo-Json

    try {
        $resp = Invoke-RestMethod -Uri $uri -Headers $headers -Method Put -Body $body -ContentType "application/json"
        Write-Host "    [OK] $($f.path) -> $($resp.content.sha.Substring(0,7))" -ForegroundColor Green
        $success++
    } catch {
        $code = $_.Exception.Response.StatusCode.value__
        $msg = $_.ErrorDetails.Message
        Write-Host "    [FAIL $code] $($f.path) - $msg" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "[完成] 成功 $success / 失败 $failed" -ForegroundColor $(if($failed -eq 0){"Green"}else{"Yellow"})
Write-Host "  https://github.com/$Owner/$Repo"
Write-Host "============================================" -ForegroundColor Cyan
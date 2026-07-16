# GitHub 推送指南 — Mini-Game Lab

> 由于本机 SSH key 未在 GitHub 账号登记，且未配置 credential helper，需走 PAT 路线。

---

## 方案 A：HTTPS + Personal Access Token（推荐）

### Step 1：创建 PAT

1. 浏览器打开 https://github.com/settings/tokens?type=beta
2. 点击 **Generate new token** → 选 **Fine-grained token**
3. 配置：
   - Token name：`douyin-minigame-lab-deploy`
   - Expiration：90 days（或更长）
   - Repository access：Public Repositories (read+write) + All repositories of `aidless` (如果想私有不选)
4. Permissions 勾选：
   - Contents: Read and write
   - Metadata: Read-only（默认）
5. 点击 **Generate token**
6. **立即复制 token**（离开页面后无法再看到完整值）

### Step 2：本地配置 token

PowerShell 中执行（把 `<TOKEN>` 替换为上一步的 token）：

```powershell
$token = "<TOKEN>"
[System.Environment]::SetEnvironmentVariable("GITHUB_TOKEN", $token, "User")
git config --global credential.helper store
git config --global credential.https://github.com.username aidless
```

> 配置完成后首次 push 时会提示输入密码，输入 token 即可（之后会被 store 记住）

### Step 3：在 GitHub 上创建空仓库

浏览器打开 https://github.com/new

- Repository name: `douyin-minigame-lab`
- Description: "抖音小游戏副业实验场——多款矩阵 + 内容萃取"
- 选择 **Private**（先 private，有 MVP 后转 public）
- **不要勾选** Add a README / .gitignore / license（本地已有）
- 点击 **Create repository**

### Step 4：本地推送

```powershell
cd D:\Projects\douyin-minigame-lab
git remote add origin https://github.com/aidless/douyin-minigame-lab.git
git push -u origin main
```

首次 push 会要求输入 username + password，username 填 `aidless`，password 填 token。

---

## 方案 B：SSH key（如果不想用 token）

### Step 1：复制公钥

当前 id_ed25519.pub 内容：

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuTgzdeafmuJIHt4IF+dLwKKwUkjQ5b+lwM3vMLeIj/ phase8-deploy-20260714
```

### Step 2：添加到 GitHub

1. 打开 https://github.com/settings/keys
2. 点击 **New SSH key**
3. Title: `aidless-workstation`（自定义）
4. Key type: **Authentication Key**
5. Key: 粘贴上一步的公钥内容
6. 点击 **Add SSH key**

### Step 3：测试连接

```powershell
ssh -T git@github.com
```

应看到：

```
Hi aidless! You've successfully authenticated, but GitHub does not provide shell access.
```

### Step 4：切换 remote 到 SSH

```powershell
cd D:\Projects\douyin-minigame-lab
git remote set-url origin git@github.com:aidless/douyin-minigame-lab.git
git push -u origin main
```

---

## 推荐顺序

1. **首选方案 A（PAT）**：更稳定、不依赖 SSH agent，token 可以随时 revoke
2. **备选方案 B（SSH）**：如果不想频繁输入 token（首次后免密）

---

## 故障排查

| 症状 | 原因 | 修复 |
|------|------|------|
| `Permission denied (publickey)` | SSH key 未添加到 GitHub | 走方案 A |
| `Bad credentials` | Token 错误或过期 | 重新生成 PAT |
| `Repository not found` | 仓库名拼错或私有权限不足 | 检查仓库 URL + token scope |
| `failed to push some refs` | 本地与远程有冲突 | 先 `git pull --rebase origin main` |

---

## 安全提醒

- **不要把 PAT 提交到任何 git 仓库**
- **PAT 等同于密码**——泄露后立即到 https://github.com/settings/tokens 删除
- 推荐使用 fine-grained token + 最小权限原则（只勾选需要的 repo 和 scope）
- 不要使用经典 PAT（已弃用，且权限过大）
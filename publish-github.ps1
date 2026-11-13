# 俄罗斯方块 · 一键发布到 GitHub Pages
# 用法：在 PowerShell 里执行  .\publish-github.ps1
# 前置：已装 Git for Windows；已在 GitHub 建好空仓库（public，不要勾 README）

$ErrorActionPreference = 'Continue'
Set-Location -LiteralPath (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host ""
Write-Host "===== 俄罗斯方块 · 发布到 GitHub Pages =====" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[x] 没有找到 git，请先安装 Git for Windows：https://git-scm.com/download/win" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

$user = (Read-Host "GitHub 用户名（例：zhangsan）").Trim()
$repo = (Read-Host "仓库名（例：tetris）").Trim()

if ([string]::IsNullOrWhiteSpace($user) -or [string]::IsNullOrWhiteSpace($repo)) {
    Write-Host "[x] 用户名或仓库名不能为空，已退出" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

$url = "https://github.com/$user/$repo.git"

Write-Host ""
Write-Host "[1/4] 初始化本地仓库 ..." -ForegroundColor Yellow
if (-not (Test-Path -LiteralPath ".git")) {
    git init | Out-Null
}

Write-Host "[2/4] 暂存并提交 ..." -ForegroundColor Yellow
git add -A
git commit -m "feat: 俄罗斯方块小游戏" | Out-Null

Write-Host "[3/4] 关联远程仓库 ..." -ForegroundColor Yellow
$remotes = @(git remote)
if ($remotes -contains 'origin') {
    git remote set-url origin $url
} else {
    git remote add origin $url
}
git branch -M main

Write-Host "[4/4] 推送 ..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  GitHub 不再接受账号密码，密码栏必须填「Personal Access Token」" -ForegroundColor DarkGray
Write-Host "  还没生成？浏览器打开：https://github.com/settings/tokens" -ForegroundColor DarkGray
Write-Host "  生成时勾选 repo 这一项即可。" -ForegroundColor DarkGray
Write-Host ""

git push -u origin main
$code = $LASTEXITCODE

if ($code -ne 0) {
    Write-Host ""
    Write-Host "推送失败，尝试同步远程后重试 ..." -ForegroundColor Yellow
    git pull --rebase origin main
    git push -u origin main
    $code = $LASTEXITCODE
}

Write-Host ""
if ($code -eq 0) {
    Write-Host "===== 代码已推送成功 =====" -ForegroundColor Green
    Write-Host ""
    Write-Host "现在只剩开启 Pages（浏览器操作，30 秒）：" -ForegroundColor Cyan
    Write-Host "  1. 打开 https://github.com/$user/$repo/settings/pages"
    Write-Host "  2. Source 选「Deploy from a branch」"
    Write-Host "  3. Branch 选 main，目录选 / (root)，点 Save"
    Write-Host "  4. 等 1~3 分钟，刷新页面顶部会显示你的网址"
    Write-Host ""
    Write-Host "最终地址：https://$user.github.io/$repo/" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "===== 推送失败（退出码 $code）=====" -ForegroundColor Red
    Write-Host "常见原因：" -ForegroundColor Yellow
    Write-Host "  - 仓库不存在或拼错：先去 github.com/new 建一个 public 空仓库（别勾 README）"
    Write-Host "  - 认证失败：密码栏要填 Token，不是登录密码"
    Write-Host "  - 远程已有提交：脚本会自动 pull --rebase 重试，若仍有冲突，删掉远程 README 再跑一次"
    Write-Host ""
}

Read-Host "按回车退出"

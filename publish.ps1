# 俄罗斯方块 · 一键发布到 Gitee
# 用法：右键「使用 PowerShell 运行」，或在此目录执行   .\publish.ps1
# 需要：已安装 Git for Windows，并且已在 Gitee 建好空仓库

$ErrorActionPreference = 'Continue'
Set-Location -LiteralPath (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host ""
Write-Host "===== 俄罗斯方块 · Gitee 发布 =====" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[x] 没有找到 git，请先安装 Git for Windows：https://git-scm.com/download/win" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

$remote = Read-Host "请输入你的仓库地址（例：https://gitee.com/yourname/tetris.git）"
$remote = $remote.Trim()
if ([string]::IsNullOrWhiteSpace($remote)) {
    Write-Host "[x] 没有输入仓库地址，已退出" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

Write-Host ""
Write-Host "[1/4] 初始化本地仓库 ..." -ForegroundColor Yellow
if (-not (Test-Path -LiteralPath ".git")) {
    git init | Out-Null
}

Write-Host "[2/4] 暂存文件 ..." -ForegroundColor Yellow
git add -A

Write-Host "[3/4] 提交 ..." -ForegroundColor Yellow
$msg = "feat: 俄罗斯方块小游戏"
git commit -m $msg | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "     （没有新改动，跳过提交）" -ForegroundColor DarkGray
}

Write-Host "[4/4] 关联远程并推送 ..." -ForegroundColor Yellow
$remotes = @(git remote)
if ($remotes -contains 'origin') {
    git remote set-url origin $remote
} else {
    git remote add origin $remote
}

Write-Host ""
Write-Host "接下来 git 会让你输入账号：" -ForegroundColor Cyan
Write-Host "  用户名 = Gitee 用户名或邮箱" -ForegroundColor DarkGray
Write-Host "  密码   = Gitee 账号密码 或 私人令牌（推荐令牌）" -ForegroundColor DarkGray
Write-Host ""

git push -u origin master
$pushCode = $LASTEXITCODE

Write-Host ""
if ($pushCode -eq 0) {
    Write-Host "===== 推送成功 =====" -ForegroundColor Green
    Write-Host ""
    Write-Host "最后两步（在浏览器里点）：" -ForegroundColor Cyan
    Write-Host "  1. 打开仓库页面 -> 上方「服务」-> Gitee Pages"
    Write-Host "  2. 分支选 master -> 勾选强制使用 HTTPS（可选）-> 点「启动」"
    Write-Host ""
    Write-Host "部署完成后访问：https://<你的用户名>.gitee.io/tetris" -ForegroundColor Green
} else {
    Write-Host "===== 推送失败（退出码 $pushCode）=====" -ForegroundColor Red
    Write-Host "常见原因：" -ForegroundColor Yellow
    Write-Host "  - 仓库地址写错（要以 .git 结尾）"
    Write-Host "  - 密码错：Gitee 现在需要「私人令牌」而不是登录密码"
    Write-Host "    （头像 -> 设置 -> 安全设置 -> 私人令牌 -> 生成新令牌，勾选 projects 权限）"
    Write-Host "  - 远程仓库不是空的：先去网页里把自动生成的 README 删掉"
}

Write-Host ""
Read-Host "按回车退出"

# 俄罗斯方块 · TETRIS

一个单文件、离线可玩、支持手机触屏的俄罗斯方块。

打开 `index.html` 即可游玩，无需联网、无需安装任何依赖。

## 玩法

| 键盘 | 作用 |
| --- | --- |
| ← → | 左右移动（长按连发） |
| ↓ | 软降（+1 分/格） |
| ↑ / X | 顺时针旋转 |
| Z / Ctrl | 逆时针旋转 |
| 空格 | 硬降（+2 分/格） |
| C / Shift | 暂存（Hold） |
| P / Esc | 暂停 |
| R | 重开 |

手机端底部有 6 个按钮：◀ ▼ ▶ / ⟳ ⤓ ◫

## 特性

- 7-bag 随机：每 7 个方块必为 I/J/L/O/S/T/Z 各一次
- 幽灵投影、踢墙旋转、Hold 暂存、4 个 Next 预览
- 触底 0.5 秒锁定延迟，可微调
- 消行 100/300/500/800 × 等级，每 10 行升一级
- 响应式布局，适配桌面与手机竖屏，高分屏适配
- 切到后台自动暂停

## 部署到 GitHub Pages

1. 在 GitHub 新建 **public** 仓库 `tetris`，**不要**勾选 `Add a README file`
2. 在本目录运行 `publish-github.ps1`，按提示输入用户名、仓库名
   （密码栏填 Personal Access Token，不是登录密码）
3. 打开仓库 `Settings → Pages`，Source 选 `Deploy from a branch`，
   Branch 选 `main`、目录选 `/ (root)`，点 `Save`
4. 等 1~3 分钟，访问 `https://<你的用户名>.github.io/tetris/`

> 本仓库含 `.nojekyll`，用于跳过 Jekyll 处理，纯静态页发布更快更稳。

### 关于 Gitee

Gitee 已停止向新用户提供 Pages 服务，且帮助文档中已无该功能。
Gitee 目前只能作为代码仓库使用，无法直接对外提供网页访问。
`publish.ps1` 仍可用于把代码推到 Gitee 做备份。

## License

MIT

# Week 01 行动清单 — 环境与原型

> 周期：2026-07-16 → 2026-07-22
> 主题：跑通"开发 → 构建 → 真机预览 → 挂载"全链路
> DoD（完成定义）：能在自己抖音 App 内打开看到一个可玩的"水果合并"原型

---

## Day 1（今天，2026-07-16）— 环境搭建

### 上午（2h）

- [ ] 下载并安装 **Cocos Creator 2.4.13 LTS**
  - 官方：https://www.cocos.com/creator
  - 安装路径建议：`D:\Tools\CocosCreator\`（避开 C 盘）
  - 验证：打开后能新建空白项目
- [ ] 注册 **抖音开放平台** 账号
  - 入口：https://developer.open-douyin.com
  - 用现有抖音账号登录即可，个人主体先认证
- [ ] 下载 **抖音开发者工具**
  - 入口：https://developer.open-douyin.com/docs/resource/zh-CN/mini-app/develop/developer-instrument/download/developer-instrument-update-and-download
  - 安装到 D 盘

### 下午（2h）

- [ ] 创建 **GitHub 仓库**
  - 命名建议：`douyin-minigame-lab`
  - 设为 private（公开前先有 MVP）
  - clone 到本地：`D:\Projects\douyin-minigame-lab\`
- [ ] 初始化仓库结构（参考 `github-readme-template.md`）
- [ ] 写第一份 commit：`chore: init project structure`
- [ ] 关联本地与远程：`git remote add origin git@github.com:<your-name>/douyin-minigame-lab.git`

### 产出

- ✅ Cocos Creator + 抖音开发者工具 安装完成
- ✅ 抖音开放平台账号就绪
- ✅ GitHub 仓库创建 + 首次 commit
- ✅ 项目目录结构搭建

---

## Day 2（2026-07-17）— 跑通官方模板

### 任务（3h）

- [ ] Cocos Creator 中新建项目 → 选"**2D 项目模板**"（TS 版本）
- [ ] 项目设置中：
  - Platform 选 "抖音小游戏"
  - Bundle Identifier：`com.<your-name>.douyin.minigame`
  - 初始场景：保留默认 main.scene
- [ ] 构建 → 选"抖音小游戏"平台 → 输出到 `build/douyin/`
- [ ] 抖音开发者工具 → 导入 `build/douyin/` 目录
- [ ] 在开发者工具中点击"预览" → 扫码在自己抖音打开

### 验收标准

- 你自己的抖音 App 能看到 Cocos 默认的 Hello World
- 关闭重开能复现（确认构建产物稳定）

### 产出

- ✅ 完整链路打通：Cocos → 构建 → 开发者工具 → 真机预览
- ✅ 截图保存到 `docs/screenshots/day2-hello-world.png`
- ✅ commit: `feat: hello world on douyin dev tools`

---

## Day 3（2026-07-18）— 素材与基础组件

### 任务（3h）

- [ ] 在 Cocos 商店（编辑器内）搜"合并/水果/消除"找 1 套免费或低价素材
  - 推荐预算：0-100 元
  - 若找不到合适的，先用 Cocos 默认 sprite 资源
- [ ] 准备 7 种水果的 icon（西瓜、苹果、橙子、葡萄、樱桃、草莓、橘子等）
  - 至少 3 种临时方案：商店素材 / 自己用 PowerPoint 截图 / AI 生成
- [ ] 搭建基础 UI 框架：
  - 顶部 score
  - 中部 7x8 网格区域（占位）
  - 底部"下一水果"预览

### 验收标准

- 7 种 icon 在场景中正确显示
- UI 排版无破版（手机竖屏 9:16 测试）

### 产出

- ✅ 7 种水果素材就绪
- ✅ 基础 UI 框架完成
- ✅ commit: `feat: basic ui + 7 fruit assets`

---

## Day 4（2026-07-19）— 核心玩法 v1

### 任务（4h）

- [ ] 数据层：定义 7 个 FruitLevel（从樱桃到西瓜）
  - TypeScript 类：`FruitData.ts` + `FruitConfig.ts`
- [ ] 网格系统：`GameGrid.ts`，支持：
  - 7 列 × 8 行
  - 点击空格放置下一水果
  - 同等级相邻合并（4 向连通）
- [ ] 输入处理：触摸事件绑定
- [ ] 视觉反馈：合并动画（简单 tween 即可）

### 验收标准

- 能连续点击 5 次以上不报错
- 相同等级相邻可合并，视觉上有反馈
- 网格满时显示"Game Over"

### 产出

- ✅ 可玩的合并原型（虽然简陋）
- ✅ commit: `feat: core merge mechanic v1`

---

## Day 5（2026-07-20）— 打磨与 bug 修复

### 任务（4h）

- [ ] 边界 case 处理：
  - 网格放满 → 弹"Game Over"对话框
  - 合并后上方水果下落
  - 长按加速下落（可选）
- [ ] 加入音效（Cocos 内置 audio engine）
  - 合并音、失败音、背景音（暂用免费素材）
- [ ] 真机测试至少 3 次，修复发现的卡顿/崩溃

### 产出

- ✅ Day 4 原型升级为可演示版本
- ✅ 录制 1 分钟真机演示视频（保留原始素材）
- ✅ commit: `fix: edge cases + audio integration`

---

## Day 6（2026-07-21）— 抖音账号启动

### 任务（3h）

- [ ] 注册专用游戏抖音号
  - 昵称建议：`MiniGame实验室` / `独立小游戏日记` 等
  - 头像：设计一个简单 logo（可用 AI 生成）
  - 简介：明确"专注抖音小游戏开发，每周更新"
- [ ] 拍摄并发布第一条视频：
  - 时长：15-30 秒
  - 内容：Day 5 的演示录屏 + 口播"我用 5 天做了个抖音小游戏"
  - 文案：3 个 hashtag：`#抖音小游戏 #独立开发 #游戏开发`
  - 挂载：绑定 Day 5 的真机预览版（先用本地二维码挂载，公开前换正式版）
- [ ] 抖音开放平台后台绑定游戏与账号

### 产出

- ✅ 抖音游戏号发布第一条视频
- ✅ 视频链接保存到 `docs/social-links.md`
- ✅ commit: `docs: launch douyin account, first video`

---

## Day 7（2026-07-22）— Week 1 复盘

### 任务（2h）

- [ ] 填写 Week 1 周报（`weekly-report-template.md`）
- [ ] 在 journal.md 记录关键学习（哪怕只有 3 条）
- [ ] 整理 git history，准备提交给我 review
- [ ] 与我同步 Day 1-7 进展

### 产出

- ✅ Week 1 周报完成
- ✅ Day 1-7 全部 commit 已 push
- ✅ 回复我："Day 7 done, ready for Week 1 review"

---

## 关键提示

### 关于 commit 规范

使用 Conventional Commits：

```
feat: 新功能
fix: 修复 bug
docs: 文档
style: 格式
refactor: 重构
test: 测试
chore: 构建/工具
```

示例：

```
feat(grid): add 7x8 game grid with merge logic
fix(input): handle rapid tap on same cell
```

### 关于求助时机

- 卡壳 < 2 小时：自己先 google + 查 Cocos 文档
- 卡壳 2-4 小时：在 GitHub 提 issue + 给我留言
- 卡壳 > 4 小时：**直接 ping 我**，不要死磕

### 关于内容萃取

Day 5 录屏 + Day 6 视频 = 你已经有了 1 个可发布素材：

> **可发布草稿标题候选**：
> - "5 天从零做一个抖音小游戏——一个 LLM 研究者的副业尝试"
> - "为什么我选择 Cocos 而不是 Unity 做抖音小游戏"
> - "TS 开发者第一周做小游戏踩过的 5 个坑"

Week 2 我们会从你的开发日志中萃取出第 1 篇正式发布的博客草稿。
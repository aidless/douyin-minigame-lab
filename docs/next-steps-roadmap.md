# 下一步计划速查表 — Mini-Game Lab

> 启动日：2026-07-16
> 当前阶段：Week 1, Day 1
> 详情见：`docs/week-01-plan.md`（Day 1-7 任务清单）

---

## 一、接下来 72 小时（Day 1-3）—— 环境跑通

### 必做项（按顺序）

| # | 任务 | 时间 | DoD |
|---|------|------|-----|
| 1 | 安装 Cocos Creator 2.4.13 LTS | 30min | 启动后能新建空白项目 |
| 2 | 注册抖音开放平台账号 | 20min | 个人主体认证完成 |
| 3 | 安装抖音开发者工具 | 15min | 启动无报错 |
| 4 | 创建 GitHub 仓库 `douyin-minigame-lab` | 15min | 私有仓库 + 首次 commit |
| 5 | clone 到 `D:\Projects\douyin-minigame-lab\` | 5min | 本地目录与远程关联 |
| 6 | 按 README 模板初始化目录结构 | 60min | 6 个目录（docs/games/shared/tools/weekly-reports/screenshots）+ 4 个 .md 文件就位 |
| 7 | 跑通官方 Hello World 模板 | 90min | 在自己抖音 App 内看到 Cocos 默认输出 |

### 72h DoD（完成定义）

- ✅ Cocos Creator + 抖音开发者工具 均安装就绪
- ✅ GitHub 仓库已创建并首次 commit
- ✅ 自己抖音 App 内能看到 Hello World 真机预览
- ✅ 截图保存到 `docs/screenshots/day2-hello-world.png`

### 卡壳处理

- **< 2h 未解决**：自查 Cocos 文档 + 抖音开放平台 FAQ
- **2-4h 未解决**：GitHub issue + 给我留言
- **> 4h 未解决**：直接 ping 我（带错误截图）

---

## 二、本周核心（Week 1）—— 首个原型 + 账号启动

### 五个里程碑（已锁定在 week-01-plan.md）

| Day | 里程碑 | 关键产出 |
|-----|--------|----------|
| Day 1 | 环境搭建 | Cocos + 抖音工具 + GitHub 仓库 |
| Day 2 | 跑通官方模板 | 真机 Hello World |
| Day 3 | 素材与 UI 框架 | 7 种水果 icon + 基础布局 |
| Day 4 | 核心玩法 v1 | 可玩的合并原型 |
| Day 5 | 打磨与修复 | 可演示版本 + 1 分钟录屏 |
| Day 6 | 抖音账号启动 | 第一条挂载视频 |
| Day 7 | Week 1 复盘 | 周报 + 学习笔记 |

### Week 1 DoD

- ✅ 能在自己抖音内玩到一个简单但完整的"水果合并"demo
- ✅ 抖音账号发布至少 1 条挂载视频
- ✅ GitHub 有 ≥ 7 次原子化 commit
- ✅ 周报完成（填写 `weekly-report-template.md`）

---

## 三、本月里程碑（Month 1, 2026-07）—— Game 1 内部 MVP

### Week 2-4 节奏

| 周 | 重点 | 关键产出 |
|----|------|----------|
| Week 2 | 关卡数据 + 激励视频广告 | 50 关卡 JSON + 广告位接入 |
| Week 3 | 留存机制 + 数据上报 | 签到/任务/段位 + 抖音云函数 |
| Week 4 | 美术外包 + 审核准备 | 提交审核 + 软著办理启动 |

### Month 1 DoD

- ✅ Game 1 提交审核（不要求过审）
- ✅ 软著办理启动（预计 2-4 周下证）
- ✅ 至少 1 篇博客草稿（候选主题见下）
- ✅ ≥ 4 条抖音视频发布

---

## 四、候选发布主题（M1 期间可挑选 1-2 个）

### 中文长文候选（知乎/掘金）

1. **"TS 开发者第一次做抖音小游戏，5 个我没想到的坑"**（Day 5 萃取）
2. **"为什么抖音小游戏 70% 流量来自挂载视频，而不是推荐位"**（Day 6 萃取）
3. **"Cocos vs Unity：单兵开发选型决策"**（Week 2 萃取）

### 英文 blog 候选（个人站/Medium）

1. **"Week 1 of Building a Douyin Mini-Game: A TS Developer's Field Notes"**
2. **"Why I Chose Cocos Over Unity for Solo Game Development"**

### 深度文候选（M3+ 季度回顾时）

- "Solo Douyin Mini-Game Development: A 3-Month Retrospective"
- "Short-Video Anchor Distribution as a Game Marketing Channel"

---

## 五、三个待决项（建议 Week 2 前回答）

> 这些决策会影响后续内容与流程，请尽快确认。

### 决策 1：GitHub 用户名

- 用于 README 与所有 commit 标识
- 影响：仓库链接、社交分享

### 决策 2：抖音开放平台主体类型

| 选项 | 影响 |
|------|------|
| **个人开发者** | 审核快 / 部分高级功能受限（部分广告位、支付） |
| **企业/个体工商户** | 审核慢 1-2 周 / 解锁全部功能 |

**建议**：若已有 / 计划注册个体工商户，选企业；否则先个人，等 Game 1 有收入再升级。

### 决策 3：美术素材来源

| 选项 | 成本 | 风险 |
|------|------|------|
| **Cocos 商店模板** | 0-100 元 | 版权清晰 / 风格撞车 |
| **Fiverr/闲鱼外包** | 500-2000 元 | 需签版权协议 |
| **AI 生成（Midjourney 等）** | 0-200 元/月 | 商用合规复杂，需逐张确认 |
| **自绘** | 0 | 时间成本高 / 美术水平要求 |

**建议**：Week 1 用 Cocos 默认素材跑通；Week 4 启动外包，预算 1000-2000 元。

---

## 六、Day 1 启动口令

完成 72h 第一项后回复我：

```
Day 1 done：环境安装完成 + GitHub 仓库已创建 + 首次 commit 已 push
仓库链接：https://github.com/<your-name>/douyin-minigame-lab
```

我会启动首次 review 并给出 Day 2 的细化建议。

---

## 七、若完全卡住

72h 内若任一项无法推进（如抖音开放平台注册审核 > 48h），**不要原地等待**：

- 跳过该项
- 继续推进后续项
- 在 journal.md 中标注 "Day N 跳过 X，环境受限"
- 给我留言同步情况

**核心原则**：环境的临时卡壳不应阻塞开发节奏。
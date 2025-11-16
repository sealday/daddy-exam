# 育儿知识答题学习应用（Flutter）

简体中文 | [English](./README_EN.md)

一个面向新手父母与备孕/备育家庭的轻量化“做题学育儿”应用。通过阶段化题库、即时反馈与错题复习，帮助用户以每天 5-10 题的节奏建立系统的育儿认知。

> 平台策略：当前专注于 iOS 版本的体验与发布，但代码尽量保持跨平台，不引入 iOS 专有 API；如必须引入，将提供替代实现或降级方案。

> 版权与许可：本项目所有权归 `sealday <sealday@gmail.com>` 所有，并以 Apache-2.0 开源协议发布（详见下文）。

## 功能概览
- 阶段分类：小月龄（0-6个月）、6个月-1岁、1-3岁
- 题库类型：单选/多选；题干、选项、正确答案、解析、阶段与分类标签（营养/睡眠/运动/认知/社交…）
- 做题学习：随机出题、进度展示、即时判题与解析、实用小贴士
- 错题本：自动收集错题，支持查看解析与删除
- 学习统计：阶段完成度进度条与饼状图概览
- 数据持久化：本地存储做题进度、错题、每日做题数量

## 技术栈
- Flutter 3（多端）
- 状态管理：基于 `StatefulWidget` 的轻量实现
- 本地存储：`shared_preferences`
- 图表展示：`fl_chart`

## 目录结构
```
lib/
  main.dart
  models/
    question.dart        # 题目模型
    stage.dart           # 阶段模型
  services/
    question_service.dart # 题库加载（assets/questions.json）
    storage_service.dart  # 本地存储封装（错题、进度、每日做题）
  screens/
    home_screen.dart       # 首页（阶段选择、入口导航）
    quiz_screen.dart       # 答题页（单/多选、进度、提交）
    result_screen.dart     # 结果页（得分、解析、贴士）
    stats_screen.dart      # 统计页（阶段完成度、饼状图）
    wrong_questions_screen.dart  # 错题本列表
    quiz_detail_screen.dart      # 题目详情（用于错题解析）
assets/
  questions.json          # 题库（可直接扩展）
```

## 运行与开发
1) 安装依赖
```bash
cd /Users/seal/Documents/projects/flutter-demo/flutter_application_1
flutter pub get
```

2) 运行到设备/模拟器
```bash
flutter run
```
常用：
```bash
flutter devices          # 查看设备
flutter run -d "iPhone 15"  # 指定设备
```

3) iOS（首次或添加插件后）
```bash
cd ios && pod install && cd ..
flutter clean
flutter pub get
flutter run
```
注意：MissingPluginException 多因仅使用了 “热重载” 导致。添加/变更插件后需“完全重启构建”（clean + run）。

## 题库扩展
- 题库文件：`assets/questions.json`
- `pubspec.yaml` 已声明：
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/questions.json
```
- 题目 JSON 示例：
```json
{
  "id": 1,
  "stage": "0-6个月",
  "question": "宝宝多大开始翻身？",
  "options": ["1个月", "3个月", "6个月", "9个月"],
  "answer": "3个月",
  "explanation": "一般宝宝在3个月左右开始尝试翻身...",
  "tip": "清醒时做俯卧练习，逐步延长时间",
  "category": "运动"
}
```
说明：
- 多选题使用英文逗号分隔正确答案：`"answer": "A,B"`
- 可选字段：`tip`
- 阶段需与 `stage.dart` 中的 `ageRange` 一致（如：`"0-6个月"`、`"6个月-1岁"`、`"1-3岁"`）

## 已实现清单
- [x] 阶段选择与题库加载
- [x] 单/多选答题、即时反馈与解析
- [x] 做题进度与结果页（得分、逐题解析）
- [x] 错题本（查看/删除）
- [x] 学习统计（阶段完成度、饼状图）
- [x] 本地存储（进度、错题、每日答题数量）

## 开发者指南
- 代码风格：遵守 Flutter 官方 lints（`flutter_lints`）
- 本地存储键位均在 `storage_service.dart` 内集中管理
- UI 色彩采用温暖色系（粉色/浅色渐变），适配父母群体

## Roadmap
短期：
- [ ] 题目检索与按分类练习（营养/睡眠/运动/认知/社交）
- [ ] 每日任务/打卡与勋章
- [ ] 导出错题与分享成绩卡片

中长期（AI & 社区）：
- [ ] AI 构建题库能力：从权威资料/书籍生成题目与解析，并支持人工校验
- [ ] 社区讨论：题目下的讨论区与家长经验分享
- [ ] 易错题挖掘：统计群体错误率，动态加入“易错题训练”
- [ ] 高质量题目机制：基于反馈/正确率/专家评审的题目质量分
- [ ] 无效异议题目处理：异常题目申诉、快速下架与修订流程
- [ ] 多端数据同步与用户体系（登录/云端进度）

## 贡献
欢迎提 Issue/PR：
- Bug 修复、性能优化、UI/文案改进
- 新题目与解析（需注明来源或依据）
- 新功能提案（尤其与 Roadmap 相符的能力）

## 许可
本项目以 Apache License 2.0 开源发布：
- Copyright © 2025 `sealday <sealday@gmail.com>`
- 许可证全文见仓库根目录的 `LICENSE`
- 贡献代码即表示你同意以 Apache-2.0 许可你的贡献

更多政策与流程：
- 贡献指引：见 `CONTRIBUTING.md`
- 行为准则：见 `CODE_OF_CONDUCT.md`

---
更多 Flutter 资源：
- 文档：<https://docs.flutter.dev/>
- Cookbook：<https://docs.flutter.dev/cookbook>

贡献指南 (CONTRIBUTING)

本项目所有权：`sealday <sealday@gmail.com>`
协议：Apache License 2.0（贡献即表示同意以 Apache-2.0 授权你的代码/文档/素材）。

目标与平台策略
- 当前专注 iOS 端体验与发布，但尽量保持跨平台（Android/Web/桌面）代码可行。
- 如引入平台特有能力，请提供：
  - 能力检测与降级策略；或
  - 对其它平台的等效/近似实现；或
  - 清晰的编译开关与说明。

如何参与
1) 提 Issue
   - 使用清晰标题与最小复现步骤（如是功能提案，说明使用场景与价值）。
   - 与 Roadmap 对齐更易被优先处理（见 README/README_EN）。
2) 提交 PR
   - 从最新 main 分支创建 feature/fix 分支（命名示例：`feat/stage-filter`, `fix/ios-missing-plugin`）。
   - 保持小步提交，提交信息建议遵循 Conventional Commits：
     - `feat: ` 新功能
     - `fix: ` 缺陷修复
     - `docs: ` 文档
     - `refactor: ` 重构（无功能变化）
     - `style: ` 风格（代码格式、命名，不影响逻辑）
     - `chore: ` 脚手架、配置、依赖
   - 保持构建可通过、无 lint 错误。
   - 变更影响 UI/数据结构时，请补充/更新 README 或注释。

代码与数据规范
- 代码风格：遵循 `flutter_lints`；命名清晰、变量语义明确。
- 控制层级不超过 2-3 层，尽量使用早返回；避免无意义 try/catch。
- 注释仅用于“不易从代码直观推断”的关键点、边界与约束。
- 题库数据（`assets/questions.json`）字段：
  - `id`（int）唯一
  - `stage`（string）须与 `stage.dart` 的 `ageRange` 一致（如 `"0-6个月"`）
  - `question`（string）题干
  - `options`（string[]）选项
  - `answer`（string）正确答案；多选用英文逗号分隔，如 `"A,B"` 或直接填文本选项
  - `explanation`（string）解析
  - `tip`（string，可选）实用小贴士
  - `category`（string）如 营养/睡眠/运动/认知/社交/健康

依赖与插件
- 优先选择跨平台包；如仅 iOS 可用，需说明并提供降级。
- 添加/变更插件后请验证：
  - `flutter clean && flutter pub get && (cd ios && pod install && cd ..) && flutter run`
  - 避免仅依赖热重载，防止 MissingPluginException。

测试与验证
- 本项目当前以手动验证为主：
  - iOS 模拟器/真机：基本流程（阶段选择→做题→提交→结果→统计→错题本）
  - 扩展题库后，随机出题是否合理、解析展示与错题收集是否正确

安全与内容
- 题目与解析应基于权威来源（鼓励在 PR 描述中注明）。
- 禁止包含个人敏感信息（PII）或侵犯版权的内容。

版权与归属
- 你保证对提交内容拥有相应权利，并以 Apache-2.0 许可授予本项目使用。

沟通
- 一般问题与建议：提交 Issue
- 违规/紧急事项：联系维护者 `sealday@gmail.com`

感谢你的贡献！


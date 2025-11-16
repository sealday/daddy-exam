GitHub Pages（main 分支 /docs）快速发布指引

1) 提交并推送以下目录到仓库：
   - `docs/index.html`
   - `docs/privacy-policy.zh.md`
   - `docs/privacy-policy.en.md`（可选）

2) 打开 GitHub 仓库 → Settings → Pages：
   - Source：选择 `Deploy from a branch`
   - Branch：选择 `main` 分支；`/docs` 目录
   - 保存

3) 等待 1-3 分钟，生效后会生成站点链接：
   - `https://<你的GitHub用户名>.github.io/<仓库名>/`
   - 隐私政策中文链接（用于应用设置页）：
     - `https://<你的GitHub用户名>.github.io/<仓库名>/privacy-policy.zh`

4) 将应用内的隐私政策链接替换为你的实际地址：
   - 位置：`lib/screens/settings/about_screen.dart` → `privacyUrl`

5) 验证
   - 浏览器打开上述链接，确认可访问；
   - 应用内点击“隐私政策”按钮可跳转到网页。



# GitHub Actions AI 自动化配置指南

## 1. 前置准备
- 确保你的 GitHub 账户已启用 **GitHub Copilot** 订阅（个人版或企业版）。
- 本工作流使用 `GITHUB_TOKEN` 进行鉴权，无需额外设置 Secrets。

## 2. 文件结构
将 `.github/workflows/ai-summary.yml` 放入你的仓库根目录。

## 3. 自定义提示词 (Prompt)
在 `ai-summary.yml` 的 `Run AI Analysis` 步骤中，修改 `-p` 后面的内容即可改变 AI 的任务：
- **代码审查**: "Review the changed files in the latest commit. Check for security vulnerabilities and code style issues."
- **Issue 分类**: "Read the latest open issues. Categorize them into 'Bug', 'Feature', or 'Question' based on their content."

## 4. 安全注意事项
- **权限最小化**: 默认只授予 `contents: read`。如果 AI 需要提交代码或评论 Issue，请谨慎添加 `contents: write` 或 `issues: write`。
- **沙箱执行**: 本配置使用 `--no-ask-user`，请确保提示词不会诱导 AI 执行破坏性 shell 命令。建议在生产环境先通过 `workflow_dispatch` 手动测试。

## 5. 扩展建议
- 结合 `jules-action` 或 `codex-action` 可实现更复杂的代码生成与执行逻辑，但需配置额外的 API Key 和安全策略。
- 对于大型模型推理任务，建议将计算密集型步骤移至 Azure ML 或外部服务，GitHub Actions 仅作为触发器。

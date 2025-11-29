# 获取命令行参数逻辑
# $(MAKECMDGOALS) 是 make 命令行中指定的所有目标列表
# 我们过滤掉 'push', 'help' 和 'checkenv' 这三个真正的目标，剩下的就是用户输入的 message
ARGS = $(filter-out push help checkenv,$(MAKECMDGOALS))

# 定义伪目标，防止与同名文件冲突
.PHONY: push help checkenv

# 默认目标：如果只输入 make，显示帮助
default: help

# -----------------------------------------------------
# Help 指令
# -----------------------------------------------------
help:
	@echo "==========================================================="
	@echo "   Git 快速同步工具 (Makefile + gitpush.sh)"
	@echo "==========================================================="
	@echo "使用方法:"
	@echo "  make push               -> 交互式提交 (打开 Vim/Nano 编辑器)"
	@echo "  make push your message  -> 带信息的提交 (无需引号)"
	@echo "  make push \"message\"     -> 带信息的提交 (带引号)"
	@echo "  make checkenv           -> 运行环境检查 (check_env.sh)"
	@echo "  make help               -> 显示此帮助信息"
	@echo ""
	@echo "示例:"
	@echo "  make push 修复了一个严重的bug"
	@echo "==========================================================="

# -----------------------------------------------------
# Push 指令
# -----------------------------------------------------
push:
	@# 给予脚本执行权限，防止 Permission denied
	@chmod +x gitpush.sh
	@# 执行脚本，并将参数传递进去
	@./gitpush.sh $(ARGS)

# -----------------------------------------------------
# Check Env 指令
# -----------------------------------------------------
checkenv:
	@echo ">>> 正在检查环境..."
	@bash check_env.sh

# -----------------------------------------------------
# 万能规则 (Catch-all target)
# -----------------------------------------------------
# 这个规则非常重要。
# 当你输入 `make push fix bug` 时，make 会认为 'fix' 和 'bug' 是它需要构建的目标。
# 如果没有这个规则，make 会报错 "No rule to make target 'fix'..."
# 这个规则告诉 make：遇到不知道的目标，什么都不做，忽略即可。
%:
	@:
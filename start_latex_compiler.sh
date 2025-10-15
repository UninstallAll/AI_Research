#!/bin/bash

echo "🚀 Starting LaTeX Auto Compiler v2.0..."
echo

# 检查Python是否可用
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 not found! Please install Python3 first."
    exit 1
fi

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 启动LaTeX自动编译器v2.0
python3 "$SCRIPT_DIR/latex_auto_compiler_v2.py" "$SCRIPT_DIR" 
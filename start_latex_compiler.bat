@echo off
echo Starting LaTeX Auto Compiler v2.0...
echo.

:: 检查Python是否可用
python --version >nul 2>&1
if errorlevel 1 (
    echo Python not found! Please install Python first.
    pause
    exit /b 1
)

:: 启动LaTeX自动编译器v2.0
python latex_auto_compiler_v2.py

pause 
# LaTeX 自动编译器 v2.0 使用说明

## 🌟 功能特性

✅ **自动监控** - 实时监控.tex文件变化，保存即编译  
✅ **智能引擎检测** - 自动选择合适的LaTeX引擎（pdflatex/xelatex/lualatex）  
✅ **双重编译** - 自动运行两次编译，确保交叉引用正确  
✅ **错误处理** - 完善的错误提示和Unicode编码支持  
✅ **自动清理** - 编译后自动清理辅助文件  
✅ **防抖动** - 避免频繁保存导致的重复编译  

## 🚀 快速开始

### 1. 启动方法

**Windows用户:**
```bash
# 方法1: 直接运行Python脚本
python latex_auto_compiler_v2.py

# 方法2: 使用批处理文件
start_latex_compiler.bat

# 方法3: 监控指定目录
python latex_auto_compiler_v2.py "NeurIPS_MAAPII_2025"
```

**Linux/macOS用户:**
```bash
# 方法1: 直接运行
python3 latex_auto_compiler_v2.py

# 方法2: 使用shell脚本
./start_latex_compiler.sh

# 方法3: 监控指定目录
python3 latex_auto_compiler_v2.py "NeurIPS_MAAPII_2025"
```

### 2. 使用流程

1. **启动编译器** - 运行上述任一命令
2. **初始编译** - 自动发现并编译现有的.tex文件
3. **开始监控** - 显示"开始监控文件变化..."
4. **编辑文件** - 在你的编辑器中修改.tex文件
5. **保存文件** - 保存后自动触发编译
6. **查看PDF** - 编译完成后PDF会自动更新
7. **停止监控** - 按 `Ctrl+C` 停止

## 📋 系统要求

### 必需软件
- **Python 3.6+** - 运行脚本
- **LaTeX发行版** - 至少以下之一：
  - Windows: MiKTeX 或 TeX Live
  - macOS: MacTeX
  - Linux: texlive-full

### 自动安装的依赖
- `watchdog` - 文件监控库（首次运行时自动安装）

## 🔧 智能引擎选择

编译器会根据文件内容自动选择最合适的LaTeX引擎：

| 文件特征 | 选择引擎 | 原因 |
|---------|---------|------|
| 包含 xeCJK, fontspec | xelatex | 需要高级字体支持 |
| 包含 luatexja, luacode | lualatex | 需要Lua扩展 |
| 包含中文字符 | xelatex | 更好的Unicode支持 |
| 标准LaTeX | pdflatex | 默认引擎，速度最快 |

## 📁 文件结构

```
你的项目目录/
├── latex_auto_compiler_v2.py     # 主编译器脚本
├── start_latex_compiler.bat      # Windows启动脚本
├── start_latex_compiler.sh       # Linux/macOS启动脚本
├── NeurIPS_MAAPII_2025/
│   ├── NeurIPS_MAAPII.tex       # 你的LaTeX文件
│   └── NeurIPS_MAAPII.pdf       # 生成的PDF
└── 其他.tex文件...
```

## 💡 使用技巧

1. **PDF预览自动刷新**: 
   - VS Code: 安装LaTeX Workshop插件，PDF会自动刷新
   - SumatraPDF: 默认支持自动刷新
   - Adobe Reader: 需要手动刷新

2. **编译状态监控**:
   - ✅ 绿色勾号 = 编译成功
   - ❌ 红色叉号 = 编译失败
   - 🔄 = 正在编译中

3. **防止频繁编译**:
   - 内置2秒防抖动机制
   - 避免自动保存导致的重复编译

## 🐛 常见问题

### Q: 编译失败怎么办？
A: 查看终端输出的错误信息，通常是LaTeX语法错误。修复后保存即可自动重新编译。

### Q: PDF没有自动刷新？
A: 确保PDF阅读器支持自动刷新，或手动刷新PDF文件。

### Q: 监控没有反应？
A: 确保文件确实被保存了，某些编辑器的自动保存可能不会触发文件系统事件。

### Q: Unicode编码错误？
A: v2.0版本已解决编码问题，使用`errors='replace'`处理无法解码的字符。

## 🎯 特别为你的NeurIPS论文优化

- ✅ 已测试 `NeurIPS_MAAPII.tex` 编译正常
- ✅ 支持复杂的参考文献格式
- ✅ 自动处理交叉引用和超链接
- ✅ 清理.aux、.log等辅助文件

## 📞 获取帮助

如果遇到问题，请：
1. 检查终端输出的详细错误信息
2. 确认LaTeX发行版已正确安装
3. 尝试手动编译相同文件测试

---

**享受自动编译的便利！🎉** 
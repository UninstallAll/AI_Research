# LaTeX 编译脚本 - Paper.tex (使用XeLaTeX支持中文)
# 使用方法: .\build.ps1

Write-Host "开始编译 Paper.tex (使用XeLaTeX)..." -ForegroundColor Green

# 清理之前的编译文件（可选）
if ($args[0] -eq "-clean") {
    Write-Host "清理之前的编译文件..." -ForegroundColor Yellow
    Remove-Item -Force -ErrorAction SilentlyContinue Paper.aux, Paper.bbl, Paper.blg, Paper.log, Paper.out, Paper.pdf, Paper.synctex.gz
}

# 第一次编译
Write-Host "第一次 xelatex 编译..." -ForegroundColor Cyan
xelatex -synctex=1 -interaction=nonstopmode Paper.tex

if ($LASTEXITCODE -ne 0) {
    Write-Host "第一次编译失败!" -ForegroundColor Red
    exit 1
}

# 处理参考文献
Write-Host "处理参考文献 (bibtex)..." -ForegroundColor Cyan
bibtex Paper

if ($LASTEXITCODE -ne 0) {
    Write-Host "BibTeX 处理失败!" -ForegroundColor Red
    exit 1
}

# 第二次编译 (处理引用)
Write-Host "第二次 xelatex 编译..." -ForegroundColor Cyan
xelatex -synctex=1 -interaction=nonstopmode Paper.tex

# 第三次编译 (确保所有引用正确)
Write-Host "第三次 xelatex 编译..." -ForegroundColor Cyan
xelatex -synctex=1 -interaction=nonstopmode Paper.tex

if ($LASTEXITCODE -eq 0) {
    Write-Host "编译成功! PDF 已生成: Paper.pdf" -ForegroundColor Green
    
    # 检查 PDF 是否存在并显示大小
    if (Test-Path "Paper.pdf") {
        $pdfSize = (Get-Item "Paper.pdf").Length
        Write-Host "PDF 大小: $([math]::Round($pdfSize/1KB, 2)) KB" -ForegroundColor Green
        
        # 尝试打开 PDF (Windows)
        if ($args[0] -eq "-open") {
            Write-Host "正在打开 PDF..." -ForegroundColor Cyan
            Start-Process "Paper.pdf"
        }
    }
} else {
    Write-Host "编译失败!" -ForegroundColor Red
    exit 1
} 
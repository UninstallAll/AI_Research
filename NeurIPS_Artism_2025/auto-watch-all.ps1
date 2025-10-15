# LaTeX 项目自动监视和编译脚本 - 监视所有tex文件
# 使用方法: .\auto-watch-all.ps1
# 按 Ctrl+C 停止监视

param(
    [int]$DelayMs = 10,  # 延迟时间（毫秒）
    [string]$MainFile = "Paper.tex",  # 主tex文件
    [string]$TexPattern = "*.tex"  # tex文件模式
)

Write-Host "🚀 启动LaTeX项目全监视模式" -ForegroundColor Green
Write-Host "监视模式: $TexPattern" -ForegroundColor Cyan
Write-Host "主文件: $MainFile" -ForegroundColor Cyan
Write-Host "编译延迟: ${DelayMs}ms" -ForegroundColor Cyan
Write-Host "按 Ctrl+C 停止监视" -ForegroundColor Yellow
Write-Host ""

# 扫描当前目录中的所有tex文件
$texFiles = Get-ChildItem -Filter "*.tex" | Select-Object -ExpandProperty Name
Write-Host "📄 发现的tex文件:" -ForegroundColor Green
foreach ($file in $texFiles) {
    Write-Host "  - $file" -ForegroundColor White
}
Write-Host ""

if ($texFiles.Count -eq 0) {
    Write-Host "❌ 未找到任何tex文件!" -ForegroundColor Red
    exit 1
}

# 全局变量
$global:compiling = $false
$global:lastCompileTime = Get-Date

# 编译函数
function Invoke-Compilation {
    param([string]$TriggerFile)
    
    if ($global:compiling) {
        Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ⏳ 正在编译中，跳过..." -ForegroundColor Yellow
        return
    }
    
    $global:compiling = $true
    $global:lastCompileTime = Get-Date
    
    Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] 🎯 触发文件: $TriggerFile" -ForegroundColor Cyan
    Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] 🔨 开始编译主文件: $MainFile" -ForegroundColor Green
    
    try {
        # 使用XeLaTeX编译主文件
        Write-Host "  第一次编译..." -ForegroundColor Gray
        $result1 = xelatex -synctex=1 -interaction=nonstopmode -file-line-error $MainFile 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ❌ 第一次编译失败!" -ForegroundColor Red
            Write-Host $result1 -ForegroundColor Red
            return
        }
        
        # 处理参考文献
        $bibFile = $MainFile -replace ".tex$", ""
        Write-Host "  处理参考文献..." -ForegroundColor Gray
        $result2 = bibtex $bibFile 2>&1
        
        # 第二次编译
        Write-Host "  第二次编译..." -ForegroundColor Gray
        $result3 = xelatex -synctex=1 -interaction=nonstopmode -file-line-error $MainFile 2>&1
        
        # 第三次编译
        Write-Host "  第三次编译..." -ForegroundColor Gray
        $result4 = xelatex -synctex=1 -interaction=nonstopmode -file-line-error $MainFile 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            $pdfFile = $MainFile -replace ".tex$", ".pdf"
            $fileSize = if (Test-Path $pdfFile) { [math]::Round((Get-Item $pdfFile).Length / 1KB, 1) } else { "未知" }
            Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ✅ 编译成功! PDF大小: ${fileSize}KB" -ForegroundColor Green
        } else {
            Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ❌ 编译失败!" -ForegroundColor Red
            Write-Host $result4 -ForegroundColor Red
        }
        
    } catch {
        Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ❌ 编译出错: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        $global:compiling = $false
        Write-Host ""
        Write-Host "等待下次文件变更..." -ForegroundColor Yellow
    }
}

# 创建文件系统监视器
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Location).Path
$watcher.Filter = "*.tex"  # 监视所有tex文件
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true
$watcher.IncludeSubdirectories = $false

# 事件处理器
$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    $fileName = [System.IO.Path]::GetFileName($path)
    
    Write-Host "[$($timeStamp.ToString('HH:mm:ss.fff'))] 📝 检测到变更: $fileName ($changeType)" -ForegroundColor Cyan
    
    # 等待指定延迟
    Start-Sleep -Milliseconds $DelayMs
    
    # 防抖检查 - 确保文件写入完成
    $attempts = 0
    $maxAttempts = 5
    $stable = $false
    
    while ($attempts -lt $maxAttempts -and -not $stable) {
        try {
            $currentTime = (Get-Item $path).LastWriteTime
            Start-Sleep -Milliseconds 20
            $finalTime = (Get-Item $path).LastWriteTime
            
            if ($currentTime -eq $finalTime) {
                $stable = $true
            } else {
                $attempts++
                Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ⏳ 等待文件稳定... ($attempts/$maxAttempts)" -ForegroundColor Yellow
            }
        } catch {
            Start-Sleep -Milliseconds 50
            $attempts++
        }
    }
    
    if ($stable) {
        # 触发编译
        Invoke-Compilation -TriggerFile $fileName
    } else {
        Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ⚠️ 文件不稳定，跳过编译" -ForegroundColor Yellow
    }
}

# 注册事件
Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action

try {
    # 执行初始编译
    Write-Host "🔄 执行初始编译..." -ForegroundColor Cyan
    Invoke-Compilation -TriggerFile "初始化"
    
    Write-Host "🔍 监视中... (每10秒显示一个心跳)" -ForegroundColor Green
    Write-Host ""
    
    # 保持脚本运行
    $heartbeatCounter = 0
    while ($true) {
        Start-Sleep -Seconds 1
        $heartbeatCounter++
        
        # 每10秒显示心跳
        if ($heartbeatCounter % 10 -eq 0) {
            if (-not $global:compiling) {
                Write-Host "💚" -NoNewline -ForegroundColor Green
                if ($heartbeatCounter % 100 -eq 0) {
                    Write-Host " [$(Get-Date -Format 'HH:mm:ss')] 监视中..." -ForegroundColor DarkGreen
                }
            }
        }
    }
    
} finally {
    # 清理资源
    Write-Host ""
    Write-Host "🧹 清理监视器..." -ForegroundColor Yellow
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Get-EventSubscriber | Unregister-Event
    Write-Host "✅ 监视已停止" -ForegroundColor Green
} 
# LaTeX 文件自动监视和编译脚本
# 使用方法: .\auto-watch.ps1
# 按 Ctrl+C 停止监视

param(
    [int]$DelayMs = 10,  # 延迟时间（毫秒）
    [string]$WatchFile = "Paper.tex"  # 监视的文件
)

Write-Host "开始监视 $WatchFile，变更后 ${DelayMs}ms 自动编译..." -ForegroundColor Green
Write-Host "按 Ctrl+C 停止监视" -ForegroundColor Yellow
Write-Host ""

# 获取文件的初始修改时间
$lastWriteTime = (Get-Item $WatchFile).LastWriteTime
$compiling = $false

# 创建文件系统监视器
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Location).Path
$watcher.Filter = $WatchFile
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

# 注册事件处理器
$action = {
    $global:compiling = $true
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    
    Write-Host "[$($timeStamp.ToString('HH:mm:ss.fff'))] 检测到文件变更: $changeType" -ForegroundColor Cyan
    
    # 等待指定的延迟时间
    Start-Sleep -Milliseconds $DelayMs
    
    # 检查文件是否还在变更中（避免连续保存导致的重复编译）
    $currentTime = (Get-Item $WatchFile).LastWriteTime
    Start-Sleep -Milliseconds 50  # 额外等待50ms确保文件写入完成
    $finalTime = (Get-Item $WatchFile).LastWriteTime
    
    if ($currentTime -eq $finalTime) {
        Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] 开始自动编译..." -ForegroundColor Green
        
        # 执行编译
        try {
            $result = & ".\build.ps1" 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ✅ 编译成功!" -ForegroundColor Green
            } else {
                Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ❌ 编译失败!" -ForegroundColor Red
                Write-Host $result -ForegroundColor Red
            }
        } catch {
            Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] ❌ 编译出错: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Write-Host ""
        Write-Host "等待下次文件变更..." -ForegroundColor Yellow
    } else {
        Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] 文件仍在变更中，跳过本次编译" -ForegroundColor Yellow
    }
    
    $global:compiling = $false
}

# 注册事件
Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action

try {
    # 初始编译
    Write-Host "执行初始编译..." -ForegroundColor Cyan
    & ".\build.ps1"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 初始编译成功!" -ForegroundColor Green
    } else {
        Write-Host "❌ 初始编译失败!" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "等待文件变更..." -ForegroundColor Yellow
    
    # 保持脚本运行
    while ($true) {
        Start-Sleep -Seconds 1
        
        # 显示状态指示器（每5秒）
        if ((Get-Date).Second % 5 -eq 0) {
            if (-not $compiling) {
                Write-Host "." -NoNewline -ForegroundColor DarkGreen
            }
        }
    }
} finally {
    # 清理资源
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Get-EventSubscriber | Unregister-Event
    Write-Host ""
    Write-Host "监视已停止" -ForegroundColor Yellow
} 
# GitHub 上传指南

## 已完成的清理工作

### 1. 移除的大文件类型
- ✅ 所有视频文件 (.mp4) - 共 222 个文件
- ✅ 软件安装包 (.exe) - NVivo、SPSS、cbox 等
- ✅ 压缩包 (.zip) - SPSS 安装包
- ✅ 大量 DLL 库文件和工具文件

### 2. 创建的 .gitignore
已添加忽略规则,排除以下内容:
- 大型软件安装包和压缩包
- 所有视频文件
- 备份文件和临时文件
- Python/LaTeX 编译产物
- 特定的大型目录

## 当前状态

### 问题
由于之前的提交中包含了大文件,Git 历史仍然很大。建议使用以下两种方案之一:

### 方案 1: 强制推送(推荐用于个人仓库)
```bash
# 删除远程仓库的历史
git push origin main --force
```

### 方案 2: 使用 BFG Repo-Cleaner 清理历史(更安全)
```bash
# 1. 下载 BFG: https://rtyley.github.io/bfg-repo-cleaner/
# 2. 清理大文件
java -jar bfg.jar --strip-blobs-bigger-than 50M .
# 3. 清理 reflog
git reflog expire --expire=now --all && git gc --prune=now --aggressive
# 4. 推送
git push origin main --force
```

### 方案 3: 创建新仓库(最简单)
如果上述方案失败,可以:
1. 在 GitHub 创建新仓库
2. 删除本地 .git 文件夹
3. 重新初始化:
```bash
git init
git add .
git commit -m "Initial commit - cleaned repository"
git remote add origin <your-new-repo-url>
git push -u origin main
```

## 被排除的文件列表

### 大型目录(未上传到 GitHub)
- `IJPP/Nvivo15_win/` - NVivo 软件(~1.1 GB)
- `IJPP/SPSS 27 WIN 64位/` - SPSS 软件(~600 MB)
- `IJPP/InfoSearch/video/` - 视频文件(~3 GB)
- `IJPP/Extra200/` - 额外视频样本(~1 GB)

### 建议
这些大文件应该:
1. **视频文件**: 上传到云存储服务(OneDrive, Google Drive, 百度网盘等)
2. **软件**: 不需要上传,在 README 中说明版本即可
3. **数据文件**: 考虑使用 Git LFS 或单独的数据存储服务

## 上传后的仓库大小
预计清理后的仓库大小: < 100 MB (主要是文档、代码和 Excel 表格)


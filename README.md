# Enable Chrome AI ✨

**一键开启 Chrome 内置 AI 功能，零依赖，开箱即用！**

通过修改 Chrome 的配置文件，无需科学上网即可启用 Chrome 内置的 AI 功能，包括：

- 🤖 **Gemini in Chrome** - Chrome 内置 Gemini 助手
- 🔍 **AI Powered History Search** - AI 驱动的历史记录搜索
- 🛠️ **DevTools AI Innovations** - 开发者工具 AI 功能

## ✨ 特点

| 特性 | 描述 |
|------|------|
| 🚀 **一键执行** | 运行脚本即可自动完成所有配置 |
| 📦 **零额外依赖** | 仅需 macOS 系统自带的 `jq` 工具 |
| 🔄 **自动备份** | 修改前自动创建配置备份，可随时恢复 |
| 🎯 **多版本支持** | 自动检测并配置 Chrome Stable/Canary/Beta/Dev |
| 🛡️ **安全关闭** | 优雅关闭 Chrome 进程，避免数据丢失 |

## 📋 系统要求

- **操作系统**: macOS
- **依赖工具**: `jq` (JSON 处理工具)
- **浏览器**: Google Chrome (任意版本)

## 🚀 快速开始

### 1. 安装依赖

```bash
brew install jq
```

### 2. 克隆仓库

```bash
git clone https://github.com/YOUR_USERNAME/enable-chrome-ai.git
cd enable-chrome-ai
```

### 3. 运行脚本

```bash
chmod +x enable-chrome-ai.sh
./enable-chrome-ai.sh
```

## 📖 使用说明

1. **运行脚本** - 脚本会自动检测已安装的 Chrome 版本
2. **等待处理** - 脚本会自动关闭 Chrome 并修改配置
3. **重启浏览器** - 根据提示决定是否自动重启 Chrome
4. **开始使用** - 重启后即可使用 Chrome AI 功能

### 脚本执行过程

```
==========================================
     Enable Chrome AI - Shell 版本
==========================================

[INFO] 找到 2 个 Chrome 配置文件

[INFO] 正在关闭 Chrome 进程...
[SUCCESS] Chrome 进程已关闭
[INFO] 正在处理: /Users/xxx/Library/Application Support/Google/Chrome/Local State
[INFO] 已创建备份: /Users/xxx/Library/Application Support/Google/Chrome/Local State.backup.20260130100000
[SUCCESS] 设置 variations_country = "us"
[SUCCESS] 设置 variations_permanent_consistency_country = ["1", "us"]
[SUCCESS] 设置所有 is_glic_eligible = true
[SUCCESS] 完成修改: /Users/xxx/Library/Application Support/Google/Chrome/Local State

==========================================
[SUCCESS] 所有修改已完成！
==========================================
```

## 🔧 技术原理

脚本通过修改 Chrome 的 `Local State` 配置文件中的以下字段来启用 AI 功能：

| 字段 | 修改值 | 作用 |
|------|--------|------|
| `variations_country` | `"us"` | 设置地区为美国 |
| `variations_permanent_consistency_country` | `["1", "us"]` | 永久一致性地区设置 |
| `is_glic_eligible` | `true` | 启用 GLIC (Gemini in Chrome) 资格 |

## ⚠️ 注意事项

- 请确保 Chrome 已安装并至少运行过一次（以生成配置文件）
- 修改前会自动创建 `.backup.时间戳` 备份文件
- 如需恢复原始配置，可删除当前 `Local State` 并重命名备份文件
- 此工具与 Google 无关，使用风险自负

## 🔄 恢复原始配置

如果需要恢复原始配置：

```bash
# 查找备份文件
ls ~/Library/Application\ Support/Google/Chrome/Local\ State.backup.*

# 恢复备份（替换为实际的备份文件名）
cp ~/Library/Application\ Support/Google/Chrome/Local\ State.backup.YYYYMMDDHHMMSS \
   ~/Library/Application\ Support/Google/Chrome/Local\ State
```

## 📜 Credit

本项目的实现方法基于 [lcandy2/enable-chrome-ai](https://github.com/lcandy2/enable-chrome-ai)。

原项目使用 Python 实现，需要：
- 安装 `uv` 或 `pip`
- Python 3.13+ 运行环境
- 安装 `psutil` 等依赖包

**本项目的优势**：
- ✅ 无需安装 Python
- ✅ 无需包管理器 (uv/pip)
- ✅ 仅依赖 macOS 常用工具 `jq`
- ✅ 单文件脚本，开箱即用

感谢 [@lcandy2](https://github.com/lcandy2) 发现并分享了启用 Chrome AI 的方法！

## 📄 License

MIT License

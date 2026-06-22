# Enable Chrome AI ✨

一键开启 Chrome 内置 AI 功能，支持 **Windows / macOS / Linux**。

本项目通过修改 Chrome 的 `Local State` 配置文件，启用 Chrome 内置 AI 相关功能，包括：

- 🤖 **Gemini in Chrome**：Chrome 内置 Gemini 助手
- 🔍 **AI Powered History Search**：AI 驱动的历史记录搜索
- 🛠️ **DevTools AI Innovations**：开发者工具 AI 功能

> 本工具会自动备份 Chrome 配置文件，修改前请确保已关闭重要浏览器会话。

---

## 📁 脚本说明

仓库中提供两个脚本，请根据操作系统选择执行：

| 脚本文件 | 适用系统 | 执行方式 |
|---|---|---|
| `enable-chrome-ai.ps1` | Windows | 使用 PowerShell 执行 |
| `enable-chrome-ai.sh` | macOS / Linux | 使用 Shell 执行 |

---

## ✨ 功能特点

| 特性 | 描述 |
|---|---|
| 🚀 一键执行 | 运行对应脚本即可自动完成配置 |
| 🔄 自动备份 | 修改前自动创建 `Local State` 备份文件 |
| 🎯 多版本支持 | 自动检测并配置 Chrome Stable / Canary / Beta / Dev |
| 🛡️ 安全关闭 | 执行前自动关闭 Chrome 进程，避免配置写入冲突 |
| 🖥️ 跨平台支持 | 支持 Windows、macOS、Linux |

---

## 📋 系统要求

### Windows

- 操作系统：Windows 10 / Windows 11
- 运行环境：PowerShell
- 浏览器：Google Chrome

### macOS / Linux

- 操作系统：macOS 或 Linux
- 依赖工具：`jq`
- 浏览器：Google Chrome

---

## 🚀 快速开始

### Windows 执行方式

在 PowerShell 中进入项目目录：

~~~powershell
cd enable-chrome-ai
~~~

执行脚本：

~~~powershell
.\enable-chrome-ai.ps1
~~~

如果遇到 PowerShell 执行策略限制，可使用以下方式执行：

~~~powershell
powershell -ExecutionPolicy Bypass -File .\enable-chrome-ai.ps1
~~~

---

### macOS / Linux 执行方式

#### 1. 安装依赖

macOS：

~~~bash
brew install jq
~~~

Linux：

~~~bash
sudo apt install jq
~~~

或：

~~~bash
sudo yum install jq
~~~

#### 2. 执行脚本

~~~bash
chmod +x enable-chrome-ai.sh
./enable-chrome-ai.sh
~~~

---

## 📖 执行过程示例

~~~text
==========================================
     Enable Chrome AI
==========================================

[INFO] 找到 Chrome 配置文件
[INFO] 正在关闭 Chrome 进程...
[SUCCESS] Chrome 进程已关闭

[INFO] 正在处理 Local State
[INFO] 已创建备份: Local State.backup.20260130100000

[SUCCESS] 设置 variations_country = "us"
[SUCCESS] 设置 variations_permanent_consistency_country = ["1", "us"]
[SUCCESS] 设置所有 is_glic_eligible = true

[SUCCESS] 所有修改已完成
~~~

---

## 🔧 技术原理

脚本会修改 Chrome 配置文件 `Local State` 中的以下字段：

| 字段 | 修改值 | 作用 |
|---|---|---|
| `variations_country` | `"us"` | 将 Chrome 实验地区设置为美国 |
| `variations_permanent_consistency_country` | `["1", "us"]` | 设置永久一致性地区 |
| `is_glic_eligible` | `true` | 启用 Gemini in Chrome 相关资格标记 |

---

## 📂 Chrome 配置文件位置

### Windows

常见路径：

~~~text
C:\Users\<用户名>\AppData\Local\Google\Chrome\User Data\Local State
~~~

### macOS

常见路径：

~~~text
~/Library/Application Support/Google/Chrome/Local State
~~~

### Linux

常见路径：

~~~text
~/.config/google-chrome/Local State
~~~

---

## 🔄 恢复原始配置

脚本执行前会自动生成备份文件，格式类似：

~~~text
Local State.backup.20260130100000
~~~

如需恢复，可关闭 Chrome 后，将备份文件复制回 `Local State`。

### Windows 示例

~~~powershell
copy "Local State.backup.20260130100000" "Local State"
~~~

### macOS / Linux 示例

~~~bash
cp "Local State.backup.20260130100000" "Local State"
~~~

---

## ⚠️ 注意事项

- 请确保 Chrome 已安装，并至少启动过一次，以生成 `Local State` 配置文件。
- 执行脚本前建议保存浏览器中的重要内容。
- 脚本会自动关闭 Chrome 进程。
- 修改后需要重新启动 Chrome 才能生效。
- Chrome AI 功能是否可见，仍可能受到 Chrome 版本、账号、实验开关等因素影响。
- 本工具与 Google 官方无关，使用风险自负。

---

## 📜 Credit

本项目的实现方法参考自：

[lcandy2/enable-chrome-ai](https://github.com/lcandy2/enable-chrome-ai)

原项目使用 Python 实现，本项目提供更轻量的脚本版本：

- Windows 使用 PowerShell 脚本
- macOS / Linux 使用 Shell 脚本

感谢原作者发现并分享启用 Chrome AI 的方法。

---

## 📄 License

MIT License

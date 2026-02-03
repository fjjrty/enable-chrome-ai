#!/bin/bash

# Enable Chrome AI - Shell 版本
# 通过修改 Chrome 的 Local State 文件来启用内置 AI 功能
# 基于 https://github.com/lcandy2/enable-chrome-ai

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 jq 是否安装
check_jq() {
    if ! command -v jq &> /dev/null; then
        log_error "需要安装 jq 来处理 JSON 文件"
        echo "请运行: brew install jq"
        exit 1
    fi
}

# 关闭 Chrome 进程
kill_chrome() {
    log_info "正在关闭 Chrome 进程..."
    
    # 优雅关闭
    osascript -e 'tell application "Google Chrome" to quit' 2>/dev/null || true
    osascript -e 'tell application "Google Chrome Canary" to quit' 2>/dev/null || true
    osascript -e 'tell application "Google Chrome Beta" to quit' 2>/dev/null || true
    osascript -e 'tell application "Google Chrome Dev" to quit' 2>/dev/null || true
    
    # 等待进程退出
    sleep 2
    
    # 如果还有残留进程，强制结束
    pkill -9 -f "Google Chrome" 2>/dev/null || true
    
    sleep 1
    log_success "Chrome 进程已关闭"
}

# 递归设置 is_glic_eligible 为 true
set_glic_eligible() {
    local file="$1"
    local tmp_file="${file}.tmp"
    
    # 使用 jq 递归查找并设置所有 is_glic_eligible 为 true
    jq '
    walk(
        if type == "object" and has("is_glic_eligible") then
            .is_glic_eligible = true
        else
            .
        end
    )
    ' "$file" > "$tmp_file" && mv "$tmp_file" "$file"
}

# 修改 Local State 文件
patch_local_state() {
    local file="$1"
    local backup_file="${file}.backup.$(date +%Y%m%d%H%M%S)"
    
    log_info "正在处理: $file"
    
    # 创建备份
    cp "$file" "$backup_file"
    log_info "已创建备份: $backup_file"
    
    # 创建临时文件
    local tmp_file="${file}.tmp"
    
    # 1. 设置 variations_country 为 "us"
    jq '.variations_country = "us"' "$file" > "$tmp_file" && mv "$tmp_file" "$file"
    log_success "设置 variations_country = \"us\""
    
    # 2. 设置 variations_permanent_consistency_country 为 ["1", "us"]
    jq '.variations_permanent_consistency_country = ["1", "us"]' "$file" > "$tmp_file" && mv "$tmp_file" "$file"
    log_success "设置 variations_permanent_consistency_country = [\"1\", \"us\"]"
    
    # 3. 递归设置所有 is_glic_eligible 为 true
    set_glic_eligible "$file"
    log_success "设置所有 is_glic_eligible = true"
    
    log_success "完成修改: $file"
    echo ""
}

# 重启 Chrome
restart_chrome() {
    log_info "是否需要重启 Chrome? [y/N]"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        open -a "Google Chrome" 2>/dev/null || true
        log_success "Chrome 已重启"
    fi
}

# 主函数
main() {
    echo ""
    echo "=========================================="
    echo "     Enable Chrome AI - Shell 版本"
    echo "=========================================="
    echo ""
    
    check_jq
    
    # Chrome 配置文件路径数组（macOS）
    local chrome_paths=(
        "$HOME/Library/Application Support/Google/Chrome/Local State"
        "$HOME/Library/Application Support/Google/Chrome Canary/Local State"
        "$HOME/Library/Application Support/Google/Chrome Beta/Local State"
        "$HOME/Library/Application Support/Google/Chrome Dev/Local State"
    )
    
    # 收集存在的配置文件
    local found_paths=()
    for path in "${chrome_paths[@]}"; do
        if [[ -f "$path" ]]; then
            found_paths+=("$path")
        fi
    done
    
    if [[ ${#found_paths[@]} -eq 0 ]]; then
        log_error "未找到任何 Chrome 的 Local State 文件"
        log_info "请确保已安装并至少运行过一次 Chrome"
        exit 1
    fi
    
    log_info "找到 ${#found_paths[@]} 个 Chrome 配置文件"
    echo ""
    
    # 关闭 Chrome
    kill_chrome
    
    # 修改每个找到的 Local State 文件
    for path in "${found_paths[@]}"; do
        patch_local_state "$path"
    done
    
    echo "=========================================="
    log_success "所有修改已完成！"
    echo "=========================================="
    echo ""
    
    # 询问是否重启
    restart_chrome
    
    echo ""
    log_info "提示: 重启 Chrome 后，AI 功能应该已经启用"
    log_info "如需恢复，可使用 .backup 备份文件"
}

# 运行
main

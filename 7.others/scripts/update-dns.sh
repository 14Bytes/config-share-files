#!/bin/bash
#
# 自动更新 Dnsmasq 脚本
# 版权 2024 J1nH4ng<jinhang@mail.14bytes.com>

# Globals:
# Arguments:
#  None

HOSTNAME=$1
IP=$2
IP_REGEX="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

function check_usage() {
  # 检测传递的参数个数
  if [ $# -ne 2 ]; then
    echo "使用方法: $0 <hostname> <ip>"
    exit 1
  fi
}

# 判断 IP 地址是否符合规范
function judge_ip_regex() {
  if [[ ! $IP =~ $IP_REGEX ]]; then
    echo "Error: 错误的 IP 地址格式"
    exit 1
  fi
}

# 反转主机名，用于配置文件的生成查找
function reverse_hostname() {
  local IFS="."
  local parts=()
  local result=""
  local len
  local i_default

  read -ra parts <<< "$HOSTNAME"
  len=${#parts[@]}

  if [ $len = 2 ]; then
    i_default=0
  elif [ $len -lt 2 ]; then
    echo "Error: 请输入完整的域名"
    exit 1
  else
    i_default=1
  fi

  for ((i=len-1; i>=i_default; i--)); do
    result="$result.${parts[i]}"
  done

  result="${result:1}"

  echo "Info: 反转后的域名为：$result"
}

# 切换目录
function change_directory() {
  if ! cd /etc/dnsmasq.d/; then
    echo "Error: 切换目录至 /etc/dnsmasq.d 失败"
    exit 1
  fi
}

# 判断记录是否存在
function judge_remain() {
  :
}

# 解析域名 test.com，并写入到 com.test.conf 配置文件在
function update_dns() {
  :
}

# 检查绑定的域名状态
function status_check() {
  :
}

# 函数入口
function main() {
  judge_ip_regex
  judge_remain
  change_directory
  update_dns
  status_check
}

main "$@"

#!/bin/bash
#
# 自动更新 Dnsmasq 脚本
# 版权 2024 J1nH4ng<jinhang@mail.14bytes.com>

# Globals:
# Arguments:
#  None

# 检测传递的参数个数
if [ $# -ne 2 ]; then
  echo "使用方法: $0 <hostname> <ip>"
  exit 1
fi

HOSTNAME=$1
IP=$2

IP_REGEX="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

# 判断 IP 地址是否符合规范
function judge_ip_regex() {
  if [[ ! $IP =~ $IP_REGEX ]]; then
    echo "错误的 IP 地址格式"
    exit 1
  fi
}

# 判断记录是否存在
function judge_remain() {
  :
}

# 解析域名 test.com，并写入到 com.test.conf 配置文件在
function get_hostname() {
  :
}

# 解析需要绑定的 ip
function get_ip() {
  :
}

# 检查绑定的域名状态
function status_check() {
  :
}

# 函数入口
function main() {
  judge_ip_regex
}

main "$@"

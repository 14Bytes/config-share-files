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
REVERSE_HOSTNAME=""
IS_TLD=0


# 检测传递的参数个数
if [ $# -ne 2 ]; then
  echo "使用方法: $0 <hostname> <ip>"
  exit 1
fi

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

  IS_TLD=$i_default

  for ((i=len-1; i>=i_default; i--)); do
    result="$result.${parts[i]}"
  done

  REVERSE_HOSTNAME="${result:1}"

  echo "Info: 反转后的域名为：$REVERSE_HOSTNAME"
}

# 切换目录
function change_directory() {
  echo "Info: 切换目录至 /etc/dnsmasq.d"

  if ! cd /etc/dnsmasq.d/; then
    echo "Error: 切换目录至 /etc/dnsmasq.d 失败"
    exit 1
  fi
}

# 判断记录是否存在
function judge_remain() {
  if [ -e "$REVERSE_HOSTNAME.conf" ]; then
    echo "Info: $REVERSE_HOSTNAME.conf 文件存在，准备查找记录"
    if grep -Er "/$HOSTNAME/" "$REVERSE_HOSTNAME".conf ; then
      echo "Info: 解析记录已存在"
      exit 1
    else
      echo "Info: 记录不存在，执行更新操作"
    fi
  else
    echo "Info: $REVERSE_HOSTNAME.conf 文件不存在，生成新文件"
    touch "$REVERSE_HOSTNAME".conf
    echo "# Domain: $HOSTNAME" >> "$REVERSE_HOSTNAME".conf
    echo "Info: 文件创建完成，写入新的 DNS 解析"
  fi
}

# 解析域名 test.com，并写入到 com.test.conf 配置文件在
function update_dns() {


  case $IS_TLD in
    0)
      sed -i "1a\server=/$HOSTNAME/$IP" "$REVERSE_HOSTNAME".conf
      echo "Info: 配置递归 DNS 解析"
      ;;
    1)
      echo "address=/$HOSTNAME/$IP" >> "$REVERSE_HOSTNAME".conf
      echo "Info: 更新 DNS 解析完成"
      ;;
  esac

  systemctl restart dnsmasq
}

# 检查绑定的域名状态
function status_check() {
  echo "Info: 检查 DNS 解析情况"
  nslookup "$HOSTNAME"
}

# 函数入口
function main() {
  judge_ip_regex
  reverse_hostname
  change_directory
  judge_remain
  update_dns
  status_check
}

# 测试函数
function test() {
  judge_ip_regex
  reverse_hostname
  judge_remain
  update_dns
  status_check
}


test "$@"
# main "$@"

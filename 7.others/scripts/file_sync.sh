#!/bin/bash
#
# nginx 配置文件同步脚本
# 版权 2024 J1nH4ng<jinhang@icloud.com>

# Globals:
# Arguments:
#  None

function check_variables() {
  if [ $# -ne 2 ]; then
    echo "Usage: $0 program-name(nginx|ca|supervisord) protocol-name(ssh|rsync)"
    exit 1
  fi

  PROGRAM="$1"
  PROTOCOL_NAME="$2"
  # TODO: 多个 IP 的循环遍历同步
  IP_DEST="0.0.0.0"
}

function echo_info() {
  echo "使用 SSH 协议进行同步时，请确保服务器之间可以进行横向 SSH 通信，如果不能，请使用 RSYNC 协议"
  echo "使用 RSYNC 协议时，请确保对点服务器的 rsync 进程以守护模式运行中，如果不知道如何配置，请查看文档：【link】"
}

function choose_program() {
  case "$PROGRAM" in
    "nginx")
      # 根据实际情况修改
      DIR_SRC="/usr/local/nginx1.24/"
      DIR_DEST="/usr/local/nginx1.24/"
      echo "将本服务器 ${DIR_SRC} 目录下的 Nginx 配置同步至 ${IP_DEST} 服务器上的 ${DIR_DEST} 目录下"
      ;;
    "ca")
      # 根据实际情况修改
      DIR_SRC="/opt/ca/"
      DIR_DEST="/opt/ca/"
      echo "将本服务器 ${DIR_SRC} 目录下的 ca 证书同步至 ${IP_DEST} 服务器上的 ${DIR_DEST} 目录下"
      ;;
    "supervisord")
      DIR_SRC="/etc/supervisord.d/"
      DIR_DEST="/etc/supervisord.d"
      echo "将本服务器 ${DIR_SRC} 目录下的 supervisord 项目配置同步至 ${IP_DEST} 服务器上的 ${DIR_DEST} 目录下"
      ;;
    "*")
      echo "暂时不支持的同步，联系管理员获得支持，mail: j1nH4ng@icloud.com"
      ;;
  esac
}

function init_md5() {
  :
}

function check_md5() {
  :
}

function rsync_file() {
  case ${PROTOCOL_NAME} in
    "SSH"|"ssh")
      echo "使用 SSH 协议在服务器之间进行 rsync 同步，请确保服务器之间可以进行横向 SSH 通信"
      ;;
    "RSYNC"|"rsync")
      echo "使用 RSYNC 协议在服务器之间进行 rsync 同步"
      ;;
    "*")
      echo "不支持其他协议的同步"
      ;;
  esac
}

# 执行脚本
function execute_script() {
  :
}

function test() {
  echo_info
  choose_program
}

function main() {
  :
}

test "$@"
# main "$@"

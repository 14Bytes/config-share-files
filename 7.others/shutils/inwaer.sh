#!/bin/bash
#
# 错误日志输出格式函数
#
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

function echo_info() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFO]\033[0m - \033[1;32m$1\033[0m"
}

function echo_alert() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

function echo_error_basic() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m$1\n\033[0m"
}

function inwaer_test() {
  echo_info info-test
  echo_alert alert-test
  echo_error_basic error-basic-test
}

inwaer_test "$@"

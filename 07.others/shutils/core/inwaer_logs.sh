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

function echo_info_logs() {
  local SHELL_NAME
  SHELL_NAME=$1
  echo -e "$(date +"%H:%M:%S") [INFO]:${SHELL_NAME}:$2" >> /tmp/shutils.log
}

function echo_alert() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

function echo_alert_logs() {
  local SHELL_NAME
  SHELL_NAME=$1
  echo -e "$(date +"%H:%M:%S") [ALERT]:${SHELL_NAME}:$2" >> /tmp/shutils.log
}

function echo_error_basic() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m$1\n\033[0m"
}

function echo_error_logs() {
  local SHELL_NAME
  SHELL_NAME=$1
  echo -e "$(date +"%H:%M:%S") [ERROR]:${SHELL_NAME}:$2" >> /tmp/shutils.log
}

function inwaer_test() {
  echo_info info-test
  echo_info_logs "$0" "info-test"
  echo_alert alert-test
  echo_alert_logs "$0" "alert-test"
  echo_error_basic error-basic-test
  echo_error_logs "$0" "error-test"

}

inwaer_test "$@"

#!/bin/bash
#
# 删除 X 天之前的文件
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None
function judge_files_can_delete() {
  local X_DAYS
  # 调试参数
  # local X_SECONDS
  local FILE_TAPE
  local DELETE_FILE_NUM
  local CLEAN_DIR

  X_DAYS=$1
  # 调试参数，时间为 60s
  # X_SECONDS=60
  FILE_TAPE=$2
  CLEAN_DIR=$3


}

function clean_test() {
  judge_files_can_delete "30" "*.tar.bz2" "/usr/local/src"
}

clean_test "$@"

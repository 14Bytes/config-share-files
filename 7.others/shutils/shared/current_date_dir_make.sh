#!/bin/bash
#
# 创建当前日期的目录
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

# Usage $0 <dir-path>
function get_input() {
  DIR_PATH=$1
}

function get_current_date() {
  CURRENT_DATE=$(date +"%Y%m%d%H%M%S")
}

function make_date_dir() {
  mkdir "${DIR_PATH}"/"${CURRENT_DATE}"
}

function current_date_path_test() {
  get_input "$1"
  get_current_date
  make_date_dir
}

current_date_path_test "$@"

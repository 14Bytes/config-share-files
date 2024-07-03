#!/bin/bash
#
# 压缩并删除特定时间之前的旧压缩文件
#
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

source ../core/inwaer_logs.sh

function zip_dir() {
  local ZIP_DIR

  ZIP_DIR=$1

  tar -jxvf "${ZIP_DIR}"

  if [ %? -eq 0 ]; then
    echo_info "文件已成功压缩"
    echo_info_logs "$0" "文件已成功压缩"
  else
    echo_error_basic "文件压缩失败，请再次执行或联系管理员处理"
    echo_error_logs "$0" "文件压缩失败，退出执行"
    exit 1
  fi
}

function clean_old_zips() {
  :
}

function main() {
  :
}

main "$@"

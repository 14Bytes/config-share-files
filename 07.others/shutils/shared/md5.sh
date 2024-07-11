#!/bin/bash
#
# 文件的 md5 格式化和检查
# 版权 2024 J1nH4ng<j1nh4ng@icloud.com>

# Globals:
# Arguments:
#  None

source ./../core/inwaer_logs.sh

function init_signal_md5() {
  # 输入文件的绝对路径，例如：/tmp/test.sh
  md5sum "$1" >> "$1.md5"
}

function init_dir_md5() {
  find "$1/*" -type f -print0 | xargs -0 md5sum >> "$1.md5"
}

function check_md5() {
  md5sum -c md5.txt >> md5.check
}

function md5_test() {
  init_signal_md5 /data/test.sh
}

md5_test "$@"

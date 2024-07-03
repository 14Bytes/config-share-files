#!/bin/bash
#
# 使用 Mysqldump 备份 Mysql 数据库
# 版权 2024 J1nH4ng<jinhang@mail.14bytes.com>

# Globals:
#  DB_USR: 数据库用户
#  DB_PASSWD: 数据库密码
#  BACKUP_DIR: 备份文件夹
#  ZIP_DIR: 压缩文件夹
#  LOG_DIR: 日志文件夹
# Arguments:
#  None


# 所有数据库备份
function backup_all_DB() {
  :
}

# 备份单独数据库
function backup_signal_DB() {
  :
}

# 备份其中几个数据库
function backup_some_DB() {
  :
}

function dump_backup_test() {
  :
}

dump_backup_test "$@"

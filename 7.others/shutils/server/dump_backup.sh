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

source ../shared/current_date_dir_make.sh

# 所有数据库备份
function backup_all_DB() {
  local MYSQLDUMP_BIN
  local DB_USER
  local DB_PASSWD
  local BACKUP_DIR
  local CURRENT_DATE

  MYSQLDUMP_BIN=$1
  DB_USER=root
  DB_PASSWD=$2
  BACKUP_DIR=$3
  CURRENT_DATE=$(date +"%Y%m%d%H%M%S")

  "${MYSQLDUMP_BIN}" -u"${DB_USER}" -p"${DB_PASSWD}" --all-databases > "${BACKUP_DIR}"/"${CURRENT_DATE}"/all_databases.sql
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

function dump_backup_main() {
  current_date_path_main "/data/backup"
  backup_all_DB "/usr/local/mysql8.0/bin/mysqldump" "[password]" "/data/backup"
}

# dump_backup_test "$@"
dump_backup_main "$@"

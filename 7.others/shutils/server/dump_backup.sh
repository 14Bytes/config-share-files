#!/bin/bash
#
# 使用 Mysqldump 备份 Mysql 数据库
# 版权 2024 J1nH4ng<jinhang@mail.14bytes.com>

# Globals:
#
# Arguments:
#  None

source ../shared/current_date_dir_make.sh
source ../core/inwaer_logs.sh

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

  echo_info "所有的数据库将会被备份"
  echo_info_logs "$0" "所有数据库被备份"
  "${MYSQLDUMP_BIN}" -u"${DB_USER}" -p"${DB_PASSWD}" --all-databases > "${BACKUP_DIR}"/"${CURRENT_DATE}"/all_databases.sql
  echo_info_logs "$0" "所有数据库备份成功至 ${BACKUP_DIR}/${CURRENT_DATE}/ 目录下"
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

function zip_dir() {
  if tar -jcxf "${BACKUP_DIR}"/"${CURRENT_DATE}".tar.gz "${BACKUP_DIR}"/"${CURRENT_DATE}"/; then
    echo_info "文件已成功压缩"
    echo_info_logs "$0" "文件已经成功压缩"
    echo_alert "${BACKUP_DIR}/${CURRENT_DATE} 目录将会被删除"
    echo_alert_logs "$0" "${BACKUP_DIR}/${CURRENT_DATE} 目录将会被删除"
    rm -rf "${BACKUP_DIR}"/"${CURRENT_DATE:?}"
    echo_alert_logs "$0" "${BACKUP_DIR}/${CURRENT_DATE} 目录被删除"
  else
    echo_error_basic "文件压缩失败，请再次手动执行或联系管理员处理"
    echo_error_logs "$0" "文件压缩失败"
    exit 1
  fi
}

function dump_backup_main() {
  current_date_path_main "/data/backup/mysql"
  backup_all_DB "/usr/local/mysql8.0/bin/mysqldump" "[password]" "/data/backup/mysql"
  zip_dir
}

# dump_backup_test "$@"
dump_backup_main "$@"

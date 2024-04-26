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

# 数据库连接信息
DB_USER=""
DB_PASSWD=""

# 备份文件夹信息
BACKUP_DIR="/backup/mysqldumpbak"
ZIP_DIR="/backup/mysqldumpbak.old"
LOG_DIR="/backup/logs"

# 无需修改的配置部分
SAVED_DAYS=6
CURRENT_DAY=$(date +%Y-%m-%d)

# 初始文件夹
function init() {
  [[ ! -d "${BACKUP_DIR}" ]] && mkdir -p "${BACKUP_DIR}"
  [[ ! -d "${ZIP_DIR}" ]] && mkdir -p "${ZIP_DIR}"
  [[ ! -d "${LOG_DIR}" ]] && mkdir -p "${LOG_DIR}"
  [[ ! -d "${BACKUP_DIR}"/"${CURRENT_DAY}" ]] && mkdir -p "${BACKUP_DIR}"/"${CURRENT_DAY}"
}


function cleanOldBackups() {
  local keepDays

  keepDays=$(date -d "${CURRENT_DAY} - ${SAVED_DAYS} days" +%Y-%m-%d)

  find "${ZIP_DIR}" -name "*.tar.bz2" -type f -exec basename {} \; | while read -r fileName; do
    fileDate=$(echo "${fileName}" | cut -d "-" -f 1-3)
    if [[ "${fileDate}" < "${keepDays}" ]]; then
      echo -e "\033[1;36m${ZIP_DIR}/${fileName}\033[0m \033[1;31m将会被删除\033[0m"
      /usr/bin/rm "${TAR_DIR}/${fileName}"
    fi
  done
}

function zipAndClean() {
  local delDay

  /usr/bin/tar -jcvf "${ZIP_DIR}"/"${CURRENT_DAY}"-mysql-bak.tar.bz2 "${BACKUP_DIR}"/"${CURRENT_DAY}"

  delDay=$(date -d "yesterday" "+%Y-%m-%d")
  echo -e "\033[1;36m${BACKUP_DIR}/${delDay}\033[0m \033[1;31m文件夹将会被删除\033[0m"
  /usr/bin/rm "${BACKUP_DIR}/${delDay}"
}

function bakDB() {
  local line

  /usr/bin/cp /etc/my.cnf /backup/mysqldumpbak

  /usr/bin/mysql -u"${DB_USER}" -p"${DB_PASSWD}" -e "show databases;" | /usr/bin/grep -Ev "Database|information_schema|mysql|sys|performance_schema|redolog|testdb1|testdb2|nacos_config|test|log_center" > /backup/databases.txt
  echo 'szd_filesystem' >> /backup/databases.txt

  while IFS= read -r line; do
    /usr/bin/mysqldump -u"${DB_USER}" -p"${DB_PASSWD}" --log-error="${LOG_DIR}"/"${line}"_mysqldump.log --max-allowed-packet=1073741824 --set-gtid-purged=OFF --master-data=2 --flush-logs --single-transaction -R -e --triggers --databases "${line}" > "${BACKUP_DIR}"/"${CURRENT_DAY}"/"${line}"_mysqldump.sql
  done < "/backup/databases.txt"
}

function main() {
  init
  bakDB
  zipAndClean
  cleanOldBackups
}

main "$@"

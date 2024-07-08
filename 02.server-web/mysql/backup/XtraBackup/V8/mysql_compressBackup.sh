#!/bin/bash
#
# Mysql8.0 XtraBackup 全量备份脚本
#
# 版权 2024 J1nH4ng<jinhang@mail.14bytes.com>

# Globals:
# Arguments:
#  None

DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-P@ssW0rd}"
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_SOCKET="${DB_SOCKET:-/var/lib/mysql.socket}"

function main() {
  :
}

main "$@"

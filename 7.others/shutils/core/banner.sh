#!/bin/bash
#
# 版权输出
# 版权 2024 J1nH4ng<J1nH4ng@icloud.com>

# Globals:
# Arguments:
#  None

function banner() {
  echo -e "\033[1;34m   ________ _____ ____   \033[0m"
  echo -e "\033[1;32m  |___ /_ _|_   _/ ___|  \033[0m"
  echo -e "\033[1;36m    |_ \| |  | | \___ \  \033[0m"
  echo -e "\033[1;31m   ___) | |  | |  ___) | \033[0m"
  echo -e "\033[1;35m  |____/___| |_| |____/  \033[0m"
  echo -e "\033[1;33m                         \n\033[0m"
}

function banner_test() {
  banner
}

banner_test "$@"

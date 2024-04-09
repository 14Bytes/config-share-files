#!/usr/bin/env bash
#set -x
# ================================ !! NOTE !! =======================================
#
#          ____  ___  ___    _______  ___  ___  ___________  _______   ________
#         /  " \(: "||_  |  |   _  "\|"  \/"  |("     _   ")/"     "| /"       )
#        /__|| ||  (__) :|  (. |_)  :)\   \  /  )__/  \\__/(: ______)(:   \___/
#           |: | \____  ||  |:     \/  \\  \/      \\_ /    \/    |   \___  \
#          _\  |     _\ '|  (|  _  \\  /   /       |.  |    // ___)_   __/  \\
#         /" \_|\   /" \_|\ |: |_)  :)/   /        \:  |   (:      "| /" \   :)
#        (_______) (_______)(_______/|___/          \__|    \_______)(_______/
#
#
# 注：该脚本适用于 CentOS、OpenEuler 等系统
# 注：适配 x86 架构
# 注：可能有些小 BUG
#
# Script Name: author_and_banner.sh
#
# Author: J1n H4ng<jinhang@mail.14bytes.com>
# Date: March 29, 2024
#
# Last Editor: J1n H4ng<jinhang@mail.14bytes.com>
# Last Modified:  April 09, 2024
#
# Description: Author and Banner Shell
#
# ==============================================================================

3ITS_VERSION="0.0.1(2024/04/09)"

# Banner Function
function banner() {
  echo -e "\033[1;34m   ________ _____ ____   \033[0m"
  echo -e "\033[1;32m  |___ /_ _|_   _/ ___|  \033[0m"
  echo -e "\033[1;36m    |_ \| |  | | \___ \  \033[0m"
  echo -e "\033[1;31m   ___) | |  | |  ___) | \033[0m"
  echo -e "\033[1;35m  |____/___| |_| |____/  \033[0m"
  echo -e "\033[1;33m                         \n\033[0m"
}

# Information Function
function echo_info() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;32m[INFO]\033[0m - \033[1;32m$1\033[0m"
}

function echo_alert() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;33m[ALERT]\033[0m - \033[1;33m$1\033[0m"
}

function echo_error_basic() {
  echo -e "\033[1;36m$(date +"%H:%M:%S")\033[0m \033[1;31m[ERROR]\033[0m - \033[1;31m$1\n\033[0m"
}

function echo_error_network() {
  echo_error_basic "$name download failed, please check if the network is reachable or try again"
}

function echo_error_installation() {
  echo_error_basic "$name installation failed"
}

function echo_error_git() {
  echo_error_basic "$1 git clone failed, please check if the network is reachable or try again"
}

# Main Function
Banner

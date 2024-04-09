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

# RM_Lock Function
function  Rm_lock() {
  case $Linux_Version in
    *"CentOS"*)

    ;;
    *"OpenEuler"*)
    ;;
    *)
      echo_error_basic "Unsupported system"
    ;;
  esac
}

# System Info Function
function Sys_Info () {
  case "$(uname -m)" in
    *"arm64"* | *"aarch64"*)
      Linux_architecture_Name="Linux-arm64"
    ;;
    *"x86_64"*)
      Linux_architecture_Name="Linux-x86_64"
    ;;
    *)
      echo_error_basic "Unsupported architecture"
      exit 1
    ;;
  esac

  case "$(cat /etc/*-release | head -n 3)" in
    *"CentOS"* | *"centos"*)
      Linux_Version="CentOS"

    ;;
    *"OpenEuler"* | *"openEuler"*)
      Linux_Version="OpenEuler"
    ;;
    *)
      echo_error_basic "Unsupported system"
      echo -e "\033[1;33m\nPlease enter distribution Ubuntu[u] Debian[d] Centos[c] OpenEuler[o]\033[0m" && read -r input
      case $input in
        [uU])
          Linux_Version="Ubuntu"
          echo -e "\033[1;33m\nPlease enter the system version number [22.04] [21.10] [21.04] [20.10] [20.04] [19.10] [19.04] [18.10] [18.04] [16.04] [15.04] [14.04] [12.04]\033[0m" && read -r input
          Linux_Version_Name=$input
        ;;
        [dD])
          Linux_Version="Debian"
          echo -e "\033[1;33m\nPlease enter the system version number [11] [10] [9] [8] [7]\033[0m" && read -r input
          Linux_Version_Name=$input
        ;;
        [cC])
          Linux_Version="CentOS"
          echo -e "\033[1;33m\nPlease enter the system version number [9 Stream] [8 Stream] [8] [7] [6]\033[0m" && read -r input
          Linux_Version_Name=$input
        ;;
        [oO])
          Linux_Version="OpenEuler"
          echo -e "\033[1;33m\nPlease enter the system version number [22.02] [22.02-sp1] [22.02-sp2]\033[0m" && read -r input
          Linux_Version_Name=$input
        ;;
      esac
    ;;
  esac
}

# Main Function
Banner

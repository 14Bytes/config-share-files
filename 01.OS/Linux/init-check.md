# 服务器初始化 check list

## 前提

- [ ] 服务器的架构
  - [ ] arm
  - [ ] x86_64
- [ ] 横向 SSH 是否联通
- [ ] 是否允许升级 SSH
  - [ ] 升级之后堡垒机可能部分功能不可用
- [ ] 是否允许升级 SSL

## 网络关系

- [ ] 是否出网
  - [ ] 后端会请求的网站
  - [ ] 前端访问进入的 IP 地址
  - [ ] 到 squid 代理服务器

## 基本设置

- [ ] 新建虚拟机时配置 never stop 选项
- [ ] 修改仓库源
- [ ] 关闭防火墙或打开防火墙端口
- [ ] 关闭 selinux
- [ ] 升级 openssl
- [ ] 升级 openssh
  - [ ] 9.8版本以上
- [ ] 挂载磁盘
- [ ] 修改文件最大打开数
- [ ] 配置服务器内核和网络设置

## 调优设置

- [ ] supervisord 配置 java 包启动命令优化
  - [ ] G1GC
  - [ ] dumps

## Web 服务器

### 前端

- [ ] nginx
  - [ ] 高可用（是否由硬件支持）
  - [ ] 负载均衡（是否由硬件支持）
- [ ] keepalived
  - [ ] 是否由硬件支持
- [ ] ansible
- [ ] 脚本内容
  - [ ] file_sync.sh
  - [ ] speed_cicd.sh

### 后端

- [ ] nginx
  - [ ] 负载均衡
- [ ] keepalived
  - [ ] 是否由硬件支持
- [ ] supervisord
- [ ] jdk
  - [ ] 版本
- [ ] ansible
- [ ] nfs 存储或者其他存储方式
- [ ] 脚本内容
  - [ ] file_sync.sh
  - [ ] speed_cicd.sh

## Jenkins 服务器

- [ ] jdk11（只由 Jenkins 使用）
- [ ] jenkins
  - [ ] web 界面
  - [ ] 配置 ssh
  - [ ] 配置 git
  - [ ] 使用到的脚本
- [ ] nvm
  - [ ] 确定 nodejs, pnpm 版本（指定版本安装）
  - [ ] node 仓库修改
    - [ ] 阿里云仓库
    - [ ] 自建的私仓
- [ ] maven
  - [ ] 修改仓库
    - [ ] 阿里云仓库
    - [ ] 自建的仓库
- [ ] ansible
  - [ ] 22 端口是否放通
  - [ ] 配置 ansible hosts 文件内容
- [ ] 脚本内容
  - [ ] clean_old_builds.sh

- [ ] Jenkins 无法使用的情况下
  - [ ] 手动打包，半自动脚本部署
  - [ ] 使用 speed-cicd 项目（待编写）

## Mysql 服务器

- [ ] mysql
  - [ ] 确定版本
  - [ ] 架构
    - [ ] 单点
    - [ ] 主主同步
    - [ ] 集群
  - [ ] 备份策略
    - [ ] mysqldump
      - [ ] dump_backup.sh
      - [ ] crontab -e 规则
    - [ ] XtraBackup
      - [ ] 确定版本
      - [ ] 全量备份脚本
      - [ ] 增量备份脚本
- [ ] keepalived
  - [ ] keepalived 脚本

## 中间件服务器

- [ ] redis
  - [ ] 架构
    - [ ] 单点
    - [ ] 集群搭建
- [ ] rabbitmq
- [ ] nacos

## 运维服务器

- [ ] vnc or rdp

## 监控服务器

- [ ] kibana
- [ ] elasticsearch
- [ ] logstash

- [ ] php 7.4
  - [ ] 编译时修改模块解决乱码问题
- [ ] zabbix
  - [ ] 确定版本
  - [ ] 数据库和业务数据库分离
  - [ ] proxy
  - [ ] agent1 or agent2
  - [ ] web 修改解决乱码问题
- [ ] prometheus

## K8S 服务器

- [ ] 前置安装：socat、conntrack
- [ ] K8S 版本
- [ ] kubesphere 版本
- [ ] 以 root 用户权限安装
- [ ] harbor 存储位置
- [ ] dockerhub 拉取镜像代理

## 其他事项

- [ ] 配置代理服务器

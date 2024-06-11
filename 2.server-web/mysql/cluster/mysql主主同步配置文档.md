# mysql 主主同步配置文档

## 前置准备

1. 创建`repl`用户，并给予`replication slave`权限
    ```bash
    create user 'repl'@'%' identified by `[your-password]`;
    grant replication slave on *.* to 'repl'@'%';
    ```
2. 确保两台服务器内`my.cnf`配置项中的`server_id`是不一样的

## 配置同步

1. 导出数据库
    ```bash
    mysqldump -uroot -p[root-password] --routines --single-transaction --source-data=2 --no-autocommit -A > alldatas.sql
    ```
2. 记录主数据库的`MASTER_LOG_FILE`和`MASTER_LOG_POS`
    ```bash
    head -n 30 alldatas.sql | grep MASTER_LOG_FILE
   
    $> -- CHANGE MASTER TO MASTER_LOG_FILE='ON.000001', MASTER_LOG_POS=157;
    ```
3. 对于步骤2，也可以直接在数据库内进行操作
    ```bash
    mysql> show master status\G
    ```

    ```bash
    *************************** 1. row ***************************
                  File: ON.000001
              Position: 157
          Binlog_Do_DB: 
      Binlog_Ignore_DB:
     Executed_Gtid_Set:
     1 row in set (0.02 sec)
    ```
4. 在两台服务器上停止同步
    ```bash
    mysql> stop slave;
    mysql> reset slave all;
    mysql> show slave status\G
    ```
5. 将备份数据导入到数据库2中
    ```bash
    mysql -uroot -p[root-password] < alldatas.sql
    ```
6. 在数据库2中指向数据库1
    ```bash
    mysql> reset master;
    mysql> show master status\G
   
    mysql> 
    CHANGE MASTER TO
    MASTER_HOST='[数据库1的 IP]',
    MASTER_USER='repl',
    MASTER_PASSWORD='[repl-password]',
    MASTER_PORT=3306,
    MASTER_LOG_FILE='[数据库1中的信息]',
    MASTER_LOG_POS=[数据库1中的信息];
    
    mysql> start slave;
    mysql> show slave status\G
    ```
7. 在数据库1中执行相同的操作
8. 查看同步情况
    ```bash
    mysql> show slave status\G
    ```
   
    ```bash
    *************************** 1. row ***************************
           Slave_IO_State: Waiting for source to send event
              Master_Host: 192.168.150.107
              Master_User: repl
              Master_Port: 3306
            Connect_Retry: 60
          Master_Log_File: ON.000001
      Read_Master_Log_Pos: 530
           Relay_Log_File: host-192-168-150-106-relay-bin.000010
            Relay_Log_Pos: 319
    Relay_Master_Log_File: ON.000001
         Slave_IO_Running: Yes      # 这里显示 Yes 表示成功
        Slave_SQL_Running: Yes      # 这里显示 Yes 表示成功，配置一台服务器时也会同时显示 Yes，并不是同时配置完成时才会显示
    ```

## 配置 keepalived 保证高可用

1. 安装服务活性检测软件
    ```bash
    yum install psmisc -y
    ```
2. 创建脚本
    ```bash
    mkdir -pv /usr/local/keepalived2.2/scripts
    touch /usr/local/keepalived2.2/scripts/check-mysql.sh
    chmod +x /usr/local/keepalived2.2/scripts/check-mysql.sh

    vim /usr/local/keepalived2.2/scripts/check-mysql.sh
    ```
3. 脚本内容如下
    ```shell
    #!/bin/bash
    
    # 若 mysql 进程不存在，则停止 keepalived 服务
    killall -0 mysqld &>/dev/null
    
    if [ $? -ne 0 ];then    # 判断上一条指令的状态码，若状态码为0则服务存活，否则服务未启动
        /etc/init.d/mysqld start
        sleep 1s    # mysql_safe启动mysqld进程需要一定的时间
        killall -0 mysqld &>/dev/null
        if [ $? -ne 0 ];then
            systemctl stop keepalived
        fi
    fi
    ```
4. 创建 keepalived 配置文件
    ```shell
    ! Configuration File for keepalived
    
    global_defs {
        router_id Mysql-1-106 #参照服务器标识命名约定
    }
    
    vrrp_script chk_mysql {
        script "/usr/local/keepalived2.2/scripts/check-mysql.sh"
        interval 2
        fall 2
        rise 1
    }
    
    vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.33.201
        }
        # 防止主备节点的上联交换机禁用了组播，采用 vrrp 单播通告的方式
        unicast_src_ip 192.168.150.106 #本机 IP 地址
        unicast_peer {
            192.168.150.107 #对端节点 IP 地址
        }
        track_script {
            chk_mysql
        }
    }
    ```
5. 在对点服务器上执行相同的操作

## 启动服务

```bash
/etc/init.d/mysql start
systemctl start keepalived
```

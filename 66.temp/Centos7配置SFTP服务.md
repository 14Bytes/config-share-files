背景：
---

因工作上要接收外部机构发来的文件，采取 FTP 的方式保密性差，SFTP 方式则采取了加密了传输，安全性更好。因此需要搭建 SFTP 服务，首选 Linux 环境，本文使用 Centos7 来演示。

一、操作步骤
------

### 环境：

```
[root@localhost ~]# cat /etc/redhat-release
CentOS Linux release 7.4.1708 (Core)
[root@localhost ~]# ssh -V
OpenSSH_7.4p1, OpenSSL 1.0.2k-fips 26 Jan 2017

```

### 1. 创建用户组和用户

```
[root@localhost ~]# groupadd sftp --创建用户组
[root@localhost ~]# useradd -g sftp -s /sbin/nologin sftp1 --创建用户
[root@localhost ~]# passwd sftp1
Changing password for user sftp1.
New password:
[root@localhost ~]# mkdir -p /data/sftp/sftp1
[root@localhost ~]# usermod -d /data/sftp/sftp1 sftp1 --指定用户默认目录

```

### 2. 修改 ssh 服务配置

```
[root@localhost ~]# vi /etc/ssh/sshd_config
-- 在末尾添加
#Subsystem     sftp  /usr/libexec/openssh/sftp-server   --这里注释掉
# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
--从这里开始增加
Subsystem sftp internal-sftp  
Match Group sftp  --匹配用户组
    ChrootDirectory /data/sftp/%u  --限定了访问目录
    X11Forwarding no
    AllowTcpForwarding no
    ForceCommand internal-sftp 

```

### 3. 设置目录权限

```
[root@localhost ~]# chown root:sftp /data/sftp/sftp1  --设置root为目录所有者
[root@localhost ~]# chmod 755 /data/sftp/sftp1  --不能超过755，sftp1可读可执行、不可写（也可设置为644）
[root@localhost ~]# mkdir /data/sftp/sftp1/upload  
[root@localhost ~]# chown sftp1:sftp /data/sftp/sftp1/upload –-设置sftp1为目录所有者
[root@localhost ~]# chmod 755 /data/sftp/sftp1/upload  --sftp1可读可写可执行
[root@localhost ~]# systemctl restart sshd.service –-重启sshd服务，让sshd_config配置生效

```

### 4. 检测登录是否正常

```
[root@localhost ~]# sftp sftp1@127.0.0.1
sftp1@127.0.0.1's password:
Connected to 127.0.0.1.
sftp> exit  --成功！

-- 也可以在windows上也可以用winscp验证登录

```

二、常见报错
------

1. Permmission Denied

原因：（1）密码错误；（2）目录权限设置有问题

2. Broken pipe. Couldn't read packet...

原因：目录权限设置问题。可以用将访问用户的用户组改为 root，看是否还会报错，如果不报错，则就是之前目录权限设置的问题。

三、特殊需求
------

### 1. 增加 SFTP 访问端口

出于安全角度考虑，有外部机构提出不能使用默认 22 端口，要额外新增访问端口。这里以新增 22345 端口为例，只需要再次修改 sshd 配置文件就可以。

```
[root@localhost ~]# vi /etc/ssh/sshd_config
-- 中间位置
# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#
Port 22 --这一行取消注释，保留22端口用于内部远程控制
Port 22345 --端口增加22345

-- 如果开启了防火墙，还需要额外放行端口
[root@localhost ~]# netstat –nlptu
[root@localhost ~]# firewall-cmd --permanent --add-port=22345/tcp  --防火墙放行
success
[root@localhost ~]# systemctl restart firewalld  --重启防火墙
```

最后用 WinSCP 访问新端口 22345 验证链接。

### 2. 用户登录的默认路径可以直接上传文件

默认情况下，用户登录的第一层目录是不能操作的，我们会创建一个 upload 子目录，把所有者赋予用户，用户要上传文件必须要进入 upload 子目录进行。

现在有机构提出要登录后直接可上传文件，去掉进入子目录这一步。搜索网上资料，发现最简单的方式是通过修改 sshd 配置文件中的 ForceCommand internal-sftp 参数。

```
-- 假设用户sftpuser对应默认路径/home/sftpuser，但仅在子目录/home/sftpuser/upload下可上传文件，我们可以让其登录后自动进入upload目录。
[root@localhost ~]# vi /etc/ssh/sshd_config
-- 在最后添加
Match User sftpuser  --匹配用户sftpuser
    ChrootDirectory /home/sftpuser --用户root目录
    AllowTCPForwarding no
    X11Forwarding no
    ForceCommand internal-sftp -d /upload  --登录后自动执行命令进入upload目录，用户仍可回到默认root目录
```

### 3. 添加一个 SFTP 管理员用户，可以访问所有 SFTP 用户目录

随着外部 SFTP 用户增多，需要有个管理员用户来统一查看所有用户的文件。直接用 root 不安全，要新建用户来实现。

```
-- 新建一个sftpadmin用户，归属于root用户组
[root@localhost ~]# useradd -g root sftpadmin --创建用户
[root@localhost ~]# passwd sftpadmin

-- 修改sshd配置文件，配置sftpadmin用户的默认root目录为父目录。假设用户目录为/data/sftpgroup01/sftpuser01，那么父目录就是/data/sftpgroup01。
[root@localhost ~]# vi /etc/ssh/sshd_config
Match User sftpadmin
    ChrootDirectory /data/sftpgroup01 --限定访问目录
    ForceCommand internal-sftp 
    X11Forwarding no
    AllowTcpForwarding no

```

参考：
---

[https://blog.csdn.net/axing2015/article/details/83755143](https://blog.csdn.net/axing2015/article/details/83755143) -- 操作成功

https://blog.csdn.net/tingjie/article/details/80887463 -- 报错如下，应该是目录权限设置问题，待研究。

 ![](https://img2020.cnblogs.com/blog/2076780/202007/2076780-20200716234552966-2095411556.png)

https://www.cnblogs.com/gz9218/p/85d25b3aeaea9b1f8455a889abedfdf2.html  -- 报错：同上

[https://www.cnblogs.com/heqiuyong/p/11072829.html](https://www.cnblogs.com/heqiuyong/p/11072829.html) -- 修改 SSH 服务端口。

https://serverfault.com/questions/910789/chroot-sftp-possible-to-allow-user-to-write-to-current-chroot-directory -- 用户登录后的默认路径可写入

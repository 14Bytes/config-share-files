# **Centos7 搭建 FTP 服务器（vsftpd）**

**1、关闭防火墙**

```bash
systemctl stop firewalld
systemctl disable firewalld
```



**2、关闭 SELINUX**

```bash
setenforce 0
vim /etc/sysconfig/selinux
SELINUX=disabled
```



**3、安装 vsftpd**

```bash
yum -y install vsftpd
```



**4、修改 vsftpd 配置文件**

```bash
cd /etc/vsftpd
vim vsftpd.conf

#是否允许匿名，默认no
anonymous_enable=NO

#这个设定值必须要为YES 时，在/etc/passwd内的账号才能以实体用户的方式登入我们的vsftpd主机
local_enable=YES

#具有写权限
write_enable=YES

#本地用户创建文件或目录的掩码
local_umask=022

#当dirmessage_enable=YES时，可以设定这个项目来让vsftpd寻找该档案来显示讯息！您也可以设定其它档名！
dirmessage_enable=YES

#当设定为YES时，使用者上传与下载日志都会被纪录起来。记录日志与下一个xferlog_file设定选项有关
xferlog_enable=YES
xferlog_std_format=YES

#开启20端口
connect_from_port_20=YES

#这个是pam模块的名称，我们放置在/etc/pam.d/vsftpd
pam_service_name=vsftpd

userlist_enable=YES

#当然我们都习惯支持TCP Wrappers的啦！
tcp_wrappers=YES

#通过搭配能实现以下几种效果：
#①当chroot_list_enable=YES，chroot_local_user=YES时，在/etc/vsftpd.chroot_list文件中列出的用户，可以切换到其他目录；未在文件中列出的用户，不能切换到其他目录。 
#②当chroot_list_enable=YES，chroot_local_user=NO时，在/etc/vsftpd.chroot_list文件中列出的用户，不能切换到其他目录；未在文件中列出的用户，可以切换到其他目录。 
#③当chroot_list_enable=NO，chroot_local_user=YES时，所有的用户均不能切换到其他目录。 
#④当chroot_list_enable=NO，chroot_local_user=NO时，所有的用户均可以切换到其他目录。

chroot_list_enable=NO
chroot_local_user=YES

#不添加下面这个会报错：500 OOPS: vsftpd: refusing to run with writable root inside chroot()
allow_writeable_chroot=YES

#启动被动式联机(passivemode)
pasv_enable=YES
#上面两个是与passive mode 使用的 port number 有关，如果您想要使用65400到65410 这 11 个 port 来进行被动式资料的连接，可以这样设定
pasv_min_port=65400
pasv_max_port=65500

#FTP访问目录
local_root=/data/ftp/
```



**5、创建 ftp 访问用户**

```bash
useradd -d /data/ftp/ -s /sbin/nologin ftpuser
passwd ftpuser
chown -R ftpuser /data/ftp
```



**6、启动 ftp 服务**

```bash
systemctl enable vsftpd
systemctl start vsftpd
systemctl status vsftpd
```



**7、530 Login incorrect 错误调试**

![img](https://chv.yorkzz.com:443/images/2022/05/13/e7eb1b82a91d40009f0f98195ce902e9.png)


把 [vim](https://so.csdn.net/so/search?q=vim&spm=1001.2101.3001.7020) /etc/pam.d/vsftpd 里面的以下内容注释掉，然后重启 vsftpd 服务即可

```
#auth required pam_shells.so
```
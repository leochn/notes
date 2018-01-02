---
title: centos7配置squild正向代理
date: 2017-11-27 12:59:09
tags: [centos7,squild]
---
https://help.aliyun.com/document_detail/25834.html?spm=5176.doc25836.6.556.DfdVy7

squid正向代理
   
阿里云HPC物理机本身不能访问外网，只能通过ECS正向代理访问。

本文档将指导用户如何设置代理服务器。
<!-- more -->
1. 确定IP地址

用户应首先确认这几个IP地址：

ECS外网IP（不便于透露，本文用XXX.XXX.XXX.XXX表示）和内网IP（实验用10.10.10.10）

HPC物理机内网IP（实验用10.239.23.4）

2. 登录ECS跳板机

用户可以用PUTTY工具（Windows环境）或SSH命令（Linux环境）登录ECS，注意应使用ECS外网IP登入。

ssh -l login_name XXX.XXX.XXX.XXX（ECS外网IP）
登录成功后，可以在ECS跳板机上用SSH命令登录HPC物理机：

ssh -l root 10.239.23.4（HPC物理机内网IP）
3. ECS跳板机上部署代理服务器squid

这里选择squid，因为它不仅支持访问HTTP的服务还支持访问HTTPS的服务。

3.1 安装squid

重新开一个终端，登录到ECS跳板机。

直接用yum安装：

yum install squid
默认情况下安装位置在 /usr/sbin/squid

3.2 编辑squid配置文件

用root权限打开 /etc/squid/squid.conf 文件，首先把不需要的内网地址全部注释上，在上面增加一行，添加自己的HPC物理机IP地址，然后把不需要开放的端口注释上，只留下80和443端口，然后增加一行：access_log /var/log/squid/access.log用来记录访问情况。

修改后如下：

......

acl localnet src 10.239.23.4     # 这里增加一行，添加自己的HPC物理机IP地址
#acl localnet src 10.0.0.0/8     # RFC1918 possible internal network，注释上
#acl localnet src 172.16.0.0/12  # RFC1918 possible internal network，注释上
#acl localnet src 192.168.0.0/16 # RFC1918 possible internal network，注释上
#acl localnet src fc00::/7       # RFC 4193 local private network range，注释上
#acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines，注释上

acl SSL_ports port 443
acl Safe_ports port 80           # http服务端口打开
#acl Safe_ports port 21          # ftp可以根据情况是否打开
acl Safe_ports port 443          # https服务端口打开
#acl Safe_ports port 70          # gopher，注释上
#acl Safe_ports port 210         # wais，注释上
#acl Safe_ports port 1025-65535  # unregistered ports，注释上
#acl Safe_ports port 280         # http-mgmt，注释上
#acl Safe_ports port 488         # gss-http，注释上
#acl Safe_ports port 591         # filemaker，注释上
#acl Safe_ports port 777         # multiling http，注释上
acl CONNECT method CONNECT

......

# And finally deny all other access to this proxy
http_access deny all                            # 除上面允许的外，其他一律禁止访问

# Squid normally listens to port 3128
http_port 3128                                  # squid默认监听端口号，可以修改成别的端口号

# Added
access_log /var/log/squid/access.log            # 这里增加一行，用于监控访问记录
保存该文件。

3.3 启动squid

用root权限运行：sudo service squid start

查看squid运行状态：

sudo service squid status
squid (pid 31659) is running...
3.4 设置ECS防火墙

出于节省流量和安全考虑，需要在ECS上设置防火墙规则，将除了HPC物理机之外的所有访问3128端口的请求都挡在防火墙外。

步骤如下：

3.4.1 开启防火墙

CentOS 6: service iptables start
CentOS 7: systemctl start firewalld
3.4.2 添加防火墙规则

首先允许HPC物理机IP地址（本文用10.239.23.4，请根据实际情况修改）访问3128端口:

iptables -I INPUT -s 10.239.23.4  -p TCP --dport 3128 -j ACCEPT
端口3128要和3.2节squid配置文件中的端口设置相同。

然后禁止所有访问3128端口的tcp连接：

iptables -A INPUT -p TCP --dport 3128 -j DROP
然后保存iptables设置：

service iptables save
查看规则是否生效：

iptables -L -n
可以看到新增了两条规则：

target     prot opt source               destination
ACCEPT     tcp  --  10.239.23.4          0.0.0.0/0           tcp dpt:3128
DROP       tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:3128
4. 在HPC物理机上设置代理

回到HPC物理机终端，进行代理设置。

最简单的方式是使用环境变量，假设ECS内网IP为10.10.10.10（用户需要自行替换为真实ECS内网IP），则可以执行：

export http_proxy=http://10.10.10.10:3128

export https_proxy=http://10.10.10.10:3128

注意: 这里的代理服务器端口设置应该和ECS跳板机上squid.conf中监听端口一致，另外必须是ECS内网地址。

也可以将上述语句放入/etc/profile或~/.bashrc实现登录HPC物理机时自动配置代理服务器。

5. 测试

在HPC物理机上使用wget、git clone和yum install测试结果如下：

5.1 测试http的访问

wget http://www.cmake.org/files/v3.3/cmake-3.3.1.tar.gz
--2015-09-29 18:12:52--  http://www.cmake.org/files/v3.3/cmake-3.3.1.tar.gz
Connecting to 120.26.218.226:3128... connected.
Proxy request sent, awaiting response... 200 OK
Length: 6577869 (6.3M) [application/x-gzip]
Saving to: ‘cmake-3.3.1.tar.gz’

100%[========================================================================================================================================>] 6,577,869   28.7KB/s   in 3m 55s

2015-09-29 18:16:47 (27.4 KB/s) - ‘cmake-3.3.1.tar.gz’ saved [6577869/6577869]
可以查看/var/log/squid/access.log文件，找到上述下载的log:

1443530801.311   7144 10.239.23.4 TCP_MISS/200 132972 GET http://www.cmake.org/files/v3.3/cmake-3.3.1.tar.gz - DIRECT/66.194.253.19 application/x-gzip
5.2 测试https的访问

wget https://codeload.github.com/gflags/gflags/tar.gz/v2.1.2
--2015-09-29 18:18:13--  https://codeload.github.com/gflags/gflags/tar.gz/v2.1.2
Connecting to 120.26.218.226:3128... connected.
Proxy request sent, awaiting response... 200 OK
Length: 95716 (93K) [application/x-gzip]
Saving to: ‘v2.1.2’

100%[========================================================================================================================================>] 95,716      78.7KB/s   in 1.2s

2015-09-29 18:18:17 (78.7 KB/s) - ‘v2.1.2’ saved [95716/95716]
可以查看/var/log/squid/access.log文件，找到上述下载的log:

1443531073.042  11238 10.239.23.4 TCP_MISS/200 101394 CONNECT codeload.github.com:443 - DIRECT/192.30.252.145 -
5.3 测试git clone

git clone https://github.com/gflags/gflags.git
Cloning into 'gflags'...
remote: Counting objects: 1772, done.
remote: Total 1772 (delta 0), reused 0 (delta 0), pack-reused 1772
Receiving objects: 100% (1772/1772), 1.27 MiB | 493.00 KiB/s, done.
Resolving deltas: 100% (1013/1013), done.
可以查看/var/log/squid/access.log文件，找到上述下载的log:

1443531119.620  29512 10.239.23.4 TCP_MISS/200 1356342 CONNECT github.com:443 - DIRECT/192.30.252.129 -
5.4 测试yum

# yum install openssl
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyuncs.com
 * extras: mirrors.aliyuncs.com
 * updates: mirrors.aliyuncs.com
Resolving Dependencies
--> Running transaction check
---> Package openssl.x86_64 1:1.0.1e-42.el7.9 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==================================================================================================================================================================================
 Package                                 Arch                                   Version                                             Repository                               Size
==================================================================================================================================================================================
Installing:
 openssl                                 x86_64                                 1:1.0.1e-42.el7.9                                   updates                                 711 k

Transaction Summary
==================================================================================================================================================================================
Install  1 Package

Total download size: 711 k
Installed size: 1.5 M
Is this ok [y/d/N]: y
Downloading packages:
openssl-1.0.1e-42.el7.9.x86_64.rpm                                                                                                                         | 711 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
** Found 1 pre-existing rpmdb problem(s), 'yum check' output follows:
authconfig-6.2.8-9.el7.x86_64 has missing requires of /usr/bin/openssl
  Installing : 1:openssl-1.0.1e-42.el7.9.x86_64                                                                                                                               1/1
  Verifying  : 1:openssl-1.0.1e-42.el7.9.x86_64                                                                                                                               1/1

Installed:
  openssl.x86_64 1:1.0.1e-42.el7.9

Complete!
可以查看/var/log/squid/access.log文件，找到上述yum安装的log：

1443522032.861    129 10.239.23.4 TCP_MISS/200 728129 GET http://mirrors.aliyuncs.com/centos/7/updates/x86_64/Packages/openssl-1.0.1e-42.el7.9.x86_64.rpm - DIRECT/10.143.34.200 application/x-redhat-package-manager
通过以上测试，验证了HPC物理机已经可以通过ECS正向代理访问外网。
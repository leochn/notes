---
title: centos7安装nginx的两种方法
date: 2017-07-22 21:47:13
tags: [nginx,centos7]
---
## centos7安装nginx的两种方法
### 第一种方式：通过yum安装
直接通过 yum install nginx 肯定是不行的,因为yum没有nginx,所以首先把 nginx 的源加入 yum 中.
<!-- more -->

1.将nginx放到yum repro库中
[root@localhost ~]# rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

2.查看nginx信息
[root@localhost ~]# yum info nginx

3.使用yum安装ngnix
[root@localhost ~]# yum install nginx

效果如下：
[root@localhost ~]# yum install nginx
已加载插件：fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirrors.usc.edu
 * extras: mirror.raystedman.net
 * updates: mirror.metrocast.net
正在解决依赖关系
--> 正在检查事务
---> 软件包 nginx.x86_64.1.1.10.1-1.el7.ngx 将被 安装
      ······
      ······
正在安装    : 1:nginx-1.10.1-1.el7.ngx.x86_64        
Thanks for using nginx!
Please find the official documentation for nginx here:
* http://nginx.org/en/docs/

Commercial subscriptions for nginx are available on:
* http://nginx.com/products/

----------------------------------------------------------------------
  验证中      : 1:nginx-1.10.1-1.el7.ngx.x86_64                                                                                 1/1 

已安装:
  nginx.x86_64 1:1.10.1-1.el7.ngx                                                                                     
完毕！

4.启动nginx
[root@localhost ~]# systemctl start nginx

5.查看nginx版本
[root@localhost ~]# nginx -v

6.访问nginx，现在你可以通过公网ip (本地可以通过 localhost /或 127.0.0.1 ) 查看nginx 服务返回的信息。
[root@localhost ~]# curl -i localhost
效果如下：
      ······
Welcome to nginx!。
      ······

7.nginx配置文件位置在/etc/nginx/

### 第二种方式：通过手动下载安装包解压安装
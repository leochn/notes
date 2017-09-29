---
title: centos7安装最新docker
date: 2017-09-29 06:59:15
tags: docker
---

## 前提条件

首先，您需要准备一个CentOS 操作系统（也可以是其它Linux发行版），且能通过SSH客户端工具访问。CentOS 具体要求如下：必须是 64 位操作系统，建议内核在 3.8 以上。通过以下命令，查看您的 CentOS 内核：

<!--more -->

```
uname  -r
```

## 升级内核

如果执行以上命令后，输出的内核版本号低于 3.8，请升级您的Linux 内核至3.10以上，这里不再赘述。

## 安装 Docker引擎

Docker默认的Yum库使用的是main，基本上是稳定的版本，目前该版本为1.10。若想使用最新版的，只需将其baseurl设为https://yum.dockerproject.org/repo/experimental/centos/7/即可。

```bash
[root@ /]# yum install   # 系统版本更新
[root@ /]# cd /etc/yum.repos.d/
[root@ yum.repos.d]# ll
总用量 40
-rw-r--r--. 1 root root 1664 8月  30 23:53 CentOS-Base.repo
-rw-r--r--. 1 root root 1309 8月  30 23:53 CentOS-CR.repo
-rw-r--r--. 1 root root  649 8月  30 23:53 CentOS-Debuginfo.repo
-rw-r--r--. 1 root root  314 8月  30 23:53 CentOS-fasttrack.repo
-rw-r--r--. 1 root root  630 8月  30 23:53 CentOS-Media.repo
-rw-r--r--. 1 root root 1331 8月  30 23:53 CentOS-Sources.repo
-rw-r--r--. 1 root root 3830 8月  30 23:53 CentOS-Vault.repo
-rw-r--r--. 1 root root 1838 4月  27 17:14 mysql-community.repo
-rw-r--r--. 1 root root 1885 4月  27 17:14 mysql-community-source.repo
-rw-r--r--. 1 root root  113 7月  15 2014 nginx.repo
[root@ yum.repos.d]# vi docker.repo   #添加以下内容
```

[root@ yum.repos.d]# vi docker.repo   #添加以下内容

```bash
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
```

执行安装

```bash
[root@ yum.repos.d]#  yum install docker-engine  -y 
已加载插件：fastestmirror
dockerrepo                                                                                       | 2.9 kB  00:00:00     
dockerrepo/primary_db                                                                            |  34 kB  00:00:00     
Loading mirror speeds from cached hostfile
 * base: mirrors.cn99.com
 * extras: mirrors.nju.edu.cn
 * updates: mirrors.nju.edu.cn
正在解决依赖关系
--> 正在检查事务
---> 软件包 docker-engine.x86_64.0.17.05.0.ce-1.el7.centos 将被 安装
--> 正在处理依赖关系 docker-engine-selinux >= 17.05.0.ce-1.el7.centos，它被软件包 docker-engine-17.05.0.ce-1.el7.centos.x86_64 需要
--> 正在处理依赖关系 libcgroup，它被软件包 docker-engine-17.05.0.ce-1.el7.centos.x86_64 需要
--> 正在处理依赖关系 libseccomp.so.2()(64bit)，它被软件包 docker-engine-17.05.0.ce-1.el7.centos.x86_64 需要
--> 正在处理依赖关系 libltdl.so.7()(64bit)，它被软件包 docker-engine-17.05.0.ce-1.el7.centos.x86_64 需要
--> 正在检查事务
---> 软件包 docker-engine-selinux.noarch.0.17.05.0.ce-1.el7.centos 将被 安装
--> 正在处理依赖关系 policycoreutils-python，它被软件包 docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch 需要
---> 软件包 libcgroup.x86_64.0.0.41-13.el7 将被 安装
---> 软件包 libseccomp.x86_64.0.2.3.1-3.el7 将被 安装
---> 软件包 libtool-ltdl.x86_64.0.2.4.2-22.el7_3 将被 安装
--> 正在检查事务
---> 软件包 policycoreutils-python.x86_64.0.2.5-17.1.el7 将被 安装
--> 正在处理依赖关系 setools-libs >= 3.3.8-1，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 libsemanage-python >= 2.5-5，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 audit-libs-python >= 2.1.3-4，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 python-IPy，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 libqpol.so.1(VERS_1.4)(64bit)，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 libqpol.so.1(VERS_1.2)(64bit)，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 libapol.so.4(VERS_4.0)(64bit)，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 checkpolicy，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 libqpol.so.1()(64bit)，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在处理依赖关系 libapol.so.4()(64bit)，它被软件包 policycoreutils-python-2.5-17.1.el7.x86_64 需要
--> 正在检查事务
---> 软件包 audit-libs-python.x86_64.0.2.7.6-3.el7 将被 安装
---> 软件包 checkpolicy.x86_64.0.2.5-4.el7 将被 安装
---> 软件包 libsemanage-python.x86_64.0.2.5-8.el7 将被 安装
---> 软件包 python-IPy.noarch.0.0.75-6.el7 将被 安装
---> 软件包 setools-libs.x86_64.0.3.3.8-1.1.el7 将被 安装
--> 解决依赖关系完成

依赖关系解决

========================================================================================================================
 Package                            架构               版本                                源                      大小
========================================================================================================================
正在安装:
 docker-engine                      x86_64             17.05.0.ce-1.el7.centos             dockerrepo              19 M
为依赖而安装:
 audit-libs-python                  x86_64             2.7.6-3.el7                         base                    73 k
 checkpolicy                        x86_64             2.5-4.el7                           base                   290 k
 docker-engine-selinux              noarch             17.05.0.ce-1.el7.centos             dockerrepo              28 k
 libcgroup                          x86_64             0.41-13.el7                         base                    65 k
 libseccomp                         x86_64             2.3.1-3.el7                         base                    56 k
 libsemanage-python                 x86_64             2.5-8.el7                           base                   104 k
 libtool-ltdl                       x86_64             2.4.2-22.el7_3                      base                    49 k
 policycoreutils-python             x86_64             2.5-17.1.el7                        base                   446 k
 python-IPy                         noarch             0.75-6.el7                          base                    32 k
 setools-libs                       x86_64             3.3.8-1.1.el7                       base                   612 k

事务概要
========================================================================================================================
安装  1 软件包 (+10 依赖软件包)

总下载量：21 M
安装大小：75 M
Downloading packages:
(1/11): audit-libs-python-2.7.6-3.el7.x86_64.rpm                                                 |  73 kB  00:00:00     
(2/11): libcgroup-0.41-13.el7.x86_64.rpm                                                         |  65 kB  00:00:00     
(3/11): libseccomp-2.3.1-3.el7.x86_64.rpm                                                        |  56 kB  00:00:00     
warning: /var/cache/yum/x86_64/7/dockerrepo/packages/docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch.rpm: Header V4 RSA/SHA512 Signature, key ID 2c52609d: NOKEY
docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch.rpm 的公钥尚未安装
(4/11): docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch.rpm                                 |  28 kB  00:00:00     
(5/11): libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm                                                   |  49 kB  00:00:00     
(6/11): libsemanage-python-2.5-8.el7.x86_64.rpm                                                  | 104 kB  00:00:00     
(7/11): python-IPy-0.75-6.el7.noarch.rpm                                                         |  32 kB  00:00:00     
(8/11): setools-libs-3.3.8-1.1.el7.x86_64.rpm                                                    | 612 kB  00:00:01     
(9/11): policycoreutils-python-2.5-17.1.el7.x86_64.rpm                                           | 446 kB  00:00:02     
(10/11): checkpolicy-2.5-4.el7.x86_64.rpm                                                        | 290 kB  00:00:03     
(11/11): docker-engine-17.05.0.ce-1.el7.centos.x86_64.rpm                                        |  19 MB  00:00:32     
------------------------------------------------------------------------------------------------------------------------
总计                                                                                    657 kB/s |  21 MB  00:00:33     
从 https://yum.dockerproject.org/gpg 检索密钥
导入 GPG key 0x2C52609D:
 用户ID     : "Docker Release Tool (releasedocker) <docker@docker.com>"
 指纹       : 5811 8e89 f3a9 1289 7c07 0adb f762 2157 2c52 609d
 来自       : https://yum.dockerproject.org/gpg
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  正在安装    : libcgroup-0.41-13.el7.x86_64                                                                       1/11 
  正在安装    : setools-libs-3.3.8-1.1.el7.x86_64                                                                  2/11 
  正在安装    : checkpolicy-2.5-4.el7.x86_64                                                                       3/11 
  正在安装    : libtool-ltdl-2.4.2-22.el7_3.x86_64                                                                 4/11 
  正在安装    : libseccomp-2.3.1-3.el7.x86_64                                                                      5/11 
  正在安装    : audit-libs-python-2.7.6-3.el7.x86_64                                                               6/11 
  正在安装    : python-IPy-0.75-6.el7.noarch                                                                       7/11 
  正在安装    : libsemanage-python-2.5-8.el7.x86_64                                                                8/11 
  正在安装    : policycoreutils-python-2.5-17.1.el7.x86_64                                                         9/11 
  正在安装    : docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch                                              10/11 
restorecon:  lstat(/var/lib/docker) failed:  No such file or directory
warning: %post(docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch) scriptlet failed, exit status 255
Non-fatal POSTIN scriptlet failure in rpm package docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch
  正在安装    : docker-engine-17.05.0.ce-1.el7.centos.x86_64                                                      11/11 
  验证中      : libsemanage-python-2.5-8.el7.x86_64                                                                1/11 
  验证中      : python-IPy-0.75-6.el7.noarch                                                                       2/11 
  验证中      : audit-libs-python-2.7.6-3.el7.x86_64                                                               3/11 
  验证中      : docker-engine-selinux-17.05.0.ce-1.el7.centos.noarch                                               4/11 
  验证中      : libseccomp-2.3.1-3.el7.x86_64                                                                      5/11 
  验证中      : libtool-ltdl-2.4.2-22.el7_3.x86_64                                                                 6/11 
  验证中      : policycoreutils-python-2.5-17.1.el7.x86_64                                                         7/11 
  验证中      : libcgroup-0.41-13.el7.x86_64                                                                       8/11 
  验证中      : docker-engine-17.05.0.ce-1.el7.centos.x86_64                                                       9/11 
  验证中      : checkpolicy-2.5-4.el7.x86_64                                                                      10/11 
  验证中      : setools-libs-3.3.8-1.1.el7.x86_64                                                                 11/11 

已安装:
  docker-engine.x86_64 0:17.05.0.ce-1.el7.centos                                                                        

作为依赖被安装:
  audit-libs-python.x86_64 0:2.7.6-3.el7                          checkpolicy.x86_64 0:2.5-4.el7                       
  docker-engine-selinux.noarch 0:17.05.0.ce-1.el7.centos          libcgroup.x86_64 0:0.41-13.el7                       
  libseccomp.x86_64 0:2.3.1-3.el7                                 libsemanage-python.x86_64 0:2.5-8.el7                
  libtool-ltdl.x86_64 0:2.4.2-22.el7_3                            policycoreutils-python.x86_64 0:2.5-17.1.el7         
  python-IPy.noarch 0:0.75-6.el7                                  setools-libs.x86_64 0:3.3.8-1.1.el7                  

完毕！
[root@ yum.repos.d]# docker version
Client:
 Version:      17.05.0-ce
 API version:  1.29
 Go version:   go1.7.5
 Git commit:   89658be
 Built:        Thu May  4 22:06:25 2017
 OS/Arch:      linux/amd64
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
[root@ yum.repos.d]# docker -v
Docker version 17.05.0-ce, build 89658be
[root@ yum.repos.d]# yum list installed |grep docker
docker-engine.x86_64                 17.05.0.ce-1.el7.centos        @dockerrepo 
docker-engine-selinux.noarch         17.05.0.ce-1.el7.centos        @dockerrepo 
[root@ yum.repos.d]# systemctl start docker
[root@ yum.repos.d]# docker images         
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[root@ yum.repos.d]#
```



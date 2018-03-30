---
title: centos7配置squid正向代理
date: 2017-11-27 12:59:09
tags: [centos7,squild]
---
## 需求
在一些实验室环境，服务器(内网服务器B)没有直接连接外网的权限，需要通过其他服务器(上网服务器A)进行网络代理。
<!-- more -->

## A服务器安装squid
在能联网的服务器上安装squid,

直接用yum安装：

yum install squid

日志文件: /var/log/squid/access.log文件

查看配置文件
```bash
[root@wpg-ngxs01 squid]# pwd
/etc/squid
[root@wpg-ngxs01 squid]# ll
total 48
-rw-r--r-- 1 root squid   692 Aug  4  2017 cachemgr.conf
-rw-r--r-- 1 root root    692 Aug  4  2017 cachemgr.conf.default
-rw-r--r-- 1 root root   1817 Aug  4  2017 errorpage.css
-rw-r--r-- 1 root root   1817 Aug  4  2017 errorpage.css.default
-rw-r--r-- 1 root root  12077 Aug  4  2017 mime.conf
-rw-r--r-- 1 root root  12077 Aug  4  2017 mime.conf.default
-rw-r----- 1 root squid  2349 Oct 17 16:23 squid.conf
-rw-r--r-- 1 root root   2315 Aug  4  2017 squid.conf.default
[root@wpg-ngxs01 squid]# cat squid.conf
#
# Recommended minimum configuration:
#

# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing
# should be allowed
acl localnet src 10.0.0.0/8 # RFC1918 possible internal network
acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80      # http
acl Safe_ports port 2377    # docker
acl Safe_ports port 21      # ftp
acl Safe_ports port 443     # https
acl Safe_ports port 70      # gopher
acl Safe_ports port 210     # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280     # http-mgmt
acl Safe_ports port 488     # gss-http
acl Safe_ports port 591     # filemaker
acl Safe_ports port 777     # multiling http
acl CONNECT method CONNECT

#
# Recommended minimum Access Permission configuration:
#
# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager

# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost

#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
http_access allow localhost

# And finally deny all other access to this proxy
http_access deny all

# Squid normally listens to port 3128
http_port 3128

# Uncomment and adjust the following to add a disk cache directory.
#cache_dir ufs /var/spool/squid 100 16 256

# Leave coredumps in the first cache dir
coredump_dir /var/spool/squid

#
# Add any of your own refresh_pattern entries above these.
#
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern .       0   20% 4320
[root@wpg-ngxs01 squid]#
```

## 配置B服务器
### 修改.bash_profile信息
```bash
[root@wpg-dock01 watermis]# cd
[root@wpg-dock01 ~]# pwd
/root
[root@wpg-dock01 ~]# touch .bash_profile
[root@wpg-dock01 ~]# cat .bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

http_proxy="http://10.0.0.111:3128"
https_proxy="http://10.0.0.111:3128"

export http_proxy
export https_proxy

[root@wpg-dock01 ~]# source .bash_profile
```

更新刚配置的环境变量: source .bash_profile

### 配置yum.conf
```
[root@wpg-dock01 ~]# cat /etc/yum.conf 
[main]
cachedir=/var/cache/yum/$basearch/$releasever
keepcache=0
debuglevel=2
logfile=/var/log/yum.log
exactarch=1
obsoletes=1
gpgcheck=1
plugins=1
installonly_limit=5
bugtracker_url=http://bugs.centos.org/set_project.php?project_id=23&ref=http://bugs.centos.org/bug_report_page.php?category=yum
distroverpkg=centos-release
proxy=http://10.0.0.111:3128


#  This is the default, if you make this bigger yum won't see if the metadata
# is newer on the remote and so you'll "gain" the bandwidth of not having to
# download the new metadata and "pay" for it by yum not having correct
# information.
#  It is esp. important, to have correct metadata, for distributions like
# Fedora which don't keep old packages around. If you don't like this checking
# interupting your command line usage, it's much better to have something
# manually check the metadata once an hour (yum-updatesd will do this).
# metadata_expire=90m

# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d
[root@wpg-dock01 ~]# 
```



https://help.aliyun.com/document_detail/25834.html?spm=5176.doc25836.6.556.DfdVy7


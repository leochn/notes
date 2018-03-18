---
title: nginx反向代理mysql
date: 2017-11-27 12:46:59
tags: [centos7,nginx,mysql]
---
## nginx反向代理mysql
公司有一个公网ip,那台服务器上装的nginx, mysql装在公司另外一台服务器上假设ip为 192.168.17.131,我想利用公网ip的3308端口去访问内网电脑上mysql,就可以利用nginx 进行代理。

<!-- more -->

### nginx1.9及以上才可以支持tcp协议

在nginx安装路径/nginx-1.9.0/conf 目录下 nginx.conf 文件添加如下代码,

注意下面http中的配置： include /etc/nginx/conf.d/http*.conf;

```bash
[root@localhost nginx]# pwd
/etc/nginx
[root@localhost nginx]# ll
总用量 32
drwxr-xr-x. 2 root root   82 3月  18 16:09 conf.d
-rw-r--r--. 1 root root 1007 7月  11 2017 fastcgi_params
-rw-r--r--. 1 root root 2837 7月  11 2017 koi-utf
-rw-r--r--. 1 root root 2223 7月  11 2017 koi-win
-rw-r--r--. 1 root root 3957 7月  11 2017 mime.types
lrwxrwxrwx. 1 root root   29 7月  21 2017 modules -> ../../usr/lib64/nginx/modules
-rw-r--r--  1 root root  894 3月  18 17:51 nginx.conf
-rw-r--r--. 1 root root  636 7月  11 2017 scgi_params
-rw-r--r--. 1 root root  664 7月  11 2017 uwsgi_params
-rw-r--r--. 1 root root 3610 7月  11 2017 win-utf
[root@localhost nginx]# cat nginx.conf 
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
    # include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/conf.d/http*.conf;
}

#添加Nginx stream支持，代理TCP连接
stream {
    upstream mysql {
        hash $remote_addr consistent;
        server 192.168.17.131:3306 max_fails=3 fail_timeout=30s;
    }   
    server {
        listen 3308;
        proxy_connect_timeout 30s;
        proxy_pass mysql;
    }
}
[root@localhost nginx]# 
```

如果不实现负载均衡，操作更加简单，下面代码是实现用不同端口代理不同mysql的配置.
```bash
stream {
    server {
        listen 3308;
        proxy_connect_timeout 30s;
        proxy_pass 192.168.17.131:3306;
    }
}
```

### 优化配置
在 nginx.conf 配置文件中，配置如下：

注意下面http中的配置： include /etc/nginx/conf.d/http*.conf;

```bash
[root@localhost nginx]# cat nginx.conf 
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
    #  include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/conf.d/http*.conf;
}
#添加Nginx stream支持，代理TCP连接
stream {
    include /etc/nginx/conf.d/*-stream.conf;
}
[root@localhost nginx]#
```

在 /etc/nginx/conf.d 配置：
```bash
[root@localhost conf.d]# pwd
/etc/nginx/conf.d
[root@localhost conf.d]# ll
总用量 8
-rw-r--r--. 1 root root 1299 7月  26 2017 default.conf.bak
-rw-r--r--  1 root root  241 3月  18 19:19 mysql-stream.conf
[root@localhost conf.d]# cat mysql-stream.conf 
    upstream mysql {
        hash $remote_addr consistent;
        server 192.168.17.131:3306 max_fails=3 fail_timeout=30s;
    }   
    server {
        listen 3308;
        proxy_connect_timeout 30s;
        proxy_pass mysql;
    }   
[root@localhost conf.d]# 
```

### 测试效果

![nginx支持tcp代理mysql](/assets/images/mysql/nginx支持tcp代理mysql.png)

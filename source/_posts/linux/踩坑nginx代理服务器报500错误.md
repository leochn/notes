---
title: 踩坑nginx代理服务器报500错误
date: 2019-04-12 10:42:53
tags: [linux,nginx]
---
## 踩坑nginx代理服务器报500错误
在阿里云服务器上面部署nginx作为静态服务器,一切配置好后,按照nginx的配置静态资源地址进行部署,发现最后服务器一直报500错误
<!-- more -->

配置如下：
```
#user  nobody;
worker_processes  1;
events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    #access_log  logs/access.log  main;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       80;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
 
        location /webMis/ {
            root /root/webhtml/mis/;
            try_files $uri $uri/ /webMis/index.html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

    }

}
```

最后突然发现日志中出现了nginx没有权限访问该资源路径,后来把资源路径放到了nginx有访问权限的路径下,然后访问就正常了.

```
location /webMis/ {
    alias /webhtml/mis/;
    try_files $uri $uri/ /webMis/index.html;
    index  index.html index.htm;
}
```

root路径下nginx无法访问,需要将路径改为nginx能访问的地方,或者将这个路径的权限放开也可以解决这个问题,考虑到安全问题就选择放在指定位置,没有解开权限
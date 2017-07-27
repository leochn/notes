---
title: vue-route webpack 部署单页路由项目 访问刷新出现404问题
date: 2017-07-27 09:17:54
tags: [vue,webpack,nginx]
---
## vue-route + webpack 部署单页路由项目,访问刷新出现404问题

### 问题描述
前端使用Vue.js框架,利用vue-route结合webpack编写了一个单页路由项目,在 ```npm run dev``` 命令中,页面访问正常,F5刷新也正常显示页面. ```npm run build``` 后部署到linux系统中,用nginx为web服务器. 部署完成后,访问首页没问题,从首页里打开二级页面没问题,但是所有的二级页面打开后,再次刷新,就会出现404现象!如下：
<!-- more -->

![vue-nginx正常访问](/assets/images/vue/vue-nginx正常访问.png)

![vue-nginx出现404](/assets/images/vue/vue-nginx出现404.png)

### 问题原因
刷新页面时访问的资源在服务端找不到,因为vue-router设置的路径不是真实存在的路径.
如上的404现象,是因为在 nginx 配置的根目录 ```/var/local/vue/dist/``` 下面压根没有 ```/funcset/products``` 这个真实资源存在，这些访问资源都是在js里渲染的。

原 nginx.conf 的配置信息为:
```
server {
    listen       8088;
    server_name  localhost;
    location / {
        root   /var/local/vue/dist/;
        index  index.html index.htm;
    }
}
```

### 问题解决
在nginx配置里添加vue-route的跳转设置(这里首页是index.html),正确配置如下：
```
server {
    listen       8088;
    server_name  localhost;
    location / {
        root   /var/local/vue/dist/;
        index  index.html index.htm;
        try_files $uri $uri/ @router;
    }
    location @router {
        rewrite ^.*$ /index.html last;
    }
}
```

重启nginx后,问题就迎刃而解了.
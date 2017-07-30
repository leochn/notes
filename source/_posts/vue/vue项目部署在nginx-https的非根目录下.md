---
title: vue项目部署在nginx-https的非根目录下
date: 2017-07-27 10:13:50
tags: [vue,nginx,https]
---
## 应用场景
一台liunx系统,安装了nginx,vue项目需要发布为https的服务. 同时nginx的80和443端口的根目录都被tomcat占用了,只能通过nginx 的location 来配置vue的项目.
<!-- more -->

## 解决办法
vue 项目发布在nginx根目录下的方法在前面一篇中已经详细描述。这里的解决办法为:用8088端口的根目录发布vue 项目的http服务，然后在443端口中通过location 来指向 8088 的http服务。(nginx 自己代理自己,感觉蛮奇怪的^_^_)

## 详细过程
### nginx-80.conf 配置 (mc)
如下配置中，80端口根目录被tomcat占用，这里用8088端口来发布vue项目。

```
server {
    listen       80;
    server_name  xxx.com;

    error_page  404              /404.html;

    error_page   500 502 503 504  /50x.html;

    access_log      /var/log/nginx/tomcat/access.log;
    error_log       /var/log/nginx/tomcat/error.log;

    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # tomcat SERVER
    location / {
        sendfile off;
        proxy_pass         http://192.168.1.200:8080/;
        proxy_redirect     default;
        proxy_http_version 1.1;

        proxy_set_header   Host             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_max_temp_file_size 0;

        #this is the maximum upload size
        client_max_body_size       10m;
        client_body_buffer_size    128k;

        proxy_connect_timeout      90;
        proxy_send_timeout         90;
        proxy_read_timeout         90;

        proxy_buffer_size          4k;
        proxy_buffers              4 32k;
        proxy_busy_buffers_size    64k;
        proxy_temp_file_write_size 64k;
    }
    # springboot server
    location ^~ /auth/ {
        proxy_cookie_path       / /auth/;
        proxy_pass http://192.168.1.200:9999/;
        proxy_set_header   HOST             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    }

}
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

### nginx-443.conf 配置 (mc)
443端口被tomcat占用，只能通过nginx location 来配置非根目录的https服务。
注意： vue 节点中的 /mc/ 配置，需要和 vue 项目源码中的配置保持一致。

```
server {
    listen       443;
    server_name  xxx.com;

    # https
    ssl                      on;
    ssl_certificate      "/etc/nginx/sslforfree/bundle.crt";
    ssl_certificate_key  "/etc/nginx/sslforfree/private.key";

    error_page  404              /404.html;
    error_page   500 502 503 504  /50x.html;
    access_log      /var/log/nginx/tomcat/access.log;
    error_log       /var/log/nginx/tomcat/error.log;

    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # tomcat SERVER
    location / {
        sendfile off;
        proxy_pass         http://192.168.1.200:8080/;
        proxy_redirect     default;
        proxy_http_version 1.1;

        proxy_set_header   Host             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_max_temp_file_size 0;

        #this is the maximum upload size
        client_max_body_size       10m;
        client_body_buffer_size    128k;

        proxy_connect_timeout      90;
        proxy_send_timeout         90;
        proxy_read_timeout         90;

        proxy_buffer_size          4k;
        proxy_buffers              4 32k;
        proxy_busy_buffers_size    64k;
        proxy_temp_file_write_size 64k;
    }
    
    # springboot api-server
    location ^~ /metapi/ {
        proxy_pass http://localhost:8089/;
        proxy_set_header   HOST             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    }

    # vue
    location ^~ /mc/ {
        proxy_pass http://localhost:8088/;
        proxy_set_header   HOST             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    }

}
```

### vue 项目配置 (mc)
#### config/index.js 配置
```js
module.exports = {
  build: {
    env: require('./prod.env'),
    index: path.resolve(__dirname, '../dist/index.html'),
    assetsRoot: path.resolve(__dirname, '../dist'),
    assetsSubDirectory: 'static',
    assetsPublicPath: '/mc/',     // 公共静态文件的路径前缀.
    //assetsPublicPath: '/',
    productionSourceMap: true,
    productionGzip: false,
    productionGzipExtensions: ['js', 'css'],
    bundleAnalyzerReport: process.env.npm_config_report
  }
}
```

#### vue-router中的Route配置
```js
const router = new Router({
    base:'/mc/',     // 路由路径的前缀,需要和 nginx 中的配置保持一致.
    mode: 'history', // 切换路径模式，变成history模式
    scrollBehavior: () => ({ y: 0 }), 
    routes
});
```

这几个配置弄好之后，https访问就没有问题了，但是http是无法访问的。













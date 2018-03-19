---
title: vue+webpack+nginx 部署在服务器非根目录
date: 2018-03-20 06:58:36
tags: [vue,nginx]
---
## 应用场景
一台liunx系统,80和443端口的根目录都被其他应用占用了,只能通过nginx 的location 来配置vue的项目.
<!-- more -->

## 解决办法
### vue 项目配置
#### config/index.js 配置
```js
module.exports = {
  build: {
    env: require('./prod.env'),
    index: path.resolve(__dirname, '../dist/index.html'),
    assetsRoot: path.resolve(__dirname, '../dist'),
    assetsSubDirectory: 'static',
    assetsPublicPath: '/cloud/',     // 公共静态文件的路径前缀.
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
    base:'/cloud/',     // 路由路径的前缀,需要和 config/index.js,nginx 中的配置保持一致.
    mode: 'history', // 切换路径模式，变成history模式
    scrollBehavior: () => ({ y: 0 }), 
    routes
});
```

### nginx配置
```bash
server {
    listen       443;
    server_name  web.example.com;
    ssl          on;
    ssl_certificate      "/etc/nginx/ssl_certificate/_.example.com_bundle.crt";
    ssl_certificate_key  "/etc/nginx/ssl_certificate/_.example.com.key";

    error_page  404              /404.html;
    error_page   500 502 503 504  /50x.html;
    
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
    
    access_log      /var/log/nginx/http443/access.log;
    error_log       /var/log/nginx/http443/error.log;
    
    #pass through headers from Jenkins which are considered invalid by Nginx server.
    ignore_invalid_headers off;
    
    location ^~ / {
        proxy_pass          http://10.0.0.27;
        proxy_read_timeout  90;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    # springboot 应用配置
    location ^~ /metaconf/ {
        proxy_pass http://10.0.0.10:9093/;
        proxy_set_header   HOST             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   REMOTE-HOST      $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    }

    # vue 项目配置
    location ^~ /cloud/ {
        alias   /vuefiles/dist/;  # vue项目打包后的静态文件,在linux系统中的地址
        index  index.html index.htm;
        try_files $uri $uri/ /cloud/index.html;

    }
       
    # websocket 配置
    location /wss/{
        proxy_pass http://10.0.0.21:61614;
        proxy_set_header   HOST             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $remote_addr;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade          $http_upgrade;
        proxy_set_header   Connection       "upgrade";
    }
}
```

这几个配置好了，部署就没有问题啦！

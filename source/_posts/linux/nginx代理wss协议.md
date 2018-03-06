---
title: nginx代理wss协议
date: 2018-02-06 11:18:22
tags: [linxu,nginx]
---
## 需求
web项目部署在https服务上，该项目需要连接websocket服务，但是websocket服务是部署在http服务上。所以需要通过nginx代理wss协议。
<!-- more -->

js中MQttClient的options配置
```js
var options = {
    timeout: 3,
    useSSL: true,
    cleanSession: this.cleansession,
    onSuccess: this.onConnect,
    onFailure: function (message) {
        setTimeout(this.MQTTconnect, this.reconnectTimeout);
    }
};
```

![wss连接异常](/assets/images/linux/01-wss连接异常.jpg)

## nginx配置
```
server {
    listen       443;
    server_name  xxx.xxx.com;
    ssl          on;
    ssl_certificate      "/etc/nginx/ssl_certificate/xxxxxxaaaaa.crt";
    ssl_certificate_key  "/etc/nginx/ssl_certificate/xxxxxxaaaaa.key";

    error_page  404              /404.html;
    error_page   500 502 503 504  /50x.html;
    
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
    
    location /wss/{
        proxy_pass http://127.0.0.1:61614;
        proxy_set_header   HOST             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $remote_addr;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade          $http_upgrade;
        proxy_set_header   Connection       "upgrade";
    }
}
```

发现WebSocket协议和HTTP协议虽然不同，但是WebSocket协议的握手和HTTP是兼容的，它使用HTTP的Upgrade协议头将连接从HTTP连接升级到WebSocket连接。这个特性使得WebSocket应用程序可以很容易地应用到现有的基础设施。例如，WebSocket应用可以使用标准的80和443 HTTP端口

配置成功后，就可以进行wss连接：
success => Connected to xxx.xxx.com:443/wss/mqtt


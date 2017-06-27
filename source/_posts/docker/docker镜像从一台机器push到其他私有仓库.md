---
title: docker镜像从一台机器push到其他私有仓库
date: 2017-06-27 16:27:33
tags: docker
---
docker镜像从一台机器push到其他私有仓库
<!-- more -->
## 133虚拟机
```bash
[root@6a9654a02a75 webapps]# cd ROOT
[root@6a9654a02a75 ROOT]# ls 
META-INF  WEB-INF  assets  commons  process-editor  scripts  styles  upload
[root@6a9654a02a75 ROOT]# ls -l
total 32
drwxr-x--- 3 root root 4096 Apr 12 08:14 META-INF
drwxr-x--- 6 root root 4096 Apr 12 08:14 WEB-INF
drwxr-x--- 4 root root 4096 Apr 12 08:14 assets
drwxr-x--- 2 root root 4096 Apr 12 08:14 commons
drwxr-x--- 5 root root 4096 Apr 12 08:14 process-editor
  wxr-x--- 8 root root 4096 Apr 12 08:14 scripts
▽rwxr-x--- 6 root root 4096 Apr 12 08:14 styles
drwxr-x--- 4 root root 4096 Apr 12 08:14 upload
[root@6a9654a02a75 ROOT]# [root@localhost ~]#
[root@6a9654a02a75 ROOT]# [root@localhost ~]# 
[root@localhost ~]# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                    NAMES
6a9654a02a75        jkinfo-tomcat9:v1   "/bin/bash"         About an hour ago   Up About an hour    0.0.0.0:8088->8080/tcp   stupefied_ptolemy
[root@localhost ~]# docker commit -m "centos-tomcat9" 6a9654a02a75 projecty-workflow:v1
sha256:2e0c1d016927052fefbfaad1638b49f146c6bfaad699f9f466da9bbe7d410b59
[root@localhost ~]# docker images
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
projecty-workflow          v1                  2e0c1d016927        15 seconds ago      716 MB
leousst/tomcat9            v2                  10d03584d8e3        4 hours ago         575 MB
jkinfo-tomcat9             v1                  8a58707e98f9        6 hours ago         575 MB
tomcat9fix                 v2                  80af2f8cd9b9        7 hours ago         575 MB
tomcat9fix                 v1                  9eaf3c91c24a        7 hours ago         656 MB
centos-tomcat-dockerfile   v2                  fafa5848ffd4        24 hours ago        656 MB
openjdk                    latest              4c3d59cc5179        3 weeks ago         643 MB
centos-nginx-file          v1                  a8d1298c38a9        4 weeks ago         391 MB
centos-image-nginx         latest              141064f6c5a3        4 weeks ago         394 MB
centos                     latest              67591570dd29        3 months ago        192 MB
[root@localhost ~]# docker tag projecty-workflow 192.168.126.202:5000/projecty-workflow:v1
Error response from daemon: no such id: projecty-workflow
[root@localhost ~]# docker tag projecty-workflow:v1 192.168.126.202:5000/projecty-workflow:v1
[root@localhost ~]# docker images
REPOSITORY                               TAG                 IMAGE ID            CREATED             SIZE
192.168.126.202:5000/projecty-workflow   v1                  2e0c1d016927        3 minutes ago       716 MB
projecty-workflow                        v1                  2e0c1d016927        3 minutes ago       716 MB
leousst/tomcat9                          v2                  10d03584d8e3        4 hours ago         575 MB
jkinfo-tomcat9                           v1                  8a58707e98f9        6 hours ago         575 MB
tomcat9fix                               v2                  80af2f8cd9b9        7 hours ago         575 MB
tomcat9fix                               v1                  9eaf3c91c24a        7 hours ago         656 MB
centos-tomcat-dockerfile                 v2                  fafa5848ffd4        24 hours ago        656 MB
openjdk                                  latest              4c3d59cc5179        3 weeks ago         643 MB
centos-nginx-file                        v1                  a8d1298c38a9        4 weeks ago         391 MB
centos-image-nginx                       latest              141064f6c5a3        4 weeks ago         394 MB
centos                                   latest              67591570dd29        3 months ago        192 MB
[root@localhost ~]# docker push 192.168.126.202:5000/projecty-workflow:v1
The push refers to a repository [192.168.126.202:5000/projecty-workflow]
Get https://192.168.126.202:5000/v1/_ping: http: server gave HTTP response to HTTPS client
###### // 出现上面的情况,需要通过添加daemon.json方式来解决
[root@localhost ~]# cd /etc/docker/
[root@localhost docker]# ll
总用量 4
-rw------- 1 root root 281 2月  19 14:56 key.json
[root@localhost docker]# vim daemon.json
  1 {
  2         "insecure-registries":[
  3                 "0.0.0.0/0"
  4         ]
  5 }
~               
"daemon.json" [新] 5L, 46C 已写入                                                                                        
[root@localhost docker]# service docker restart
Redirecting to /bin/systemctl restart  docker.service
[root@localhost docker]# docker images
REPOSITORY                               TAG                 IMAGE ID            CREATED             SIZE
192.168.126.202:5000/projecty-workflow   v1                  2e0c1d016927        8 minutes ago       716 MB
projecty-workflow                        v1                  2e0c1d016927        8 minutes ago       716 MB
leousst/tomcat9                          v2                  10d03584d8e3        4 hours ago         575 MB
jkinfo-tomcat9                           v1                  8a58707e98f9        6 hours ago         575 MB
tomcat9fix                               v2                  80af2f8cd9b9        7 hours ago         575 MB
tomcat9fix                               v1                  9eaf3c91c24a        7 hours ago         656 MB
centos-tomcat-dockerfile                 v2                  fafa5848ffd4        24 hours ago        656 MB
openjdk                                  latest              4c3d59cc5179        3 weeks ago         643 MB
centos-nginx-file                        v1                  a8d1298c38a9        4 weeks ago         391 MB
centos-image-nginx                       latest              141064f6c5a3        4 weeks ago         394 MB
centos                                   latest              67591570dd29        3 months ago        192 MB
[root@localhost docker]# docker push 192.168.126.202:5000/projecty-workflow:v1
The push refers to a repository [192.168.126.202:5000/projecty-workflow]
885a0dc89b9a: Pushed 
c2e682f3a3ab: Pushed 
448615d3d8c4: Pushed 
62d2c961c519: Pushed 
34e7b85d83e4: Pushed 
v1: digest: sha256:a51523ee14b9648eee67eba7f034bbf38e982c6ca86617594183c2bc36d57888 size: 1375
[root@localhost docker]#
```


## 202 linux机器,在202上有decker的私有仓库

http://192.168.126.202:9000/#/containers/

```bash
[proy@yserver temp]$ docker images | grep projecty-workflow
[proy@yserver temp]$ docker run -i -t -p 8088:8080 192.168.126.202:5000/projecty-workflow:v1
Unable to find image '192.168.126.202:5000/projecty-workflow:v1' locally
v1: Pulling from projecty-workflow
17385548ba54: Pull complete
ab68c3f111b6: Pull complete
d5c7e7c02811: Pull complete
f18760391c47: Pull complete
35fffd013f34: Pull complete
Digest: sha256:a51523ee14b9648eee67eba7f034bbf38e982c6ca86617594183c2bc36d57888
Status: Downloaded newer image for 192.168.126.202:5000/projecty-workflow:v1
[root@f897fc365ce0 /]# ./usr/local/apache-tomcat-9.0.0.M18/bin/startup.sh
Using CATALINA_BASE:   /usr/local/apache-tomcat-9.0.0.M18
Using CATALINA_HOME:   /usr/local/apache-tomcat-9.0.0.M18
Using CATALINA_TMPDIR: /usr/local/apache-tomcat-9.0.0.M18/temp
Using JRE_HOME:        /usr/local/jdk1.8.0_121
Using CLASSPATH:       /usr/local/apache-tomcat-9.0.0.M18/bin/bootstrap.jar:/usr/local/apache-tomcat-9.0.0.M18/bin/tomcat-juli.jar
Tomcat started.
[root@f897fc365ce0 /]#
```

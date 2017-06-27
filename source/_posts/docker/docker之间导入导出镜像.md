---
title: docker之间导入导出镜像
date: 2017-06-27 16:25:31
tags: docker
---
docker之间导入导出镜像
<!--more -->
## 导出镜像：
```
[root@localhost ~]# docker save -o /root/projecty-jkflow.tar projecty-workflow:v2.0.0
```

## 导入镜像：
```
proy@y-ubuntu:~/jkflow$ docker load -i  /home/proy/jkflow/projecty-jkflow.tar
34e7b85d83e4: Loading layer [==================================================>] 199.9 MB/199.9 MB
62d2c961c519: Loading layer [==================================================>] 371.4 MB/371.4 MB
448615d3d8c4: Loading layer [==================================================>] 13.64 MB/13.64 MB
c2e682f3a3ab: Loading layer [==================================================>] 90.62 kB/90.62 kB
2a1ada17309b: Loading layer [==================================================>] 146.3 MB/146.3 MB
Loaded image: projecty-workflow:v2.0.0
proy@y-ubuntu:~/jkflow$ docker images

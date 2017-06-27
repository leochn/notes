---
title: docker小技巧
date: 2017-06-27 16:33:23
tags: docker
---
## 删除所有停止的容器
```
docker rm $(docker ps -a -q)
```

## 删除所有没命名的镜像
```
docker rmi $(docker images | grep "<none>" | awk "{print $3}")
```
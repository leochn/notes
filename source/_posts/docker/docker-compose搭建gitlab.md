---
title: docker-compose搭建gitlab
date: 2018-06-17 20:59:34
tags: [docker,gitlab]
---
## 通过docker-compose的方式搭建gitlab服务器
```
1.安装docker,启动docker,查看docker版本
2.运行 docker swarm init,将该机器配置成服务的管理者
3.准备 docker-compose.yml文件
4.拉取gitlab镜像 docker pull gitlab/gitlab-ce
```
<!-- more -->

## 搭建过程
### docker-compose.yml文件
```yml
version: '3'
services:
  gitlab:
    image: "gitlab/gitlab-ce:latest"
    networks:
      ingress:
        aliases:
          - gitlab
    volumes:
      - "/data/docker/gitlab/config:/etc/gitlab"
      - "/data/docker/gitlab/log:/var/log/gitlab"
      - "/data/docker/gitlab/data:/var/opt/gitlab"
    ports:
      - "8889:80"
      - "443:443"
      - "1022:22"
    deploy:
      restart_policy:
        condition: on-failure

networks:
  ingress:
    external:
      name: ingress
```

### 创建文件夹
```
[root@node-1 /]# mkdir -p /data/docker/gitlab/config
[root@node-1 /]# mkdir -p /data/docker/gitlab/log
[root@node-1 /]# mkdir -p /data/docker/gitlab/data
[root@node-1 /]# cd /data/docker/gitlab/
[root@node-1 gitlab]# pwd
/data/docker/gitlab
[root@node-1 gitlab]# ll
总用量 8
drwxrwxr-x  3 root    root  239 6月  17 21:09 config
drwxr-xr-x 19 root    root 4096 6月  17 21:09 data
-rw-r--r--  1 root    root  485 6月  17 21:16 docker-compose-gitlab.yml
drwxr-xr-x 20 polkitd root  334 6月  17 21:09 log
[root@node-1 gitlab]# firewall-cmd --zone=public --add-port=8889/tcp --permanent    ##  开启8889端口
[root@node-1 gitlab]# firewall-cmd --zone=public --add-port=1022/tcp --permanent
[root@node-1 gitlab]# firewall-cmd --reload  ## 使配置生效
```

### 运行启动命令
```
[root@node-1 gitlab]# systemctl start docker
[root@node-1 gitlab]# docker stack deploy -c docker-compose-gitlab.yml gitlab
This node is not a swarm manager. Use "docker swarm init" or "docker swarm join" to connect this node to swarm and try again.
[root@node-1 gitlab]# docker swarm init   ## 因为只有一台服务器,一个docker,所以这台docker
就是主节点,不添加其他从节点
Swarm initialized: current node (bbmwq37hyrs70hyl3mhvuwr95) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-335ra3v9fjekj9lrtm2qivp8pbp6ldfx7zbnjgmbhw8ugapuff-09fqvc9vgxtc7u86gwtc5q3fd \
    10.0.0.29:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[root@node-1 gitlab]# docker node ls   ## 查看docker的node节点,只有一个node节点
ID                            HOSTNAME                STATUS              AVAILABILITY        MANAGER STATUS
bbmwq37hyrs70hyl3mhvuwr95 *   node-1   Ready               Active              Leader
[root@node-1 gitlab]# docker stack deploy -c docker-compose-gitlab.yml gitlab   ## 运行命令
```

### 查看是否启动成功(启动过程需要一些时间)
```
[root@node-1 gitlab]# docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                     PORTS
z2tfwmj9jdya        gitlab_gitlab       replicated          1/1                 gitlab/gitlab-ce:latest   *:443->443/tcp,*:1022->22/tcp,*:8889->80/tcp
[root@node-1 gitlab]# docker service ps gitlab_gitlab
ID                  NAME                IMAGE                     NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
7gj9t6pa7dft        gitlab_gitlab.1     gitlab/gitlab-ce:latest   node-1              Running             Running 22 minutes ago                       
[root@node-1 gitlab]# docker ps
CONTAINER ID        IMAGE                     COMMAND             CREATED             STATUS                    PORTS                     NAMES
d5f3ee2e867e        gitlab/gitlab-ce:latest   "/assets/wrapper"   25 minutes ago      Up 25 minutes (healthy)   22/tcp, 80/tcp, 443/tcp   gitlab_gitlab.1.7gj9t6pa7dft5knp7yab4n58e
[root@node-1 gitlab]# netstat -an|grep 8889
tcp6       0      0 :::8889                 :::*                    LISTEN     
[root@node-1 gitlab]# netstat -an|grep 1022
tcp6       0      0 :::1022                 :::*                    LISTEN     
[root@node-1 gitlab]# netstat -an|grep 443
tcp6       0      0 :::443                  :::*                    LISTEN     
unix  3      [ ]         STREAM     CONNECTED     14439    
[root@node-1 gitlab]# docker service logs -tf gitlab_gitlab   ##  查看日志
```

### 查看效果
```
http://192.168.17.130:8889
```
第一次进入界面，需要重新设定root用户的密码.

![docker-compose搭建gitlab](/assets/images/docker/docker-compose搭建gitlab-001.png)

创建SmartWaterGroup组:

![docker-compose搭建gitlab](/assets/images/docker/docker-compose搭建gitlab-002.png)

创建Docs项目:

![docker-compose搭建gitlab](/assets/images/docker/docker-compose搭建gitlab-003.png)

Docs项目的仓库地址需要修改:

![docker-compose搭建gitlab](/assets/images/docker/docker-compose搭建gitlab-004.png)

### 修改配置文件
```
[root@node-1 gitlab]# pwd
/data/docker/gitlab
[root@node-1 gitlab]# cd config/
[root@node-1 config]# vim gitlab.rb     ##　external_url 'http://192.168.17.130:8889'
[root@node-1 gitlab]# docker service rm z2tfwmj9jdya
z2tfwmj9jdya
[root@node-1 gitlab]# docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
[root@node-1 gitlab]# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[root@node-1 gitlab]# docker stack deploy -c docker-compose-gitlab.yml gitlab
[root@node-1 gitlab]# docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                     PORTS
fw24s1qn3qam        gitlab_gitlab       replicated          0/1                 gitlab/gitlab-ce:latest   *:443->443/tcp,*:1022->22/tcp,*:8889->80/tcp
[root@node-1 gitlab]# docker service ps gitlab_gitlab
ID                  NAME                IMAGE                     NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
kkprbhopuqdd        gitlab_gitlab.1     gitlab/gitlab-ce:latest   node-1              Running             Running 5 seconds ago                       
[root@node-1 gitlab]# docker ps
CONTAINER ID        IMAGE                     COMMAND             CREATED             STATUS                   PORTS                     NAMES
2cab9fbe9a84        gitlab/gitlab-ce:latest   "/assets/wrapper"   8 minutes ago       Up 7 minutes (healthy)   22/tcp, 80/tcp, 443/tcp   gitlab_gitlab.1.kkprbhopuqddwrv9e1i258p43
[root@node-1 gitlab]#
```



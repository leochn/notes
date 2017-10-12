---
title: jenkins-git自动部署springboot的jar项目
date: 2017-10-11 15:25:16
tags: [jenkins,git]
---
通过jenkins来持续部署springboot项目,通过github中的WebHooks触发jenkins自动构建并部署项目,这里进行详细的介绍.
<!-- more -->
## 通过jenkins获取git项目
1.打开jenkins首页,点击新建项目
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目001.png)

2.配置后jenkins可自动从指定的git抓取master分支上最新的代码
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目002.png)

如果jenkins中的证书不正确会报错
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目003.png)

3.配置后jenkins可自动从指定的git抓取master分支上最新的代码
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目004.png)
可以看出,jenkinis拉取的源码放在 /var/lib/jenkins/workspace/testJenkinsDocker 目录下面.

## 手动构建jenkins并部署jar包
手动构建springboot项目,需要在构建模块中进行配置,并编写相应的脚本.
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目005.png)

在安装jenkins的服务器中编写如下脚本:
```bash
[root@localhost scripts]# pwd
/opt/scripts
[root@localhost scripts]# ll
total 8
-rw-r--r-- 1 root root 304 Oct 11 17:00 startup.sh
-rw-r--r-- 1 root root 181 Oct 11 17:00 stop.sh
[root@localhost scripts]# cat stop.sh 
#stop.sh
#!/bin/bash
echo "Stopping SpringBoot Application"
pid=`ps -ef | grep Devops-0.0.1-SNAPSHOT.jar | grep -v grep | awk '{print $2}'`
if [ -n "$pid" ]
then
   kill -9 $pid
fi
[root@localhost scripts]# cat startup.sh 
#startup.sh 启动项目
#!/bin/sh
echo "授予当前用户权限"
chmod 777 /var/lib/jenkins/workspace/testJenkinsDocker/target/Devops-0.0.1-SNAPSHOT.jar
echo "执行....."
cd /var/lib/jenkins/workspace/testJenkinsDocker/target/
nohup java -jar Devops-0.0.1-SNAPSHOT.jar > logs &
echo "启动成功..."
[root@localhost scripts]#
```

脚本完成后,就可以在jenkins中手动构建项目了
jenkins中的控制台输入如下:
```
Started by user admin
Building in workspace /var/lib/jenkins/workspace/testJenkinsDocker
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@gitee.com:leousst/Devops.git # timeout=10
Fetching upstream changes from git@gitee.com:leousst/Devops.git
 > git --version # timeout=10
using GIT_SSH to set credentials 
 > git fetch --tags --progress git@gitee.com:leousst/Devops.git +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 0a0bef665a8f89fa2ae79cc4ab36f11162455e23 (refs/remotes/origin/master)
Commit message: "add build"
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 0a0bef665a8f89fa2ae79cc4ab36f11162455e23
 > git rev-list 8e23642dc4d435532408bb98c05f8206fa13e06e # timeout=10
[testJenkinsDocker] $ /usr/local/maven/bin/mvn package
[INFO] Scanning for projects...
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] Building Devops 0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ Devops ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ Devops ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 2 source files to /var/lib/jenkins/workspace/testJenkinsDocker/target/classes
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ Devops ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /var/lib/jenkins/workspace/testJenkinsDocker/src/test/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ Devops ---
[INFO] No sources to compile
[INFO] 
[INFO] --- maven-surefire-plugin:2.18.1:test (default-test) @ Devops ---
[INFO] No tests to run.
[INFO] 
[INFO] --- maven-jar-plugin:2.6:jar (default-jar) @ Devops ---
[INFO] Building jar: /var/lib/jenkins/workspace/testJenkinsDocker/target/Devops-0.0.1-SNAPSHOT.jar
[INFO] 
[INFO] --- spring-boot-maven-plugin:1.5.4.RELEASE:repackage (default) @ Devops ---
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.032 s
[INFO] Finished at: 2017-10-11T17:02:36+08:00
[INFO] Final Memory: 29M/320M
[INFO] ------------------------------------------------------------------------
[SSH] script:

#!/bin/bash 
cd /opt/scripts
sh stop.sh
sh startup.sh

[SSH] executing...
Stopping SpringBoot Application
授予当前用户权限
执行.....
启动成功...

[SSH] completed
[SSH] exit-status: 0

Finished: SUCCESS
```

## 通过github中的WebHooks触发jenkins自动构建并部署项目

在jenkins构建触发器中选中"触发远程构建(例如,使用脚本)"
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目006.png)

在源码中的WebHooks中配置url为:
```
http://admin:b4b0b62f9eaa2b32ade4adadxxxxa@www.baidu.com:8080/job/testJenkinsDocker/build?token=123456
```

这个url的格式为4段式:
```
http://
admin:b4b0b62f9eaa2b32ade4adadxxxxa@     ## 为jenkins中admin用户的API Token
www.baidu.com:8080/   ## 为jenkins服务器的url地址,这里假设为baidu
job/testJenkinsDocker/build?token=123456  ## 123456为触发远程构建的身份验证令牌
```

其中第2段中的信息来源为:jenkins中admin用户的API Token:
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目007.png)

源码仓库中WebHooks中的设置为下图:
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目008.png)

修改源码,并进行push提交,jenkins会自动进行代码构建和部署.
![jenkins持续部署](/assets/images/devops/jenkins-git持续部署项目009.png)




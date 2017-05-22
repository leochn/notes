---
title: eclipse-svn提交代码
date: 2017-05-21 07:09:58
tags: [eclipse,svn]
---
关于eclipse-svn提交代码的一些配置操作
<!--more-->
## eclipse-svn提交代码
* 1.在eclipse的工作区间左侧，可以看到本地项目，以文件夹的形式展示
![eclipse-svn](/assets/images/tools/eclipse-svn001.png)

* 2.文件名前面带有黑色米字型图案的，就是本地代码同svn代码有区别的意思。
![eclipse-svn](/assets/images/tools/eclipse-svn002.png)

* 3.我们单击选中有区别的文件，右击选择team，并点击与资源库同步
![eclipse-svn](/assets/images/tools/eclipse-svn003.png)

* 4.点开每个文件夹，可以看到文件前面的图标，分为黑色和蓝色两种，其中蓝色就表示本地的代码同svn种的不同，svn中有更新版本的代码。
![eclipse-svn](/assets/images/tools/eclipse-svn004.png)

* 5.我们右击该文件，选择更新。把远程SVN服务器中的代码更新到本地。
![eclipse-svn](/assets/images/tools/eclipse-svn005.png)

* 6.更新完成后，弹窗自动消失，并且已经更新的文件就会自动消失。
![eclipse-svn](/assets/images/tools/eclipse-svn006.png)

* 7.忽略不要提交的代码
![eclipse-svn](/assets/images/tools/eclipse-svn007.png)

* 8.把本地代码提交到远程SVN服务器
![eclipse-svn](/assets/images/tools/eclipse-svn008.png)
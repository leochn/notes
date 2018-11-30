---
title: 使用hexo换了电脑后如何更新博客
date: 2018-11-30 21:31:41
tags: hexo
---

## 基于hexo-github搭建一个独立博客
```
http://www.cnblogs.com/MuYunyun/p/5927491.html
https://www.jianshu.com/p/8c0707ce5da4
https://blog.csdn.net/hosea1008/article/details/53384382
https://i.zhouhuix.cn/2016/11/24/%E4%BF%AE%E6%94%B9Hexo%E7%9A%84Next%E4%B8%BB%E9%A2%98/
http://www.jeyzhang.com/hexo-next-add-post-views.html
```

## 使用hexo换了电脑后如何更新博客

```
当重装电脑之后，或者想在其他电脑上修改博客，可以使用下列步骤：

1. 使用git clone https://github.com/xxx/xxx.git ,将仓库克隆到本地.

2. 在本地依次执行下列指令:

npm install hexo,
npm install,
npm install hexo-deployer-git

(记得，不需要hexo init这条指令)


3.然后就可以打包发布了
hexo clean && hexo g && hexo d
```
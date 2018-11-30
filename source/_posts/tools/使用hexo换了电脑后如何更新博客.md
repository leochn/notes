---
title: 使用hexo换了电脑后如何更新博客
date: 2018-11-30 21:31:41
tags: hexo
---

## 基于hexo-github搭建一个独立博客
```
http://www.cnblogs.com/MuYunyun/p/5927491.html
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


然后就可以打包发布了
hexo clean && hexo g && hexo d
```
---
title: spring-boot-devtools修改代码后免重启
date: 2017-06-16 08:54:44
tags: [java,springboot]
---
## maven工程使用spring-boot-devtools进行热部署,更改代码避免重启web容器
spring-boot-devtools 是一个为开发者服务的一个模块,其中最重要的功能就是代码修改后,自动重启应用.
<!-- more -->

其深层原理是使用了两个ClassLoader,一个Classloader加载那些不会改变的类(第三方Jar包),
另一个ClassLoader加载会更改的类,称为  restart ClassLoader,
这样在有代码更改的时候，原来的restart ClassLoader 被丢弃,重新创建一个restart ClassLoader,
由于需要加载的类相比较少,所以实现了较快的重启时间(5秒以内).

在pom.xml文件中原依赖:
```
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.5.4.RELEASE</version>
</parent>
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <java.version>1.8</java.version>
</properties>
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

添加依赖:
```
 <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-devtools</artifactId>
 </dependency>
```

or your Gradle build file:
```
dependencies {
    compile("org.springframework.boot:spring-boot-devtools")
}
```

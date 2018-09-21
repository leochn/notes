---
title: 如何在上产环境禁用swagger
date: 2017-12-21 10:02:35
tags: [java,swagger]
---
## swagger的集成
SpringMVC集成springfox-swagger2和springfox-swagger-ui很简单，只需要两步:
<!-- more -->
1.pom中添加依赖
```xml
<!-- swagger集成Spring依赖 -->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>${util.restful.swagger}</version>
    <scope>compile</scope>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>${util.restful.swagger}</version>
    <scope>compile</scope>
</dependency>
```
2.添加Swagger的配置类
```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    /**
     * 扫描所有带有@ApiOperation注解的方法
     */
    @Bean
    public Docket productApi(ApiInfo apiInfo) {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo)
                .select()
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                .paths(PathSelectors.any())
                .build();
    }
    @Bean
    public ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("Api文档")
                .version(DateTime.now().toString("yyyy-MM-dd HH:mm:ss"))
                .build();
    }
}
```
然后就可以通过http://localhost/swagger-ui.html看到项目中所有的接口信息了;
通过http://localhost/v2/api-docs就能看到json数据。

## 如何在生产环境禁用这些api文档呢
修改配置如下:
```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    /**
     * 扫描所有带有@ApiOperation注解的方法
     */
    @Bean
    public Docket productApi(ApiInfo apiInfo) {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo)
                .select()
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                .paths(PathSelectors.none()) //如果是线上环境，添加路径过滤，设置为全部都不符合
                .build();
    }
    @Bean
    public ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("Api文档")
                .version(DateTime.now().toString("yyyy-MM-dd HH:mm:ss"))
                .build();
    }
}
```
现在http://localhost/swagger-ui.html这个页面虽然还能访问，那是却看不到任何内容了;
包括http://localhost/v2/api-docs也是一样;
但是个人感觉,这样配置并不是很好.
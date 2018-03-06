---
title: springboot多数据源连接异常
date: 2018-02-26 16:45:14
tags: [springboot,mybatis]
---

## springboot多数据源配置及No operations allowed after connection closed连接异常

在一个项目中用到多个数据源，刚开始能正常工作，但是过了一个晚上就出现了异常，为什么？
<!-- more -->

## springboot单数据源的配置
springboot 的单数据源配置比较简单，只需要在 resources/application.yml中，进行jdbc的相关配置就可以，配置如下：
```
spring:
  profiles: pro
  datasource:
    url: jdbc:mysql://${dbServer:10.0.0.1}/dbtest?useSSL=false
    username: root
    password: root
    type: com.zaxxer.hikari.HikariDataSource
    driver-class-name: com.mysql.jdbc.Driver
```

## springboot多数据源的配置
这里连接2种不同的数据库(mysql,postgresql)

### mysql数据库的javabean配置：
```java
@Configuration
@MapperScan(basePackages = "com.example.mapper.mysql",sqlSessionFactoryRef="sqlSessionFactory")
public class MySqlConfig {
    @Bean(name = "dataSource")
    @ConfigurationProperties(prefix="spring.mySql")
    public DataSource dataSource() {
        return DataSourceBuilder.create().build();
    }
    @Bean(name = "sqlSessionFactory")
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sqlSessionFactoryBean.setMapperLocations(resolver.getResources("classpath:mysqlMapper/*.xml"));
        return sqlSessionFactoryBean.getObject();
    }
    
    @Bean(name= "transactionManager")
    public DataSourceTransactionManager transactionManager(@Qualifier("dataSource") DataSource dataSource)throws Exception {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean(name = "sqlSessionTemplate")
    public SqlSessionTemplate sqlSessionTemplate(@Qualifier("sqlSessionFactory") SqlSessionFactory sqlSessionFactory) throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
}
```

### postgresql数据库的javabean配置
```java
/**
 * 多数据源
 * 每个数据源都会生成自己的sqlSession,相互独立
 */
@Configuration
@MapperScan(basePackages = "com.example.mapper.postgresql",sqlSessionFactoryRef="postgresqlSqlSessionFactory")
public class PostgreSqlConfig {
    
    @Primary
    @Bean(name = "postgresqlDataSource")
    @ConfigurationProperties(prefix="spring.postgreSql")
    public DataSource postgresqlDataSource() {
        return DataSourceBuilder.create().build();
    }
    
    @Primary
    @Bean(name = "postgresqlSqlSessionFactory")
    public SqlSessionFactory postgresqlSqlSessionFactory(@Qualifier("postgresqlDataSource") DataSource postgresqlDataSource) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(postgresqlDataSource);
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sqlSessionFactoryBean.setMapperLocations(resolver.getResources("classpath:postgresqlMapper/*.xml"));
        return sqlSessionFactoryBean.getObject();
    }
    
    @Primary
    @Bean(name= "postgresqlTransactionManager")
    public DataSourceTransactionManager transactionManager(@Qualifier("postgresqlDataSource") DataSource dataSource)throws Exception {
        return new DataSourceTransactionManager(dataSource);
    }

    @Primary
    @Bean(name = "postgresqlSqlSessionTemplate")
    public SqlSessionTemplate sqlSessionTemplate(@Qualifier("postgresqlSqlSessionFactory") SqlSessionFactory sqlSessionFactory) throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory);
    }

}
```

### application.yml配置
```
---
spring:
  profiles: example-pro
  postgreSql:
    name: public
    url: jdbc:postgresql://10.0.0.18:5432/wdb
    username: root
    password: root
    type: com.zaxxer.hikari.HikariDataSource
    driver-class-name: org.postgresql.Driver
  mySql:
    url: jdbc:mysql://${dbServer:10.0.0.28}/wds?useSSL=false
    username: root
    password: root
    type: com.zaxxer.hikari.HikariDataSource
    driver-class-name: com.mysql.jdbc.Driver
```

### 运行情况
配置好之后，能正常运行，但是超过一定时间后，会报错。

```
Caused by: com.mysql.jdbc.exceptions.jdbc4.MySQLNonTransientConnectionException: No operations allowed after connection closed.
    at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method) ~[na:1.8.0_151]
    at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62) ~[na:1.8.0_151]
    at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45) ~[na:1.8.0_151]
    at java.lang.reflect.Constructor.newInstance(Constructor.java:423) ~[na:1.8.0_151]
    at com.mysql.jdbc.Util.handleNewInstance(Util.java:425) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.Util.getInstance(Util.java:408) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.SQLError.createSQLException(SQLError.java:918) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.SQLError.createSQLException(SQLError.java:897) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.SQLError.createSQLException(SQLError.java:886) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.SQLError.createSQLException(SQLError.java:860) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.ConnectionImpl.throwConnectionClosedException(ConnectionImpl.java:1187) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.ConnectionImpl.checkClosed(ConnectionImpl.java:1182) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.ConnectionImpl.getMetaData(ConnectionImpl.java:2889) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.ConnectionImpl.getMetaData(ConnectionImpl.java:2884) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:1.8.0_151]
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[na:1.8.0_151]
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:1.8.0_151]
    at java.lang.reflect.Method.invoke(Method.java:498) ~[na:1.8.0_151]
    at org.apache.tomcat.jdbc.pool.ProxyConnection.invoke(ProxyConnection.java:126) ~[tomcat-jdbc-8.5.23.jar!/:na]
    at org.apache.tomcat.jdbc.pool.JdbcInterceptor.invoke(JdbcInterceptor.java:108) ~[tomcat-jdbc-8.5.23.jar!/:na]
    at org.apache.tomcat.jdbc.pool.interceptor.AbstractCreateStatementInterceptor.invoke(AbstractCreateStatementInterceptor.java:79) ~[tomcat-jdbc-8.5.23.jar!/:na]
    at org.apache.tomcat.jdbc.pool.JdbcInterceptor.invoke(JdbcInterceptor.java:108) ~[tomcat-jdbc-8.5.23.jar!/:na]
    at org.apache.tomcat.jdbc.pool.DisposableConnectionFacade.invoke(DisposableConnectionFacade.java:81) ~[tomcat-jdbc-8.5.23.jar!/:na]
    at com.sun.proxy.$Proxy139.getMetaData(Unknown Source) ~[na:na]
    at org.springframework.jdbc.support.JdbcUtils.extractDatabaseMetaData(JdbcUtils.java:331) ~[spring-jdbc-4.3.13.RELEASE.jar!/:4.3.13.RELEASE]
    ... 120 common frames omitted
Caused by: com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: The last packet successfully received from the server was 52,600,023 milliseconds ago.  The last packet sent successfully to the server was 52,600,023 milliseconds ago. is longer than the server configured value of 'wait_timeout'. You should consider either expiring and/or testing connection validity before use in your application, increasing the server configured values for client timeouts, or using the Connector/J connection property 'autoReconnect=true' to avoid this problem.
    at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method) ~[na:1.8.0_151]
    at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62) ~[na:1.8.0_151]
    at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45) ~[na:1.8.0_151]
    at java.lang.reflect.Constructor.newInstance(Constructor.java:423) ~[na:1.8.0_151]
    at com.mysql.jdbc.Util.handleNewInstance(Util.java:425) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.SQLError.createCommunicationsException(SQLError.java:989) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.MysqlIO.send(MysqlIO.java:3746) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.MysqlIO.sendCommand(MysqlIO.java:2509) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.MysqlIO.sqlQueryDirect(MysqlIO.java:2680) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.ConnectionImpl.execSQL(ConnectionImpl.java:2487) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.PreparedStatement.executeInternal(PreparedStatement.java:1858) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at com.mysql.jdbc.PreparedStatement.execute(PreparedStatement.java:1197) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:1.8.0_151]
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[na:1.8.0_151]
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:1.8.0_151]
    at java.lang.reflect.Method.invoke(Method.java:498) ~[na:1.8.0_151]
    at org.apache.tomcat.jdbc.pool.StatementFacade$StatementProxy.invoke(StatementFacade.java:114) ~[tomcat-jdbc-8.5.23.jar!/:na]
    at com.sun.proxy.$Proxy141.execute(Unknown Source) ~[na:na]
    at org.apache.ibatis.executor.statement.PreparedStatementHandler.query(PreparedStatementHandler.java:63) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.executor.statement.RoutingStatementHandler.query(RoutingStatementHandler.java:79) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.executor.SimpleExecutor.doQuery(SimpleExecutor.java:63) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.executor.BaseExecutor.queryFromDatabase(BaseExecutor.java:324) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.executor.BaseExecutor.query(BaseExecutor.java:156) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:109) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:83) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:148) ~[mybatis-3.4.5.jar!/:3.4.5]
    at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:141) ~[mybatis-3.4.5.jar!/:3.4.5]
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:1.8.0_151]
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[na:1.8.0_151]
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:1.8.0_151]
    at java.lang.reflect.Method.invoke(Method.java:498) ~[na:1.8.0_151]
    at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:433) [mybatis-spring-1.3.1.jar!/:1.3.1]
    ... 113 common frames omitted
Caused by: java.net.SocketException: Broken pipe (Write failed)
    at java.net.SocketOutputStream.socketWrite0(Native Method) ~[na:1.8.0_151]
    at java.net.SocketOutputStream.socketWrite(SocketOutputStream.java:111) ~[na:1.8.0_151]
    at java.net.SocketOutputStream.write(SocketOutputStream.java:155) ~[na:1.8.0_151]
    at java.io.BufferedOutputStream.flushBuffer(BufferedOutputStream.java:82) ~[na:1.8.0_151]
    at java.io.BufferedOutputStream.flush(BufferedOutputStream.java:140) ~[na:1.8.0_151]
    at com.mysql.jdbc.MysqlIO.send(MysqlIO.java:3728) ~[mysql-connector-java-5.1.44.jar!/:5.1.44]
    ... 138 common frames omitted
```

No operations allowed after connection closed错误原因及解决
之所以会出现这个异常，是因为MySQL5.0以后针对超长时间DB连接做了一个处理，那就是如果一个DB连接在无任何操作情况下过了8个小时后(Mysql 服务器默认的“wait_timeout”是8小时)，Mysql会自动把这个连接关闭。这就是问题的所在，在连接池中的connections如果空闲超过8小时，mysql将其断开，而连接池自己并不知道该connection已经失效，如果这时有 Client请求connection，连接池将该失效的Connection提供给Client，将会造成上面的异常。

## 修改application.yml的配置
```
---
spring:
  profiles: example-pro
  postgreSql:
    name: public
    url: jdbc:postgresql://10.0.0.18:5432/wdb?autoReconnect=true
    username: root
    password: root
    type: com.zaxxer.hikari.HikariDataSource
    driver-class-name: org.postgresql.Driver
    validationQuery: SELECT 1
    testOnBorrow: true
  mySql:
    url: jdbc:mysql://${dbServer:10.0.0.28}/wds?useSSL=false&autoReconnect=true
    username: root
    password: root
    type: com.zaxxer.hikari.HikariDataSource
    driver-class-name: com.mysql.jdbc.Driver
    validationQuery: SELECT 1
    testOnBorrow: true
```

这样上述异常就得到解决，其实出现该问题的原因，还是自己本人当时忽略了连接池的相关配置，以及对一些常见连接池的配置尚有欠缺，这里再补充一个小知识点，spring boot默认会优先使用的连接池是tomcat连接池，前提是在tomcat连接池可用的情况下
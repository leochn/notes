---
title: java读取excel
date: 2017-07-11 17:06:22
tags: [java,excel]
---
## java读取excel
下面是java读取excel的一个小实例.
<!-- more -->
pom.xml文件

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>maven</groupId>
  <artifactId>excel</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>jar</packaging>

  <name>excel</name>
  <url>http://maven.apache.org</url>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>

  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.apache.poi</groupId>
        <artifactId>poi</artifactId>
        <version>3.16</version>
    </dependency>
    <dependency>
        <groupId>org.apache.poi</groupId>
        <artifactId>poi-ooxml</artifactId>
        <version>3.16</version>
    </dependency>
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-lang3</artifactId>
        <version>3.3.2</version>
    </dependency>
  </dependencies>
</project>

```

demo
```java
package com.dk.excel;

import java.io.FileInputStream;
import java.io.InputStream;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ReadExcel {
    @SuppressWarnings("resource")
    public static void main(String[] args) {
        try {
            InputStream is = new FileInputStream("D:/WPG20170707.xlsx");
            XSSFWorkbook xssfWorkbook = new XSSFWorkbook(is);
            XSSFSheet xssfSheet = xssfWorkbook.getSheetAt(0);
            int lastRowNum = xssfSheet.getLastRowNum();
            //System.out.println("最大行数=" + lastRowNum);
            // 0--83 列
            int maxCell = 0;
            maxCell = xssfSheet.getRow(2).getLastCellNum(); //excel的列数
            int column = 0;
            int col = 6;             // 每组点表类型数据的列数.
            column = maxCell / col;  // 计算出总共多少种点表类型
            Integer ids = 1;
            for (int k = 0; k < column; k++) {
                for(int i=2;i<=lastRowNum;i++){
                    XSSFRow xssfRow = xssfSheet.getRow(i);
                    if (!StringUtils.isNotEmpty(xssfRow.getCell(k * col).toString())) {
                        break;
                    }
                    // 0--5 
                    StringBuilder sb = new StringBuilder();
                    for (int j = k * col; j < (k * col + col - 1); j++) {
                        //XSSFCell cell = xssfRow.getCell(j);
                        String cell = xssfRow.getCell(j).toString();
                        if (!StringUtils.isNotEmpty(cell)) {
                            sb.append("'',");
                        }else {
                            //sb = sb.append("'" + cell.toString() + "',");
                            sb = sb.append("'" + cell + "',");
                        }
                    }
                    if (!StringUtils.isNotEmpty(xssfRow.getCell(k * col + col - 1).toString())) {
                        sb = sb.append("NULL");
                    }else {
                        sb = sb.append(xssfRow.getCell(k * col + col - 1).toString());
                    }
                    String temp = null;
                    String vid = ids.toString();
                    String fid = null;
                    // 如果不够三位数，则补充为三位数
                    if (vid.length() == 1) {
                        fid = "00" + vid;
                    }else if (vid.length() == 2) {
                        fid = "0" + vid;
                    }else {
                        fid = vid;
                    }
                    temp = "insert into `function` (ID,CODE,name,MEMO,DATA_TYPE,UNIT,RATIO) values ('" + fid + "'," + sb.toString()+");        # RowNum = " + (i-1);
                    ids ++;
                    //list.add(temp);
                    System.out.println(temp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
}

```
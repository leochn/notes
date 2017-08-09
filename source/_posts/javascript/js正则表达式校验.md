---
title: js正则表达式校验
date: 2017-08-03 11:31:23
tags: javascript
---
 ## 限定1-2位整数同时至多含有3位小数
 ```js
    var reg1=/(^[0-9]{1,2}$)|(^[0-9]{1,2}[\.]{1}[0-9]{1,3}$)/;  
    console.log(reg1.test("99.999")); 
    console.log(reg1.test("100")); 
    console.log(reg1.test("1.0001")); 
    console.log(reg1.test("a") + " a false");  
    console.log(reg1.test("*") + " * false");  
    console.log(reg1.test("..") + " .. false");
    console.log(reg1.test("") + " 空串 false");
 ```

## IP校验
```js
    function isIP(strIP) {
        //模糊匹配IP地址的正则表达式     
        var re = /^(\d{1,3}|\*)\.(\d{1,3}|\*)\.(\d{1,3}|\*)\.(\d{1,3}|\*)$/g;
        if (re.test(strIP)) {
            if (RegExp.$1 == '*' && RegExp.$2 == '*' && RegExp.$3 == '*' && RegExp.$4 == '*') {
                return true;
            }
            if (RegExp.$1 < 256 && RegExp.$2 == '*' && RegExp.$3 == '*' && RegExp.$4 == '*') {
                return true;
            }
            if (RegExp.$1 < 256 && RegExp.$2 < 256 && RegExp.$3 == '*' && RegExp.$4 == '*') {
                return true;
            }
            if (RegExp.$1 < 256 && RegExp.$2 < 256 && RegExp.$3 < 256 && RegExp.$4 == '*') {
                return true;
            }
            if (RegExp.$1 < 256 && RegExp.$2 < 256 && RegExp.$3 < 256 && RegExp.$4 < 256) {
                return true;
            }
        }
        return false;
    }
    console.log(isIP("192.168.1.118"));
    console.log(isIP("256.168.1.118"));
    console.log(isIP("192.168.1.256"));
    console.log(isIP("192.256.1.118"));
    console.log(isIP("192.1.1.118"));
    console.log(isIP("1.1.1.0"));
    console.log(isIP("192.-1.1.118"));
```

## 手机号码验证
```js
    var regPhone = /^1(3|4|5|7|8)\d{9}$/;
    console.log(regPhone.test("15888888888"));
```

简单的解释一下：
^1(3|4|5|7|8)\d{9}$
表示以1开头，第二位可能是3/4/5/7/8等的任意一个，在加上后面的\d表示数字[0-9]的9位，总共加起来11位结束。

现在的手机号码段有联通、移动和电信。

电信:
中国电信手机号码开头数字
2G/3G号段（CDMA2000网络）133、153、180、181、189
4G号段 177

联通:
中国联通手机号码开头数字
2G号段（GSM网络）130、131、132、155、156
3G上网卡145
3G号段（WCDMA网络）185、186
4G号段 176、185[1]

移动:
中国移动手机号码开头数字
2G号段（GSM网络）有134x（0-8）、135、136、137、138、139、150、151、152、158、159、182、183、184。
3G号段（TD-SCDMA网络）有157、187、188
3G上网卡 147
4G号段 178

从以上我们可以看到第一位是【1】开头，第二位则则有【3,4,5,7,8】，第三位则是【0-9】，第三位之后则是数字【0-9】。从而我们可以得出一个符合当前的手机号码验证正则表达式。

## 用户名正则
4到16位（字母，数字，下划线，减号）
```js
var uPattern = /^[a-zA-Z0-9_-]{4,16}$/;
console.log(uPattern.test("1qqqw"));
```

## 密码强度正则
//密码强度正则，最少6位，包括至少1个大写字母，1个小写字母，1个数字，1个特殊字符
```js
var pPattern = /^.*(?=.{6,})(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*? ]).*$/;
console.log(pPattern.test("Qianbao123#")); //输出 true
```

## 整数正则
```js
//正整数正则
var posPattern = /^\d+$/;
//负整数正则
var negPattern = /^-\d+$/;
//整数正则
var intPattern = /^-?\d+$/;
//输出 true
console.log(posPattern.test("42"));
//输出 true
console.log(negPattern.test("-42"));
//输出 true
console.log(intPattern.test("-42"));
```

## 数字正则
可以是整数也可以是浮点数
```js
//正数正则
var posPattern = /^\d*\.?\d+$/;
//负数正则
var negPattern = /^-\d*\.?\d+$/;
//数字正则
var numPattern = /^-?\d*\.?\d+$/;
console.log(posPattern.test("42.2"));
console.log(negPattern.test("-42.2"));
console.log(numPattern.test("-42.2"));
```

## IPV4地址正则
```js
//ipv4地址正则
var ipP = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
//输出 true
console.log(ipP.test("192.28.47.26"));
```

## 包含中文正则
```js
var cnPattern = /[\u4E00-\u9FA5]/;
//输出 true
console.log(cnPattern.test("123ADADss你"));
```

## 车牌号正则
```js
var cPattern = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/;
//输出 true
console.log(cPattern.test("粤B39006"));
```
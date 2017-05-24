---
title: input-file清空value值
date: 2017-05-24 11:24:44
tags: javascript
---
## 清空input-file标签中的value值

场景:当用file标签选择文件时,当选择的文件不在规定的类型之内,就需要清空file标签内的value值,在IE11浏览器中,不能通过target.value = ""来清空,需要额外进行处理.
<!-- more -->

下面直接看代码吧:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
<div>
    <input id="xml" type="file" onchange="fileChange(this);"/> 
    <br>
    <input type="button" value="批量数据" onclick="insert();">
</div>
<script>
var isIE = /msie/i.test(navigator.userAgent) && !window.opera;
function fileChange(target, id) {
    var fileSize = 0;
    var filetypes = [".xml"];
    var filepath = target.value;
    var filemaxsize = 1024 * 2; //2M   
    if (filepath) {
        var isnext = false;
        var fileend = filepath.substring(filepath.indexOf("."));
        if (filetypes && filetypes.length > 0) {
            for (var i = 0; i < filetypes.length; i++) {
                if (filetypes[i] == fileend) {
                    isnext = true;
                    break;
                }
            }
        }
        if (!isnext) {
            target.value = "";
            alert("不接受此文件类型！");
            if (isIE) {
                var objFile = document.getElementById("xml"); 
                objFile.outerHTML = objFile.outerHTML.replace(/(value=\").+\"/i, "$1\"");
            }
            return false;
        }
    } else {
        return false;
    }
}

var insert=function(){ 
    var imageEle=document.getElementById("xml"); 
    if (window.FileReader) {   
        var imageFileList=imageEle.files; 
        if (imageFileList.length > 0) {
            var file=imageFileList[0];  
            filename = file.name.split(".")[0];  
            var reader = new FileReader(); 
            reader.readAsText(file);
            reader.onload = function() { 
                //console.log(this); 
                var xmlResult = this.result;
                alert("已经选择了文件!!!!!!");

            }  
        }else {
            alert("请选择文件...");
        }
    }  
} 
</script>
</body>
</html>
```
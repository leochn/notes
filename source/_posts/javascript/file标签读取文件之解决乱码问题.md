---
title: file标签读取文件之解决乱码问题
date: 2017-05-24 15:33:26
tags: javascript
---
## file标签读取文件之解决乱码问题
用FileReader API的readAsText读取上传的文件内容,但是选择的文件有可能是UTF-8编码,也有可能是GB2312,如何解决乱码的问题呢,请看下文:
<!-- more -->

通过FileReader()中的readAsDataURL读取文件,并引用jschardet进行编码检查,链接: [jschardet](https://cdnjs.cloudflare.com/ajax/libs/jschardet/1.4.1/jschardet.min.js) ,也可以通过 npm install jschardet 进行安装.

详情看代码:
```html
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="jquery.js"></script>
    <script src="jschardet.js"></script> 
</head>
<body>
    <input id = "file" type="file" name="contractFileName"  onchange="fileChange(this);" />
    <br>
    <br>
    <input type="button" value="显示文件信息" onclick="showFileInformation();">
    <script type="text/javascript">
        var isIE = /msie/i.test(navigator.userAgent) && !window.opera;
        function fileChange(target, id) {
            var filetypes = [".xml"];
            var filepath = target.value;
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
                        var objFile = document.getElementById("file"); 
                        objFile.outerHTML = objFile.outerHTML.replace(/(value=\").+\"/i, "$1\"");
                    }
                    return false;
                }
                var imageEle=document.getElementById("file"); 
                if (window.FileReader) {   
                    var imageFileList=imageEle.files; 
                    if (imageFileList.length > 0) {
                        var file=imageFileList[0];   
                        var reader = new FileReader(); 
                        reader.readAsDataURL(file);
                        reader.onload = function(evt) {
                            var xmlResult = evt.target.result;
                            encoding = checkEncoding( xmlResult );
                        }
                    }
                }
            } else {
                return false;
            }
        }

    var showFileInformation=function(){ 
        var imageEle=document.getElementById("file"); 
        if (window.FileReader) {  
            var imageFileList=imageEle.files; 
            var file=imageFileList[0];  
            var reader = new FileReader();
            reader.readAsText(file,encoding); 
            reader.onload = function(evt) { 
                var xmlResult = evt.target.result;
                alert(encoding);
                alert(xmlResult);
            }  
        }        
    } 

    //检查编码，引用了 jschardet
    function checkEncoding( base64Str ){
        //这种方式得到的是一种二进制串
        var str = atob( base64Str.split(";base64,")[1] );
        //要用二进制格式
        var encoding = jschardet.detect( str );
        encoding = encoding.encoding;
        if( encoding == "windows-1252"){    //有时会识别错误（如UTF8的中文二字）
            encoding = "ANSI";
        }
        return encoding;
    }
    </script>
</body>
</html>

```


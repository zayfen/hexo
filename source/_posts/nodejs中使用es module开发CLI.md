------
title: Nodejs使用es module开发CLI
author: zayfen
date: 2021/02/01
tags:
- nodejs
categories:
- nodejs
archives:
- nodejs
------


这里主要介绍的不是CLI的开发,而是node使用es module开发cli的工程配置和注意事项

<!-- more -->

## 一、 package.json的配置

* **bin**
  bin字段是指定cli的执行文件的. 比如我将bin指定为`{“sm-cli": "index.js"}`, 那么当用户安装了此工具之后，系统会安装sm-cli这个可执行文件并且加入到系统环境变量中，可以在终端执行
  `sm-cli`命令，当执行这个命令的时候，其实就是运行的index.js文件。

  bin字段可以跟上一个执行文件路径字符串，也可以跟上一个json对象，json对象中指定<命令名：执行文件名>。

  ```js
  // 安装之后，执行命令就是package.json中的name字段的值
  {
      "bin": "./index.js"
  }
  // 安装之后，执行命令是"sm-cli"
  {
      "bin": {
          "sm-cli": "./index.js"
      }
  }
  ```

  


* **type**
  node默认的是cjs模块管理系统，我们可以通过设置type字段来开启使用es的模块管理系统。将type字段设置成"module"
  e.g.

```javascript
{
  "type": "module"
}
```

* **preferGlobal**

  preferGloabl字段表示改工具模块更加倾向于全局安装，对与CLI工具来说，这个是需要设置成true的。

  e.g.

  ```javascript
  {
      "perferGlobal": true
  }
  ```

  

## 二、 入口文件的配置

可执行文件的设置需要注意，因为我们选定了使用es module，但是在`npm install  -g `安装之后，node会使用commonjs的方式去执行文件，此时文件中的

**import xxx from "xxxx"**就会无法执行；解决方案是我们需要指定node的 **--experimental-modules**参数，--experimental-modules表示node的实验中的es 模块功能，指定了这个参数之后，node就可以执行es module文件代码了。



如何指定--experimental-modules呢？

需要在`bin`指定的文件中增加shebang(aka Hashbang)。shebang是一个由井号和感叹号构成的字符串序列，出现再文本的第一行，写过脚本语言的（比如python）一定对此不陌生。

开启--experimental-modules的shebang:

```bash
#!/usr/bin/env node --experimental-modules
```

![代码示范](https://kodbox.zayfen.com/index.php?explorer/share/fileOut&shareID=6MsdbC0Q&path=%7BshareItemLink%3A6MsdbC0Q%7D%2F)


## 三、 编写你的代码

以上的配置完成之后，可以使用es module开发node程序，并且`npm install -g`之后也能正确的执行，剩下的就是你愉快的开发之旅了！



\#\#Happy Coding\#\#
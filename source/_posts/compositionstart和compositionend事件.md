------

title: componentstart和componentend事件
author: zayfen
date: 2021/02/01
tags:
- web
- event
- componentstart
- componentend
categories:
- web
archives:
- web

------



# 优雅输入中文，浏览器中的`compositionstart`和`compositionend`事件讲解

当文本合成系统，如IME（input method editor）开始键盘输入时，触发`compositionstart`事件。
当文本合成系统输入完成或者取消当前的composition会话时触发`compositionend`事件。

输入中文和输入英文不一样的是，中文需要多次敲击前盘才能组成一个字，想要有比较舒适的中文输入环境，需要实现输入一个中文字后再响应事件，而不是每次敲击一次键盘就响应一次事件，所以就需要`compositionstart` 和 `compositionend`事件。

IME在如下场景中使用：
* 使用拉丁键盘输入中文，日文或者韩文
* 在数字小键盘输入拉丁文本
* 使用手写识别在触摸屏输入文本

<!-- more -->

## 事件应用的场景
1. 当在input中输入中文进行列表过滤时，可以避免在敲击键盘的过程中执行过滤操作, `compositionend`在输入完成后触发，可以在此事件中拿到完整的中文输入执行过滤操作
2. 在input中输入中文搜索时，如上，可以避免敲键盘时，就执行搜索动作

> 总之在输入中文的环境中，需要拿到完整的输入中文的地方，就可以使用这两个事件。

## Demo
```html
<input id="input" type="text"/>
<textarea id="log"  readonly style="width:200px; height:300px"> </textarea>

<script>
  
  var inputEle = document.getElementById('input')
  var logEle = document.getElementById('log')
  
  var compositionLock = false
  
  // 从英文切换到中文输入时触发
  inputEle.addEventListener('compositionstart', (event) => {
    console.log('compositionstart: ', `type: ${event.type}  data: ${event.data}`)
    logEle.textContent = logEle.textContent +  `type: ${event.type}  data: ${event.data}\n`
    
    compositionLock = true
  })
  
  // 比如windows10的中文输入法，输入完中文按`SPACE`或者`Enter`触发
  inputEle.addEventListener('compositionend', (event) => {
    console.log('compositionstart: ', `type: ${event.type}  data: ${event.data}`)
    logEle.textContent = logEle.textContent +  `type: ${event.type}  data: ${event.data}\n`
    
    compositionLock = false
    
    // 因为input事件在此事件之前触发了，所以需要手动触发input事件
    var evt = new Event('input')
    evt.data = event.data
    inputEle.dispatchEvent(evt)
  })
  
  // 按任何键，都会触发，即使在中文的输入情况下
  inputEle.addEventListener('input', (event) => {
    // 如果不用compositinLock标志位，那么输入中文环境下输入abcdefg，
    // 看到的event.data会是这个样子：abc'de'f'g
    if (compositionLock) {
      return
    }
    // 在输入中文的时候，当按下`SPACE`键的时候，这里event.data会拿到中文输入法中完整的中文内容
    logEle.textContent = logEle.textContent +  `type: ${event.type}  data: ${event.data}\n`
  })
</script>
```
![compositionstart.gif](https://kodbox.zayfen.com/index.php?explorer/share/file&hash=7ec6ttRDVWGMEEA0pE7Q3HpMKU9LU6QCwG1CHwdBcccAgTBWV8gYPm4x&name=compositionstart.gif)


## 事件的兼容性

**Support Status** 的表示：
* `yes`表示完全支持
* `Number`表示浏览器支持这个事件的最低版本号
* `?` 表示支持情况未知

**PC端兼容性**



| Browser | Support Status |
| ------- | -------------- |
| Chrome  | Yes            |
| Edge    | 12             |
| Firfox  | 9              |
| IE      | Yes            |
| Opera   | Yes            |
| Safari  | Yes            |



**移动端兼容性**



| Browser             | Support Status |
| ------------------- | -------------- |
| Android Webview     | Yes            |
| Chrome for Android  | Yes            |
| Firefox for Android | Yes            |
| Opera for Android   | ?              |
| Safari on iOS       | ?              |
| Samsung Internet    | Yes            |
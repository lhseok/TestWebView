# TestWebView
Speed ​​difference issue between new window and current window when using WKWebView
---
In the case of UIWebView, the first time right after the app is launched is a little slow, and after that, the speed is constant whether opening a new window or reusing an already created webview.

On the other hand, in the case of WKWebView, it is fast when a load request is made in the same webview, but when a load request is made after creating a new webview, the speed is slow.

This issue exists in both swift and objective-c.

![11](https://user-images.githubusercontent.com/52279373/128986958-bf175966-6c36-4d06-b680-c288484611f8.gif)
![22](https://user-images.githubusercontent.com/52279373/128986977-1fec294b-e842-4d66-9b83-9e2fc39fa1ac.gif)

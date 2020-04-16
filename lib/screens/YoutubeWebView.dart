// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';


// class YoutubeWebView extends StatefulWidget{
//   String videoId;
//   YoutubeWebView(this.videoId);
//   @override
//   State<StatefulWidget> createState() {
//     return _YoutubeWebView(videoId);
//   }

// }


// class _YoutubeWebView extends State<YoutubeWebView>{
//   String videoId;
//   _YoutubeWebView(this.videoId);
//   String fullUrl;
//   @override
//   void initState() {
//     super.initState();
//     String youtubeUrl = "https://www.youtube.com/watch?v=$videoId";
//     fullUrl = youtubeUrl;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(body: WebView(initialUrl: fullUrl, javascriptMode: JavascriptMode.unrestricted,),);
//   }

// }
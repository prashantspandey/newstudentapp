// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class NativeVideoWebView extends StatefulWidget {
//   String url;
//   NativeVideoWebView(this.url);
//   @override
//   State<StatefulWidget> createState() {
//     return _NativeVideoWebView(url);
//   }
// }

// class _NativeVideoWebView extends State<NativeVideoWebView> {
//   String url;
//   var _stackToView = 1;
//   _NativeVideoWebView(this.url);

//   void _handleLoad(String value) {
//     setState(() {
//       _stackToView = 0;
//     });
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _stackToView,
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               Expanded(
//                 child: WebView(
//                   initialUrl: url.replaceAll("\"", ""),
//                   javascriptMode: JavascriptMode.unrestricted,
//                   debuggingEnabled: true,
//                   onPageFinished: _handleLoad,
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             color: Colors.black,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CircularProgressIndicator(
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     'Loading...',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

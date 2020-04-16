import 'package:flutter/material.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:url_launcher/url_launcher.dart';


class NewWebView extends StatefulWidget{
  StudentUser user = StudentUser();
  String url;
  NewWebView(this.url);
  @override
  State<StatefulWidget> createState() {
    return _NewWebView(user,url);
  }

}

class _NewWebView extends State<NewWebView>{
  StudentUser user = StudentUser();
  String url;
  _NewWebView(this.user,this.url);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(   );

}
}
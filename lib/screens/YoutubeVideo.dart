import 'package:student_app/pojos/basic.dart';
import 'package:student_app/screens/VideoList.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//import 'package:youtube_player/youtube_player.dart';

class YoutubeVideo extends StatefulWidget {
  StudentUser user = StudentUser();
  String videoId;
  YoutubeVideo(this.user, this.videoId);
  @override
  State<StatefulWidget> createState() {
    return _YoutubeVideo(user);
  }
}

class _YoutubeVideo extends State<YoutubeVideo> {
  StudentUser user = StudentUser();
  static String videoId;
  bool isHd = false;
  //static String vidId = 'Wo5dMEP_BbI';
  YoutubePlayerController _controller;
  _YoutubeVideo(this.user);
  @override
  void initState() {
    super.initState();
   videoId = widget.videoId;
    print('video Id ${widget.videoId.toString()}');
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        isLive: false,
        autoPlay: true,
        forceHD: isHd
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.orangeAccent, 
              actionsPadding: EdgeInsets.all(10),
               
              onReady: (){
                print('ready');
              },             ),
          ],
        ),
        
      ),
    );
  }
}

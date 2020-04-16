import 'dart:async';

import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/SingleVideoPlayer.dart';
import 'package:student_app/screens/VideoList.dart';
import 'package:student_app/screens/YoutubeVideo.dart';
import 'package:student_app/screens/YoutubeWebView.dart';
import 'package:flutter/material.dart';

class LiveVideoList extends StatefulWidget {
  StudentUser user = StudentUser();
  LiveVideoList(this.user);
  @override
  State<StatefulWidget> createState() {
    return _LiveVideoList(user);
  }
}

class _LiveVideoList extends State<LiveVideoList> {
  StudentUser user = StudentUser();
  _LiveVideoList(this.user);
  Timer timer;
  static String key = 'AIzaSyDOW6Nt-1jpzxcEbypSpJ-ObCsZHjYBjPA';
  //String channelId = 'UCajIi_Q-JgR3kEgIvlamxcA';
  String channelId = 'UCAi9r2zk3z2KO3uXTsxj8lQ';
  // YoutubeAPI youtubeAPI = YoutubeAPI(key);
  findLiveVideos() async {
    var response = await getLiveVideoLink(user.key);
    return response;
  }

  findVideoAgain() async {
    print('findind video again');
    //timer = Timer.periodic(Duration(seconds: 5), (Timer t) => findLiveVideos());
    return('heelo');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Videos'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: findLiveVideos(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data != null) {
                    var videos = snapshot.data['videos'];
                    if (videos.length != 0) {
                      return ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(Icons.live_tv),
                              title: Text('Live Video '+videos[index]['time']),
                              subtitle: Divider(
                                color: Colors.orange,
                              ),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => YoutubeWebView(
                                //             videos[index]['link'].toString().split('/').last.toString())));
                              },
                            ),
                          );
                        },
                      );
                    }
                    else{
                    findVideoAgain();
                      return Center(child: Text('No live video found.'));
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

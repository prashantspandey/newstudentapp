import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/call.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NativeLiveVideo extends StatefulWidget {
  StudentUser user = StudentUser();
  String agoraId = '485c033c5aba4ae98605f98dc821625a';
  NativeLiveVideo(this.user);
  @override
  State<StatefulWidget> createState() {
    return _NativeLiveVideo();
  }
}

class _NativeLiveVideo extends State<NativeLiveVideo> {
  startLoading(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  studentJoinLiveVideo(videoId, joinTime) async {
    var response = await joinLiveVideo(widget.user.key,videoId, joinTime);
    return response;
  }

  getLiveVideo() async {
    var response = await getAgoraLiveVideo(widget.user.key);
    return response;
  }

  Future<void> onJoin(channelName, videoId) async {
    //startLoading(context);
    // update input validation
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    var now = DateTime.now();
    // push video page with given channel name
    //Navigator.pop(context);
    studentJoinLiveVideo(videoId, now);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          widget.agoraId,
          widget.user,
          videoId,
          channelName: channelName,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Videos'),
      ),
      body: FutureBuilder(
        future: getLiveVideo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            var videos = snapshot.data['videos'];
            if (videos.length == 0) {
              return Center(child: Text('No live video currently'));
            } else {
              return ListView.builder(
                itemCount: videos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(videos[index]['teacher']['name']),
                    leading: Icon(Icons.live_tv),
                    onTap: () async {
                      await onJoin(videos[index]['teacher']['username'],
                          videos[index]['id']);
                    },
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

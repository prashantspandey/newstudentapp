import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/NativeLiveVideo.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';
import 'package:student_app/screens/SingleVideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/YoutubeVideo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoList extends StatefulWidget {
  StudentUser user = StudentUser();
  VideoList(this.user);
  @override
  State<StatefulWidget> createState() {
    return _VideoList(user);
  }
}

class _VideoList extends State<VideoList> {
  StudentUser user = StudentUser();
  _VideoList(this.user);

  getVideos(key) async {
    var videos = await getAllVideos(key);
    return videos['videos'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'All Videos',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: getVideos(user.key),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data != null) {
                  var videos = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: videos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                "assets/videoplayer.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.045,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                videos[index]['title'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Subject:  ' +
                                        videos[index]['subject']['name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Chapter:  ' +
                                        videos[index]['chapter']['name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              videos[index]['publishDate']
                                  .toString()
                                  .split('T')[0]
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                            onTap: () {
                              videos[index]['link'].contains('yout')
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YoutubeVideo(
                                              user,
                                              YoutubePlayer.convertUrlToId(
                                                  videos[index]['link']))))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleVideoPlayer(
                                                  videos[index]['title'],
                                                  videos[index]['link'])));
//
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => NativeVideoWebView(
                              //             videos[index]['link'])));
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.deepOrange,
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

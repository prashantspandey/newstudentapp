import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/MainTestScreen.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';

class ChapterVideos extends StatefulWidget {
  StudentUser user = StudentUser();
  int chapterId;
  ChapterVideos(this.user, this.chapterId);
  @override
  _ChapterVideosState createState() => _ChapterVideosState();
}

class _ChapterVideosState extends State<ChapterVideos> {
  getChapterwiseVideos() async {
    var response = await getChapterVideos(widget.user.key, widget.chapterId);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: getChapterwiseVideos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          var videos = snapshot.data['videos'];
          if (videos.length != 0) {
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int index) {
                                        return Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                "assets/videoplayer.png",
                                height: MediaQuery.of(context).size.height * 0.045,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                videos[index]['title'],
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('Subject:  ' +
                                      videos[index]['subject']['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('Chapter:  ' +
                                      videos[index]['chapter']['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                            trailing: Text(videos[index]['publishDate']
                                .toString()
                                .split('T')[0]
                                .toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => NativeVideoWebView(
                              //             videos[index]['link'])));
                            },
                          ),
                        );


              },
            );
          } else {
            return Center(
              child: Text('No videos in this chapter.'),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/YoutubeVideo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'SingleVideoPlayer.dart';

class CurrentAffairs extends StatefulWidget {
  StudentUser user = StudentUser();
  CurrentAffairs(this.user);
  @override
  _CurrentAffairsState createState() => _CurrentAffairsState(this.user);
}

class _CurrentAffairsState extends State<CurrentAffairs>
    with SingleTickerProviderStateMixin {
  StudentUser user = StudentUser();
  _CurrentAffairsState(this.user);
  @override
  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    scrollController = ScrollController();
    super.initState();
  }

  var tabController;
  var scrollController;
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                // centerTitle: true,
                actions: <Widget>[
                  Container(
                    width: 50,
                  )
                ],
                pinned: true,
                floating: true,
                backgroundColor: Colors.orangeAccent,
                title: Text(
                  " Current Affairs",
                  style: TextStyle(color: Colors.white),
                ),
                bottom: TabBar(
                  // unselectedLabelColor: Colors.blue,
                  indicatorWeight: 2.0,
                  // labelColor: Colors.red,
                  indicatorColor: Colors.white,
                  controller: tabController,
                  tabs: <Widget>[
                    Tab(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/article.png",
                            height: MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                        Text("Articles"),
                      ],
                    )),
                    Tab(
                        // icon: Icon(
                        //   Icons.threesixty,
                        // ),
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/play.png",
                            height: MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                        Text("Videos"),
                      ],
                    )),
                  ],
                ))
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            CurrentAffairsArticles(user),
            CurrentAffairsVideos(user),
          ],
        ),
      ),
    );
  }
}

class CurrentAffairsArticles extends StatefulWidget {
  StudentUser user = StudentUser();
  CurrentAffairsArticles(this.user);
  @override
  _CurrentAffairsArticlesState createState() =>
      _CurrentAffairsArticlesState(this.user);
}

class _CurrentAffairsArticlesState extends State<CurrentAffairsArticles> {
  StudentUser user = StudentUser();
  _CurrentAffairsArticlesState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getCurrentAffairsArticles(user.key),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              var notes = snapshot.data['notes'];
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/article.png",
                            height: MediaQuery.of(context).size.height * 0.045,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            notes[index]['title'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Subject : ' + notes[index]['subject']['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Chapter : ' + notes[index]['chapter']['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.deepOrange,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CurrentAffairsVideos extends StatefulWidget {
  StudentUser user = StudentUser();
  CurrentAffairsVideos(this.user);
  @override
  _CurrentAffairsVideosState createState() =>
      _CurrentAffairsVideosState(this.user);
}

class _CurrentAffairsVideosState extends State<CurrentAffairsVideos> {
  StudentUser user = StudentUser();
  _CurrentAffairsVideosState(this.user);
  getCurrentAffairsVideos(key) async {
    var videos = await getAllCurrentAffairsVideos(user.key);
    return videos['videos'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: getCurrentAffairsVideos(user.key),
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
                              "assets/play.png",
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Chapter:  ' +
                                      videos[index]['chapter']['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                        builder: (context) => SingleVideoPlayer(
                                            videos[index]['title'],
                                            videos[index]['link'])));
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
    );
  }
}

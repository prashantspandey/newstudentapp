import 'package:student_app/pojos/basic.dart';
import 'package:student_app/screens/AllNotesScreen.dart';
import 'package:student_app/screens/ChapterNotes.dart';
import 'package:student_app/screens/ChapterTest.dart';
import 'package:student_app/screens/ChapterVideos.dart';
import 'package:student_app/screens/VideoList.dart';
import 'package:flutter/material.dart';

class ChapterTabView extends StatefulWidget {
  StudentUser user = StudentUser();
  var  chapterObject;
  ChapterTabView(this.user,this.chapterObject);

  @override
  _ChapterTabViewState createState() => _ChapterTabViewState(user,chapterObject);
}

class _ChapterTabViewState extends State<ChapterTabView>
  with SingleTickerProviderStateMixin {
  StudentUser user = StudentUser();
  var chapterObject;
  _ChapterTabViewState(this.user,this.chapterObject);
  @override
  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
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
                  chapterObject['name'],
                  style: TextStyle(color: Colors.white),
                ),
                bottom: TabBar(
                  // unselectedLabelColor: Colors.blue,
                  indicatorWeight: 4.0,
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
                            "assets/videoplayer.png",
                            height: MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                        Text("Videos",style: TextStyle(color: Colors.black,fontSize: 10)),
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
                            "assets/exam.png",
                            height: MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                        Text("Tests",style: TextStyle(color: Colors.black,fontSize: 10),),
                      ],
                    )),
                    Tab(
                        // icon: Icon(Icons.note_add),
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/notebook.png",
                            height: MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                        Text("Notes",style: TextStyle(color: Colors.black,fontSize: 10)),
                      ],
                    ))
                  ],
                ))
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: <Widget>[ChapterVideos(user,chapterObject['id']), ChapterTest(user,chapterObject['id']), ChapterNotes(user,chapterObject['id'])],
        ),
      ),
    );
  }
}
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:student_app/pojos/ContentPojo.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/MainTestScreen.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';

class ChapterTest extends StatefulWidget {
  StudentUser user = StudentUser();
  int chapterId;
  ChapterTest(this.user,this.chapterId);
  @override
  State<StatefulWidget> createState() {
    return _ChapterTest(user);
  }
}

class _ChapterTest extends State<ChapterTest> {
  StudentUser user = StudentUser();
  _ChapterTest(this.user);
  FileInfo fileInfo;
  String error;
  int downloaded = 0;
  int numberQuestions;
  double progress;
  @override
  void dispose() {
    super.dispose();
  }

  showLoadingDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              color: Colors.transparent,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        });
  }

  showConfirmationDialog(context, test) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  Text(
                    'You want to start test now? You can only take this test only once',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.orange,
                        child: Text(
                          'Start test',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return QuestionLoading(user, test);
                              });

                          // Navigator.pushReplacement(
                          // context,
                          // MaterialPageRoute(
                          // builder: (context) =>
                          // MainTestScreen(widget.user, test)));
                        },
                      ),
                      RaisedButton(
                        color: Colors.black,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  questionDownloader(context, test) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
                children: <Widget>[
                  //LinearProgressIndicator(value: progress,),
                  Text(progress.toString())
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getChapterTests(user.key,widget.chapterId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data != null) {
              var tests = snapshot.data['tests'];
              if (tests.length == 0) {
                return Center(child: Text('No tests for you right now.'));
              } else {
                return ListView.builder(
                  itemCount: tests.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            tests[index]['numberQuestions'].toString() +
                                ' questions',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.022,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/exam.png",
                            height: MediaQuery.of(context).size.height * 0.045,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Time: ' +
                                        tests[index]['time'].toString() +
                                        ' min',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Marks: ' +
                                        tests[index]['totalMarks'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(5.0),
                            //   child: Text('Subjects',style: TextStyle(fontWeight: FontWeight.bold),),
                            // ),
                            Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemCount: tests[index]['subjects'].length,
                                itemBuilder:
                                    (BuildContext context, int subjectindex) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        "Subject : ${tests[index]['subjects'][subjectindex]['name']}"),
                                  );
                                },
                              ),
                            ),
                            // Text('Chapters'),
                            Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemCount: tests[index]['chapters'].length,
                                itemBuilder:
                                    (BuildContext context, int chapterindex) {
                                  return Text(
                                      " Chapters : ${tests[index]['chapters'][chapterindex]['name']}");
                                },
                              ),
                            ),
                            // Divider(
                            //   color: Colors.orange,
                            // )
                          ],
                        ),
                        onTap: () async {
                          showLoadingDialog(context);
                          var test = await getIndividualTest(
                              user.key, tests[index]['id']);
                          Navigator.pop(context);
                          //showConfirmationDialog(context, test);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return QuestionLoading(user, test);
                              });

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             MainTestScreen(user, test)));
                        },
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ));
            }
          },
        ),
      ),
    );
  }
}

class QuestionLoading extends StatefulWidget {
  StudentUser user = StudentUser();
  Test test;
  QuestionLoading(this.user, this.test);
  @override
  State<StatefulWidget> createState() {
    return _QuestionLoading(test);
  }
}

class _QuestionLoading extends State<QuestionLoading> {
  Test test;
  _QuestionLoading(this.test);
  FileInfo fileInfo;
  String error;
  int downloaded;
  int numberQuestions;
  double progress;
  bool allDownloaded = false;
  @override
  void initState() {
    super.initState();
    questionDownloader(test);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _downloadFile(url) {
    DefaultCacheManager().getFile(url).listen((f) {
      setState(() {
        fileInfo = f;
        error = null;
        downloaded += 1;
        progress = (downloaded / numberQuestions) * 100;
      });
      if (downloaded == numberQuestions) {
        setState(() {
          allDownloaded = true;
        });
        // Navigator.pushReplacement(
        // context,
        // MaterialPageRoute(
        // builder: (context) =>
        // MainTestScreen(widget.user, test)));

      }
    }).onError((e) {
      setState(() {
        fileInfo = null;
        error = e.toString();
      });
    });
  }

  questionDownloader(test) {
    setState(() {
      downloaded = 0;
      numberQuestions = 0;
      progress = 0;
    });

    var questions = test.questions;
    setState(() {
      numberQuestions = test.questions.length;
    });
    for (var quest in questions) {
      String link = quest.picture;
      _downloadFile(link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Test',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(test.questions.length.toString()),
                            Text('Questions')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(test.time.toString() + ' min'),
                            Text('Duration')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Chapters',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: test.chapters.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(test.chapters[index].name + ','),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                child: Text('Loading questions...'),
                visible: !allDownloaded,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                  visible: !allDownloaded,
                  child: Center(child: CircularProgressIndicator())),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: allDownloaded,
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width - 50,
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text('Start', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainTestScreen(widget.user, test)));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


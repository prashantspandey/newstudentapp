import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:student_app/pojos/ContentPojo.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/screens/BuyPackageScreen.dart';
import 'package:student_app/screens/MainTestScreen.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';
import 'package:student_app/screens/NotePdfView.dart';
import 'package:student_app/screens/RazorPayScreen.dart';
import 'package:student_app/screens/SingleVideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_app/requests/request.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:student_app/screens/YoutubeVideo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IndividualPackages extends StatefulWidget {
  StudentUser user = StudentUser();
  var packageId;
  bool bought;
  IndividualPackages(this.user, this.packageId, this.bought);

  @override
  State<StatefulWidget> createState() {
    return _IndividualPackages();
  }
}

class _IndividualPackages extends State<IndividualPackages> {
  var urlPdfPath;
  bool notesLoader = true;
  bool isPackageRequest = true;
  getPackageDetails(key, packageId) async {
    var packageDetails = await getIndividualPackageDetails(key, packageId);
    print('individual package ${packageDetails.toString()}');
    return packageDetails;
  }

  buyPackageRequest() async {
    var response = await isBuyPackageRequest(widget.user.key, widget.packageId);
    setState(() {
      print('is erquest ${response["isRequest"]}');
      isPackageRequest = response['isRequest'];
    });
  }

  showLoaderDialog(context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  getNoteFileUrl(String url) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(url);
      //var file = await DefaultCacheManager().downloadFile(url);
      return file;
      // print('finalURL ${url.toString()}');
      // print('starting donwnload');
//      var data = await http.get(url);
      //     var bytes = data.bodyBytes;
      // print(' donwnloaded');
      // var dir = await getApplicationDocumentsDirectory();
      // File file = File("${dir.path}/noteonline.pdf");
      // File urlfile = await file.writeAsBytes(bytes);
      // print('url file got');
      // return urlfile;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    getPackageDetails(widget.user.key, widget.packageId);
    buyPackageRequest();
  }

  showTakeTestDialog(context, user, testId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Start this test?'),
            content: Container(
              color: Colors.white,
              height: 100,
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Do you want to start this test?'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () async {
                          studenCheckTakenTest(user.key, testId)
                              .then((f) async {
                            bool taken = f['status'];
                            print('taken ${taken.toString()}');
                            if (taken == true) {
                              Fluttertoast.showToast(
                                  msg: 'You have already taken this test.');
                              Navigator.pop(context);
                            } else {
                              var test =
                                  await getIndividualTest(user.key, testId);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainTestScreen(user, test)));
                            }
                          });
                        },
                        child: Text(
                          'Start Test',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  openNoteFunction(noteUrl) async {
    showLoaderDialog(context);
    getNoteFileUrl(noteUrl.toString().replaceAll("\"", '')).then((f) {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NotePdfView(f.path)));
    });
  }

  openVideoFunction(videoUrl) async {
    videoUrl.contains('yout')
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => YoutubeVideo(
                    widget.user, YoutubePlayer.convertUrlToId(videoUrl))))
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleVideoPlayer('Video', videoUrl)));
  }

  openTestFunction(testId) async {
    var test = await getIndividualTest(widget.user.key, testId);
    showDialog(
        context: context,
        builder: (context) {
          return QuestionLoading(widget.user, test);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: getPackageDetails(widget.user.key, widget.packageId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.deepOrange,
                  ));
                } else {
                  var packageDetails = snapshot.data['package_details'];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Name:' +
                                packageDetails['title'].replaceAll('\"', ''),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Price : ' + packageDetails['price'].toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                                'Duration : ' +
                                    packageDetails['duration'].toString() +
                                    ' days',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                                'Videos : ' +
                                    packageDetails['numberVideos'].toString(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                                'Notes : ' +
                                    packageDetails['numberNotes'].toString(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          'Details:' + packageDetails['details'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Videos',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: packageDetails['videos'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 +
                                      100,
                                  child: Card(
                                    child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          packageDetails['videos'][index]
                                              ['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      leading: Image.asset(
                                          "assets/videoplayer.png",
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Divider(
                                              thickness: 2,
                                              color: Colors.orange),
                                          Text(
                                            'Subject ' +
                                                packageDetails['videos'][index]
                                                    ['subject'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Chapter ' +
                                                packageDetails['videos'][index]
                                                    ['chapter'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        widget.bought
                                            ? openVideoFunction(
                                                packageDetails['videos'][index]
                                                    ['url'])
                                            : Fluttertoast.showToast(
                                                msg:
                                                    "Please buy package to see this video");
                                        // ? await Navigator.push(
                                        // context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             // NativeVideoWebView(
                                        //             //   packageDetails['videos']
                                        //             //           [index]['url']
                                        //             //       .toString()
                                        //             //       .replaceAll("\"", ""),
                                        //             // )))
                                        // : Fluttertoast.showToast(
                                        //     msg:
                                        //         'Please buy this package to view this video.');
                                      },
                                      onLongPress: () {
                                        print(packageDetails['videos'][index]
                                            ['video_id']);
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Notes',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: packageDetails['notes'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 +
                                      100,
                                  child: Card(
                                    child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          packageDetails['notes'][index]
                                              ['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      leading: Image.asset(
                                          "assets/notebook.png",
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Divider(
                                              thickness: 2,
                                              color: Colors.orange),
                                          Text(
                                            'Subject ' +
                                                packageDetails['notes'][index]
                                                    ['subject'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Chapter ' +
                                                packageDetails['notes'][index]
                                                    ['chapter'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        widget.bought
                                            ? openNoteFunction(
                                                packageDetails['notes']['index']
                                                    ['url'])
                                            : Fluttertoast.showToast(
                                                msg:
                                                    "Please buy package to see this note.");

                                        //showLoaderDialog(context);
                                        // widget.bought
                                        //     ? MaterialPageRoute(
                                        //         builder: (context) => NativeVideoWebView(
                                        //             "https://docs.google.com/viewer?url=" +
                                        //                 packageDetails['notes'][index]
                                        //                         ['url']
                                        //                     .toString()
                                        //                     .replaceAll("\"", "")))
                                        //     :

                                        // getNoteFileUrl(packageDetails['notes']
                                        // [index]['url']
                                        // .toString()
                                        // .replaceAll("\"", ''))
                                        // .then((f) {
                                        // Navigator.pop(context);
                                        // Navigator.push(
                                        // context,
                                        // MaterialPageRoute(
                                        // builder: (context) =>
                                        // NotePdfView(f.path)));
                                        // })
                                        // Fluttertoast.showToast(
                                        // msg:
                                        // 'Please buy this package to see this note.');
                                      },
                                      onLongPress: () {
                                        print(packageDetails['notes'][index]
                                            ['note_id']);
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Tests',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: packageDetails['tests'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 +
                                      100,
                                  child: Card(
                                    // elevation: 2,
                                    child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          packageDetails['tests'][index]
                                                  ['publisehd']
                                              .split('T')[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      leading: Image.asset("assets/exam1.png",
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Divider(
                                            //     thickness: 2, color: Colors.orange),
                                            Text(
                                              packageDetails['tests'][index]
                                                      ['subject']
                                                  .toString()
                                                  .replaceAll('[', '')
                                                  .replaceAll(']', ''),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Questions: ' +
                                                  packageDetails['tests'][index]
                                                          ['numberQuestions']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        widget.bought
                                            ? openTestFunction(
                                                packageDetails['tests'][index]
                                                    ['id'])
                                            : Fluttertoast.showToast(
                                                msg:
                                                    'Please buy this package to attempt this test');
                                      },
                                      onLongPress: () {
                                        print(packageDetails['tests'][index]
                                            ['id']);
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Spacer(),
                      widget.bought
                          ? Container(
                              height: 0,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  color: Colors.orangeAccent,
                                  onPressed: () {
                                    // Navigator.push(
                                    // context,
                                    // MaterialPageRoute(
                                    // builder: (context) => RazorPayScreen(
                                    // widget.user,
                                    // packageDetails['id'],
                                    // packageDetails['price'])));
                                    isPackageRequest
                                        ? null
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BuyPackageScreen(
                                                        widget.user,
                                                        widget.packageId)));
                                  },
                                  child: Text(
                                      isPackageRequest
                                          ? 'Already Requested'
                                          : 'Buy Package',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            )
                    ],
                  );
                }
              },
            ),
          ),
        ],
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

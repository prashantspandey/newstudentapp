import 'dart:io';
import 'package:student_app/pojos/basic.dart';
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
  getPackageDetails(key, packageId) async {
    var packageDetails = await getIndividualPackageDetails(key, packageId);
    print('individual package ${packageDetails.toString()}');
    return packageDetails;
  }

  @override
  void initState() {
    super.initState();
    getPackageDetails(widget.user.key, widget.packageId);
  }

  getNoteFileUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/noteonline.pdf");
      File urlfile = await file.writeAsBytes(bytes);
      return urlfile;
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }

  showLoaderDialog(context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator(backgroundColor: Colors.deepOrange,));
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder(
        future: getPackageDetails(widget.user.key, widget.packageId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.deepOrange,));
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
                      'Name:' + packageDetails['title'].replaceAll('\"', ''),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                          'Videos : ' + packageDetails['numberVideos'].toString(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          'Notes : ' + packageDetails['numberNotes'].toString(),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        fontSize: MediaQuery.of(context).size.height * 0.03,
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
                            width: MediaQuery.of(context).size.width / 2,
                            child: Card(
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    packageDetails['videos'][index]['title'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                leading: Image.asset("assets/videoplayer.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Divider(thickness: 2, color: Colors.orange),
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
                                  // widget.bought
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
                        fontSize: MediaQuery.of(context).size.height * 0.03,
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
                            width: MediaQuery.of(context).size.width / 2,
                            child: Card(
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    packageDetails['notes'][index]['title'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                leading: Image.asset("assets/notebook.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Divider(thickness: 2, color: Colors.orange),
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
                        fontSize: MediaQuery.of(context).size.height * 0.03,
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
                            width: MediaQuery.of(context).size.width / 2,
                            child: Card(
                              // elevation: 2,
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    packageDetails['tests'][index]['publisehd']
                                        .split('T')[0],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                leading: Image.asset("assets/exam1.png",
                                    height: MediaQuery.of(context).size.height *
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
                                  print('test');
                                  showTakeTestDialog(context, widget.user,
                                      packageDetails['tests'][index]['id']);
                                },
                                onLongPress: () {
                                  print(packageDetails['tests'][index]['id']);
                                },
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  height: 20,
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RazorPayScreen(
                                          widget.user,
                                          packageDetails['id'],
                                          packageDetails['price'])));
                            },
                            child: Text('Buy Package',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
              ],
            );
          }
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/NativeVideoWebView.dart';
import 'package:student_app/screens/NotePdfView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AllNotesScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  AllNotesScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _AllNotesScreen();
  }
}

class _AllNotesScreen extends State<AllNotesScreen> {
  var finalURL;
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

  showLoaderDialog(context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _launchUrl() async {
    print('final note url ${finalURL}');
    if (await canLaunch(finalURL)) {
      String lastURL = "https://docs.google.com/viewer?url="+finalURL;
      await launch(lastURL,forceWebView: false);
    } else {
      throw "Could not open url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('All Notes'), backgroundColor: Colors.orangeAccent),
      body: Container(
        child: FutureBuilder(
          future: getAllNotes(widget.user.key),
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
                            "assets/notebook.png",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        onTap: () {
                          // setState(() {
                            // finalURL = notes[index]['url']
                                // .toString()
                                // .replaceAll("\"", "");
                          // });
                          // _launchUrl();
                          // Navigator.push(
                          // context,
                          // MaterialPageRoute(
                          // builder: (context) => NativeVideoWebView(
                          // "https://docs.google.com/viewer?url=" +
                          // notes[index]['url']
                          // .toString()
                          // .replaceAll("\"", ""))));

                          // showLoaderDialog(context);
                          showLoaderDialog(context);
                          getNoteFileUrl(notes[index]['url']
                          .toString()
                          .replaceAll("\"", ''))
                          .then((f) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotePdfView(f.path)));
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/ChapterTabView.dart';

class ChaptersScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  int subjectId;
  ChaptersScreen(this.user, this.subjectId);
  @override
  State<StatefulWidget> createState() {
    return _ChaptersScreen(user, subjectId);
  }
}

class _ChaptersScreen extends State<ChaptersScreen> {
  StudentUser user = StudentUser();
  int subjectId;
  _ChaptersScreen(this.user, this.subjectId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
        backgroundColor: Colors.orangeAccent
      ),
      body: Container(
        child: FutureBuilder(
          future: getSubjectChapters(user.key, subjectId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data != null) {
              var chapters = snapshot.data['chapters'];
              return ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(chapters[index]['name']),
                    leading: Icon(Icons.library_books),
                    onTap: (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChapterTabView(widget.user,chapters[index])));

                    },
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

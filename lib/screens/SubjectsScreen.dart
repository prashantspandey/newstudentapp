import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/ChaptersScreen.dart';
import 'package:flutter/material.dart';

import '../requests/request.dart';

class SubjectsScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  var courseId;
  SubjectsScreen(this.user, {this.courseId});

  @override
  State<StatefulWidget> createState() {
    return _SubjectsScreen(user);
  }
}

class _SubjectsScreen extends State<SubjectsScreen> {
  StudentUser user = StudentUser();
  _SubjectsScreen(this.user);

  getSubjects(key) async {
    if (widget.courseId == null) {
      var response = await getAllSubjects(key);
      return response['subjects'];
    } else {
      var response = await subjectOfCourse(key, widget.courseId);
      return response['subjects'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Subjects'), backgroundColor: Colors.orangeAccent),
      body: Container(
        child: FutureBuilder(
          future: getSubjects(user.key),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data != null) {
              var subjects = snapshot.data;
              return ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(subjects[index]['name']),
                    leading: Image.asset(
                      "assets/ebook.png",
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChaptersScreen(user, subjects[index]['id'])));
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

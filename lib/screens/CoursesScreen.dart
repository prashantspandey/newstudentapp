import 'package:flutter/material.dart';

import '../pojos/basic.dart';
import '../requests/request.dart';
import 'SubjectsScreen.dart';

class CoursesScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  CoursesScreen(this.user);
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: getCourses(widget.user.key),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var courses = snapshot.data['courses'];
                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.asset('assets/courses.webp'),
                            title: Text(courses[index]['name']),
                            subtitle: Divider(
                              color: Colors.orangeAccent,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubjectsScreen(widget.user,courseId: courses[index]['id'],)));

                              print(courses[index]['id']);
                            },
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
            )
          ],
        ),
      ),
    );
  }
}

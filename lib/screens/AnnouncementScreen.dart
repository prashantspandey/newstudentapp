import 'package:flutter/material.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';

class AnnouncementScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  AnnouncementScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _AnnouncementScreen(user);
  }
}

class _AnnouncementScreen extends State<AnnouncementScreen> {
  StudentUser user = StudentUser();
  _AnnouncementScreen(this.user);

  getAllAnnouncements() async {
    var response = await allAnnouncements(user.key);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: getAllAnnouncements(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    print(snapshot.data['announcements']);
                    var announcements = snapshot.data['announcements'];

                    if (announcements.length == 0) {
                      return Center(
                        child: Text('Sorry no announcements right now !'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: announcements.length,
                        shrinkWrap: true,
                        reverse: true,
                        itemBuilder: (BuildContext context, int index) {
                          var _date = announcements[index]['time']
                              .toString()
                              .split('T')[0]
                              .toString();
                          var _time = announcements[index]['time']
                              .toString()
                              .split('T')[1]
                              .toString()
                              .split('.')[0]
                              .toString();
                          return ListTile(
                              leading: Icon(Icons.message),
                              title: Text(announcements[index]['text']),
                              trailing: Column(
                                children: <Widget>[Text(_date), Text(_time)],
                              ));
                        },
                      );
                    }
                  } else {
                    return Center(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
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

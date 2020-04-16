import 'package:flutter/material.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';

class BatchesScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  BatchesScreen(this.user);
  @override
  State<StatefulWidget> createState() {
    return _BatchesScreen(user);
  }
}

class _BatchesScreen extends State<BatchesScreen> {
  StudentUser user = StudentUser();
  _BatchesScreen(this.user);

  getMyBatches() async {
    var response = await studentBatches(user.key);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batches'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: getMyBatches(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var batches = snapshot.data['batches'];
                    return ListView.builder(
                      itemCount: batches.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/courses.webp'),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(batches[index]['name']),
                          ),
                          subtitle: Divider(
                            color: Colors.orangeAccent,
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
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

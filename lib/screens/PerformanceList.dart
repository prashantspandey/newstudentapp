import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/TestResult.dart';

class PerformanceList extends StatefulWidget {
  StudentUser user = StudentUser();
  PerformanceList(this.user);
  @override
  State<StatefulWidget> createState() {
    return _PerformanceList(user);
  }
}

class _PerformanceList extends State<PerformanceList> {
  StudentUser user = StudentUser();
  _PerformanceList(this.user);

  getTakenTestList(key) async {
    var performanceList = await getTakenTests(key);
    return performanceList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Performances'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        child: FutureBuilder(
          future: getTakenTestList(user.key),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data != null) {
              var performanceList = snapshot.data['test'];
              return ListView.builder(
                itemCount: performanceList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        "assets/exam1.png",
                        height: MediaQuery.of(context).size.height * 0.045,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                            performanceList[index]['numberQuestions'].toString() +
                                ' questions',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.022,fontWeight: FontWeight.bold),),
                      ),
                      trailing: Text(performanceList[index]['published']
                          .split('T')[0]
                          .toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        children: <Widget>[
                          Container(
                            height: 20,
                            child: ListView.builder(
                              itemCount:
                                  performanceList[index]['subjects'].length,
                              itemBuilder:
                                  (BuildContext context, int subjectIndex) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(performanceList[index]['subjects']
                                      [subjectIndex]['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 30,
                            child: ListView.builder(
                              itemCount:
                                  performanceList[index]['chapters'].length,
                              itemBuilder:
                                  (BuildContext context, int chapterIndex) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(performanceList[index]['chapters']
                                      [chapterIndex]['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TestResult(
                                    user, performanceList[index]['id'])));
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrange,
              ));
            }
          },
        ),
      ),
    );
  }
}
import 'package:student_app/pojos/ContentPojo.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TestResult extends StatefulWidget {
  int performanceId;
  StudentUser user = StudentUser();
  TestResult(this.user, this.performanceId);
  @override
  State<StatefulWidget> createState() {
    return _TestResult(user, performanceId);
  }
}

class _TestResult extends State<TestResult> {
  int performanceId;
  StudentUser user = StudentUser();
  _TestResult(this.user, this.performanceId);

  testPerformance(key, performanceId) async {
    print('performanceID ${performanceId.toString()}');
    var response = await getTestPerformance(key, performanceId);
    print('test performance ${response.toString()}');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Result'), backgroundColor: Colors.orangeAccent),
      body: Container(
        child: FutureBuilder(
          future: testPerformance(user.key, performanceId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data != null) {
              var performance = snapshot.data['performance'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Marks : ' + performance['totalMarks'].toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.025),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Time : ' + performance['time'].toString() + ' seconds',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.02),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(performance['right'].toString()),
                          ),
                          label: Text('Right'),
                        ),
                        Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(performance['wrong'].toString()),
                          ),
                          label: Text('Wrong'),
                        ),
                        Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: Text(performance['skipped'].toString()),
                          ),
                          label: Text('Skipped'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: performance['attemptedQuestions'].length,
                      itemBuilder: (BuildContext context, int questionIndex) {
                        bool attemptedRight = false;
                        bool skipped = false;
                        bool toShowPredicament;
                        if (performance['attemptedQuestions'][questionIndex]
                                ['right'] !=
                            null) {
                          attemptedRight = performance['attemptedQuestions']
                              [questionIndex]['right'];
                          toShowPredicament = true;
                        } else {
                          attemptedRight = false;
                          skipped = true;
                          toShowPredicament = false;
                        }

                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: Text((questionIndex + 1).toString()),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: toShowPredicament && attemptedRight
                                          ? Row(
                                            children: <Widget>[
                                              Chip(
                                                  avatar: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.green.shade800,
                                                    child: Icon(Icons.check),
                                                  ),
                                                  label: Text('Correct',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                            SizedBox(width: 10,),
                                            Chip(
                                              avatar: CircleAvatar(
                                                backgroundColor: Colors.green,
                                                child: Icon(Icons.add),
                                                radius: 12,
                                              ),
                                              label: Text(
                                                  performance['attemptedQuestions']
                                                                  [
                                                                  questionIndex]
                                                              ['question']
                                                          ['marks']
                                                      .toString()),
                                            ),

                                            ],
                                          )
                                          : Container(
                                              height: 0,
                                            )),
                                  toShowPredicament && !attemptedRight
                                      ? Row(
                                          children: <Widget>[
                                            Chip(
                                              avatar: CircleAvatar(
                                                backgroundColor:
                                                    Colors.red,
                                                child: Icon(Icons.remove),
                                              ),
                                              label: Text('Wrong',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(width: 10,),
                                            Chip(
                                              avatar: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: Icon(Icons.remove),
                                                radius: 12,
                                              ),
                                              label: Text(
                                                  performance['attemptedQuestions']
                                                                  [
                                                                  questionIndex]
                                                              ['question']
                                                          ['negativeMarks']
                                                      .toString()),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                  !toShowPredicament
                                      ? Chip(
                                          avatar: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Text('S'),
                                          ),
                                          label: Text('Skipped',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: performance['attemptedQuestions']
                                            [questionIndex]['attempted']
                                        ? Chip(
                                            avatar: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              child: Icon(Icons.timer),
                                            ),
                                            label: Text(
                                                performance['attemptedQuestions']
                                                                [questionIndex]
                                                            ['time']
                                                        .toString() +
                                                    ' sec.'),
                                          )
                                        : Container(
                                            height: 0,
                                          ),
                                  ),
                                ],
                              ),
                              QuestionPerformance(
                                  performance['attemptedQuestions']
                                      [questionIndex]['question']),
                              Divider(
                                height: 1,
                                color: Colors.orange,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
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

class QuestionPerformance extends StatelessWidget {
  var question;
  QuestionPerformance(this.question);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          question['direction']['text'] == null
              ? Container(
                  height: 0,
                )
              : Text(question['direction']['text']),
          question['direction']['picture'] == null
              ? Container(
                  height: 0,
                )
              : CachedNetworkImage(imageUrl: question['direction']['picture']),
          question['picture'] == null
              ? Container(
                  height: 0,
                )
              : CachedNetworkImage(
                  imageUrl: question['picture'],
                  placeholder: (context, url) {
                    return CircularProgressIndicator();
                  },
                ),
          question['text'] == null
              ? Container(
                  height: 0,
                )
              : Text(question['text']),
          Container(
            height: 200,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: question['options'].length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                    child: OptionPerformance(question['options'][index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OptionPerformance extends StatelessWidget {
  var option;
  OptionPerformance(this.option);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            option['text'] == null
                ? Container(
                    height: 0,
                  )
                : option['correct']
                    ? Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text(option['text']),
                        ),
                        label: Row(
                          children: <Widget>[
                            Icon(Icons.check),
                            SizedBox(width: 10,),
                            option['selected']?
                            Text('Your selection',style: TextStyle(fontWeight: FontWeight.bold),):
                            Text('')
                          ],
                        ),
                      )
                    :
                     Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text(option['text']),
                        ),
                        label: Row(
                          children: <Widget>[
                            option['selected']?
                            Text('Your selection',style: TextStyle(fontWeight: FontWeight.bold),):
                            Text(''),
                          ],
                        ),
                      ),

            option['picture'] == null
                ? Container(
                    height: 0,
                  )
                : CachedNetworkImage(
                    imageUrl: option['picture'],
                    placeholder: (context, url) {
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.deepOrange,
                      ));
                    },
                  ),
          ],
        ),
      ],
    );
  }
}

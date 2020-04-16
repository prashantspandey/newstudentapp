import 'package:student_app/notifiers/OptionSelected.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/pojos/ContentPojo.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/TestResult.dart';
import 'package:student_app/screens/TestScreen.dart';
import 'package:student_app/screens/TestTimer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainTestScreen extends StatefulWidget {
  StudentUser studentUser;
  Test test;
  //int betAmount;
  //int betId;
  MainTestScreen(this.studentUser, this.test);

  @override
  State<StatefulWidget> createState() {
    return _MainTestScreenState(studentUser, test);
  }
}

class _MainTestScreenState extends State<MainTestScreen> {
  StudentUser studentUser;
  Test test;
  _MainTestScreenState(this.studentUser, this.test);
  int questionNumber = 0;
  OptionSelected optionSelected = OptionSelected();
  String minutesShow = '';
  String secondsShow = '';

  increaseQuestionNumber() {
    int numberQuestion = test.questions.length;
    if (questionNumber < numberQuestion - 1) {
      if (this.mounted) {
        setState(() {
          questionNumber += 1;
          print(
              'total question ${numberQuestion.toString()} , on question ${questionNumber.toString()}');
        });
      }
    }
  }

  decreaceQuestionNumber() {
    if (questionNumber > 0) {
      if (this.mounted) {
        setState(() {
          questionNumber -= 1;
        });
      }
    }
  }

  skipToQuestion(int qNumber) {
    if (this.mounted) {
      setState(() {
        questionNumber = qNumber;
      });
    }
  }

  showLoader(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  testSubmit(context) async {
    //Navigator.pop(context);
    List qIds = List();
    for (Question o in test.questions) {
      qIds.add(o.id);
    }
    List answers = optionSelected.getSubmitAnswers(qIds);
    int totalTime = optionSelected.getTotalTime();
    showLoader(context);
    var testPerformance =
        await submitTest(studentUser.key, test.id, answers, totalTime);
    //print('test performance status ${testPerformance.status}');
    if (testPerformance['status'] == 'Success') {
      try {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } on Exception catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: 'Test submitted successfully.');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TestResult(studentUser, testPerformance['message'])));
    } else {
      Fluttertoast.showToast(msg: testPerformance['message']);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color colorButton(qNumber) {
    if (qNumber == questionNumber) {
      return Colors.black;
    } else {
      List attempted = optionSelected.getAttempted();
      if (attempted != null) {
        int quest_id = test.questions[qNumber].id;
        int index = attempted.indexOf(quest_id);
        if (index != -1) {
          return Colors.blue.withOpacity(0.4);
        } else {
          return Colors.white;
        }
      }
      return Colors.white;
    }
  }

  Color colorText(qNumber) {
    if (qNumber == questionNumber) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    int numberQuestion = test.questions.length;
    if (test != null) {
      return WillPopScope(
        onWillPop: () async {
          return showSubmitDialog(context);
        },
        child: Scaffold(
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Question Number: ' +
                                (questionNumber + 1).toString() +
                                ' /' +
                                numberQuestion.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ButtonTheme(
                            minWidth: 10,
                            height: 30,
                            child: RaisedButton(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.deepOrange, fontSize: 15),
                              ),
                              onPressed: () {
                                showSubmitDialog(context);
                                //testSubmit();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AboveQuestionWidget(
                    test: test,
                    questionNumber: questionNumber,
                    optionSelected: optionSelected),
                //Divider(height: 5.0, color: Colors.black),

                Expanded(
                    flex: 8,
                    child: TestScreen(
                        test.questions[questionNumber], optionSelected)),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          'Previous',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => decreaceQuestionNumber(),
                        color: Colors.black,
                      ),
                      RaisedButton(
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => increaseQuestionNumber(),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: ListView.builder(
                    itemCount: numberQuestion,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ButtonTheme(
                          minWidth: 20,
                          height: 15,
                          child: RaisedButton(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                  fontSize: 15, color: colorText(index)),
                            ),
                            onPressed: () => skipToQuestion(index),
                            color: colorButton(index),
                            elevation: 2,
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  showSubmitDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you want to submit test?'),
            actions: <Widget>[
              RaisedButton(
                color: Colors.deepOrangeAccent,
                child: Text(
                  'Sumbit Test',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  //Navigator.pop(context);
                  testSubmit(context);
                },
              ),
              RaisedButton(
                color: Colors.black,
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  performanceDialog(context, testPerformance) {
    var marks = testPerformance.performance;
    var score = marks['marks'];
    var max_marks = marks['test']['max_marks'];
    var subject = marks['test']['subject'];
    var testTime = marks['test']['totalTime'];
    var timeTaken = marks['timeTaken'];
    int right = marks['rightAnswers'].length;
    int wrong = marks['wrongAnswers'].length;
    int numberSkipped = marks['skippedAnswers'].length;

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.deepOrange),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 125,
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            color: Colors.deepOrange),
                      )
                    ],
                  ),
                  Text('Score: ' +
                      score.toString() +
                      '/' +
                      max_marks.toString()),
                  Text('Time Taken: ' + timeTaken.toString()),
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}

class AboveQuestionWidget extends StatelessWidget {
  const AboveQuestionWidget({
    Key key,
    @required this.test,
    @required this.questionNumber,
    @required this.optionSelected,
  }) : super(key: key);

  final Test test;
  final int questionNumber;
  final OptionSelected optionSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Card(
          elevation: 2,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '+' + test.questions[questionNumber].marks.toString(),
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                TestTimer(test.totalTime, optionSelected),
                Text(
                  '-' + test.questions[questionNumber].negativeMarks.toString(),
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
              ],
            ),
          ),
        ));
  }
}

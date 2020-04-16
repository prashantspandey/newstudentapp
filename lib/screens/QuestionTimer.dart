import 'dart:async';

import 'package:student_app/notifiers/OptionSelected.dart';
import 'package:student_app/pojos/ContentPojo.dart';
import 'package:flutter/material.dart';

class QuestionTimer extends StatefulWidget {
  OptionSelected optionSelected;
  Question question;

  QuestionTimer(this.optionSelected, this.question);

  @override
  State<StatefulWidget> createState() {
    return _QuestionTimer(optionSelected, question);
  }
}

class _QuestionTimer extends State<QuestionTimer> {
  OptionSelected optionSelected;
  Question question;
  _QuestionTimer(this.optionSelected, this.question);
  Stopwatch watch = Stopwatch();
  String minutesShow = '';
  String secondsShow = '';
  Timer timer;
  @override
  void didUpdateWidget(QuestionTimer oldWidget) {
    //startTimer(getQuestionTime(widget.question.id));
    timer.cancel();
    startTimer(getQuestionTime(widget.question.id));
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    //   print('init state '+getQuestionTime(widget.question.id).toString());
    //startTimer(getQuestionTime(widget.question.id));
    startTimer(getQuestionTime(widget.question.id));
    super.initState();
  }

  int getQuestionTime(questionId) {
    var questionTiming =
        widget.optionSelected.getQuestionTime(widget.question.id);
    if (questionTiming != null) {
      return questionTiming;
    } else
      return 0;
  }

  startTimer(newTime) {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      print('timer every second ' + newTime.toString());
      int minutes = newTime ~/ 60;
      int seconds = newTime % 60;
      if (this.mounted) {
        setState(() {
          newTime = newTime + 1;
          minutes = newTime ~/ 60;
          seconds = newTime % 60;
          minutesShow = minutes.toString();
          secondsShow = seconds.toString();
          widget.optionSelected.setQuestionTime(newTime, widget.question.id);
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            minutesShow,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Text(
          ':',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            secondsShow,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

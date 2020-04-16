import 'package:student_app/notifiers/OptionSelected.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TestTimer extends StatefulWidget {
  int time;
  OptionSelected optionSelected;

  TestTimer(this.time, this.optionSelected);

  @override
  State<StatefulWidget> createState() {
    return _TestTimer(time, optionSelected);
  }
}

class _TestTimer extends State<TestTimer> {
  int time;
  OptionSelected optionSelected;
  _TestTimer(this.time, this.optionSelected);
  Stopwatch watch = Stopwatch();
  String minutesShow = '';
  String secondsShow = '';
  @override
  void initState() {
    int new_time = time * 60;
    startTimer(new_time);

    super.initState();
  }

  void startTimer(new_time) {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      int minutes = new_time ~/ 60;
      int seconds = new_time % 60;
      if (this.mounted) {
        setState(() {
          if (new_time < 1) {
            //  t.cancel();
          } else {
            new_time = new_time - 1;
            minutes = new_time ~/ 60;
            seconds = new_time % 60;
          }
          minutesShow = minutes.toString();
          secondsShow = seconds.toString();
          int totalTime = (time * 60) - new_time;
          widget.optionSelected.setTotalTime(totalTime);
        });
      }
    });
  }

  @override
  void dispose() {
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

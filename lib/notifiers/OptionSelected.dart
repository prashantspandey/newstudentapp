import 'package:flutter/material.dart';

class OptionSelected with ChangeNotifier {
  List<List> _options = List();
  List<List> _questionTimer = List();
  int totalTime = 0;

  setTotalTime(int time) {
    totalTime = time;
  }

  int getTotalTime() {
    return totalTime;
  }

  void setOptions(int questionId, int optionId) {
    if (_options != null && _options.length != 0) {
      print('options is not null');
      print('options $_options');
      bool found = false;
      bool rewrite = false;
      int where_index;

      for (var o in _options) {
        if (o[0] == questionId && o[1] == optionId) {
          found = true;
        } else if (o[0] == questionId && o[1] != optionId) {
          rewrite = true;
          where_index = _options.indexOf(o);
        }
      }
      if (found == true) {
        print('duplicate entry');
      } else if (rewrite == true) {
        _options.removeAt(where_index);
        List opt = [questionId, optionId];
        _options.add(opt);
      } else if (found == false && rewrite == false) {
        List opt = [questionId, optionId];
        _options.add(opt);
      }
    } else {
      print('adding first item in options');
      List opt = [questionId, optionId];
      _options.add(opt);
      notifyListeners();
    }
  }

  getOption(int questionId) {
    if (_options != null) {
      for (var o in _options) {
        if (o[0] == questionId) {
          int ind = _options.indexOf(o);
          return _options[ind][1];
        }
      }
    } else {
      print('options in null');
      return 0;
    }
  }

  List getAttempted() {
    List questionIds = List();
    if (_options != null && _options.length != 0) {
      for (var o in _options) {
        questionIds.add(o[0]);
      }
      return questionIds;
    } else {
      return questionIds;
    }
  }

  setQuestionTime(int questionTime, int questionId) {
    if (_questionTimer != null && _questionTimer.length != 0) {
      bool found = false;
      bool rewrite = false;
      int where_index;

      for (var o in _questionTimer) {
        if (o[0] == questionId && o[1] == questionTime) {
          found = true;
        } else if (o[0] == questionId && o[1] != questionTime) {
          rewrite = true;
          where_index = _questionTimer.indexOf(o);
        }
      }
      if (found == true) {
      } else if (rewrite == true) {
        _questionTimer.removeAt(where_index);
        List timerIds = [questionId, questionTime];
        _questionTimer.add(timerIds);
      } else if (found == false && rewrite == false) {
        List timerIds = [questionId, questionTime];
        _questionTimer.add(timerIds);
      }
    } else {
      List timerIds = [questionId, questionTime];
      _questionTimer.add(timerIds);
      notifyListeners();
    }
  }

  getQuestionTime(int questionId) {
    if (_questionTimer != null) {
      for (var o in _questionTimer) {
        if (o[0] == questionId) {
          int ind = _questionTimer.indexOf(o);
          return _questionTimer[ind][1];
        }
      }
    } else {
      return 0;
    }
  }

  List getSubmitAnswers(List allQuestionIds) {
    if (_options != null &&
        _options.length != 0 &&
        _questionTimer != null &&
        _questionTimer.length != 0) {
      for (int qid in allQuestionIds) {
        bool found = false;
        for (var o in _options) {
          if (qid == o[0]) {
            found = true;
            int time = getQuestionTime(qid);
            if (time != 0) {
              o.add(time);
            }
            break;
          }
        }
        if (found == false) {
          List opt = [qid, -1, 0];
          _options.add(opt);
        }
      }
    return _options;
    }
    else if (_options == null || _options.length == 0 ){
        for (int qid in allQuestionIds){
          List opt = [qid,-1,0];
          _options.add(opt);
        }
        return _options;
    }

  }
}

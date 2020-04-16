import 'package:cached_network_image/cached_network_image.dart';
import 'package:student_app/notifiers/OptionSelected.dart';
import 'package:student_app/pojos/ContentPojo.dart';
import 'package:student_app/screens/OptionsWidget.dart';
import 'package:student_app/screens/QuestionTimer.dart';
import 'package:flutter/material.dart';



class TestScreen extends StatefulWidget {
  Question question;
  OptionSelected optionSelected;

  TestScreen(this.question, this.optionSelected);

  @override
  State<StatefulWidget> createState() {
    return _TestScreen(question,optionSelected);
  }
}
class _TestScreen extends State<TestScreen>{
  Question question;
  OptionSelected optionSelected;
  _TestScreen(this.question,this.optionSelected);

getQuestionImage(String url){
  if (url != null){
    return url;
  }
  else{
    return 'https://picsum.photos/id/237/200/300';
  }
}
  @override
  Widget build(BuildContext context) {
    if (widget.question != null) {
      var options = widget.question.options;
      return ListView(
        children: <Widget>[
          Container(
            color: Colors.blueAccent.withOpacity(0.02),
            child: Column(
              children: <Widget>[
                QuestionTimer(widget.optionSelected,widget.question),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  CachedNetworkImage(
        imageUrl: getQuestionImage(widget.question.picture),
        placeholder: (context, url) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            Text('Loading Quetion...')
          ],
        ),
        errorWidget: (context, url, error) => Image.asset('assets/user.png'),
     ), 

                  
                                  ),
                //Divider(height: 5.0, color: Colors.black),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OptionsWidget(options,widget.optionSelected,widget.question),
                )
              ],
            ),
          ),
        ],
      );
    } else {
      return null;
    }
  }
}

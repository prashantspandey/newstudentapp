import 'package:student_app/notifiers/OptionSelected.dart';
import 'package:student_app/pojos/ContentPojo.dart';
import 'package:flutter/material.dart';


class OptionsWidget extends StatefulWidget{
  List<Option>  options;
  OptionSelected optionSelected;
  Question question;
  OptionsWidget(this.options,this.optionSelected,this.question);

  @override
  State<StatefulWidget> createState() {
    return _OptionsWidget(options,optionSelected,question);
  }

}

class _OptionsWidget extends State<OptionsWidget>{
  List<Option> options;
  OptionSelected optionSelected;
  Question question;
  _OptionsWidget(this.options,this.optionSelected,this.question);
  int groupValue;



  @override
  Widget build(BuildContext context) {
    groupValue = widget.optionSelected.getOption(widget.question.id);
    print('options question id '+question.id.toString());
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context,int index){
        return Row(
          children: <Widget>[
            Radio(
              value: widget.options[index].id,
              groupValue: groupValue,
              onChanged: (int e)=> onSelected(e),
              activeColor: Colors.deepOrange,
            ),
            Text(options[index].text,style: TextStyle(fontSize: 15),)
          ],
        );
      },shrinkWrap: true,
    );
  }

  onSelected(int e) {
    setState(() {
      groupValue = e;
      widget.optionSelected.setOptions(widget.question.id, e);
    });

  }
  getSelected(questionId){
    setState(() {
      widget.optionSelected.getOption(widget.question.id);
    });
  }
}
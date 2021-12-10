import 'package:flutter/material.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';

class DialogChanger extends StatefulWidget {
  final String title;
  final String hint;
  final Function() onSubmit;
  var textController = TextEditingController();
  DialogChanger({Key key, this.title, this.onSubmit, this.textController, this.hint}) : super(key: key);
  @override
  _DialogChangerState createState() => _DialogChangerState();
}

class _DialogChangerState extends State<DialogChanger> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
          children:[
           
            titleText(text: widget.title),
           
           
            SizedBox(height:8),
         
            roundedTextBox(textControl: widget.textController, hintText: widget.hint, lines: 4),
            
            SizedBox(height:5),
           
            (widget.onSubmit!=null) ? ModernButton(label: "Cập nhật", onTap: widget.onSubmit) : Container()
          ] 
      ),
    );
  }
}
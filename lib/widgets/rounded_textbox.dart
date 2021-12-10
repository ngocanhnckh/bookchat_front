import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class roundedTextBox extends StatelessWidget {
  var textControl = TextEditingController();
  final String hintText;
  final int lines;

  roundedTextBox({Key key, this.textControl, this.hintText, this.lines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
      (lines == null) ?
      TextField(
        controller: textControl,
          decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white)),
      filled: true,
      hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
      hintText: hintText,
      fillColor: Color(0xFFF9F9F9)),
      ) : 
      TextField(
        keyboardType: TextInputType.multiline,
        maxLines: lines,
        controller: textControl,
          decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white)),
      filled: true,
      hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
      hintText: hintText,
      fillColor: Color(0xFFF9F9F9)),
      ) 
      ,
    );
  }
}
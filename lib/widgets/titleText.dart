import 'package:flutter/material.dart';

class titleText extends StatelessWidget {
  final String text;

  const titleText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(text,
        style: TextStyle(fontWeight: FontWeight.bold,
        fontSize: 20,),),
    );
  }
}
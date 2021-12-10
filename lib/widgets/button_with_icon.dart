import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class ButtonWithIcon extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function() onClick;

  const ButtonWithIcon({Key key, this.icon, this.onClick, this.text}) : super(key: key);
          @override
          Widget build(BuildContext context) {
          // Figma Flutter Generator ButtonWithIcon - GROUP
            return InkWell(
              onTap: onClick,
              child: Container(
      width: 170,
      height: 36,
      
      child: Stack(
        children: <Widget>[
          Positioned(
        top: 0,
        left: 0,
        child: Container(
      width: 170,
      height: 36,
      
      child: Stack(
        children: <Widget>[
          Positioned(
        top: 0,
        left: 0,
        child: Container(
        width: 170,
        height: 36,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
          ),
      boxShadow : [BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.05000000074505806),
          offset: Offset(0,2),
          blurRadius: 10
      )],
      color : Color.fromRGBO(255, 229, 54, 1),
  )
      )
      ),Positioned(
        top: 10,
        left: 13,
        child: Text(text, textAlign: TextAlign.left, style: TextStyle(
        color: Color.fromRGBO(20, 20, 20, 1),
        fontFamily: 'Roboto',
        fontSize: 16,
        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.normal,
        height: 1
      ),)
      ),
        ]
      )
    )
      ),Positioned(
        top: 4,
        left: 138,
        child: icon
      ),
        ]
      )
    ),
            );
    }
  }
        

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter/material.dart';

class ModernButton extends StatelessWidget {
  
  final String label;
  final Function onTap;

  const ModernButton({
    Key key,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          focusColor: Colors.white,
          hoverColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Palette.bcBlack),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 4.0),
                Text(label, style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
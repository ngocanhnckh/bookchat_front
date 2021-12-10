import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final String title;
  final Function() onClick;
  const ExploreCard({Key key, this.title, this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          child:       // Figma Flutter Generator PersonalprofileWidget - GROUP
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 40, 50),
                    child: Text(title, textAlign: TextAlign.left, style: TextStyle(
                      color: Color.fromRGBO(20, 20, 20, 1),
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1
                    ),),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
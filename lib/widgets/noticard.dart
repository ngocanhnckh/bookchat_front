import 'package:flutter_bookchat/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/models/models.dart';

import 'contextMenu.dart';

class NotiCard extends StatelessWidget {
  final Noti noti;

  const NotiCard({Key key, this.noti}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(padding: EdgeInsets.all(5),
      child: Container(
        child: Card(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                SizedBox(width: 10,),
                ProfileAvatar(imageUrl: noti.img),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(noti.content, textAlign: TextAlign.left,)),
              ],),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      ),
    
    );
  }
}

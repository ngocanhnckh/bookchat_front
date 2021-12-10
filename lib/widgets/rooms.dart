import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';

class Rooms extends StatelessWidget {
  final List<BcUserProfile> onlineUsers;

  const Rooms({
    Key key,
    @required this.onlineUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 5.0 : 0.0),
      elevation: isDesktop ? 1.0 : 0.0,
      shape: isDesktop
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
          : null,
      child: 
      Container(
      color: Palette.backColor,
      height: 120.0,  
      child: Align(alignment: Alignment.center,
        child: Container(
            height: 90.0,
            color: Palette.backColor,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 4.0,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: onlineUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final BcUserProfile user = onlineUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProfileAvatar(
                    imageUrl: user.avatar,
                    isActive: true,
                    userName: user.displayName,
                  ),
                );
              },
            ),
          ),
        )
      
      )
    );
  }
}


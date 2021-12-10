import 'package:flutter_bookchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';

class UserCard extends StatelessWidget {
  final BcUser user;
  final BcUserProfile userProfile;

  const UserCard({
    Key key,
    @required this.user, this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (
      ) {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(partner: userProfile,)),
          );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(imageUrl: user.imageUrl),
          const SizedBox(width: 3.0),
          Flexible(
            child: Text(
              user.name,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

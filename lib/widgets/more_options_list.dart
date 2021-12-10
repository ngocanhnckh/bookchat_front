import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MoreOptionsList extends StatelessWidget {
  final List<List> _moreOptionsList = const [
    
    [MdiIcons.accountMultiple, Colors.cyan, 'Bạn bè'],
    [MdiIcons.forumOutline, Palette.bcBlack, 'Tin nhắn'],
    [MdiIcons.bookOutline, Colors.orange, 'Sách'],
    [MdiIcons.storefront, Palette.bcBlack, 'Nhà xuất bản'],
    [MdiIcons.calendarStar, Colors.red, 'Sự kiện'],
  ];

  final BcUser currentUser;
  final BcUserProfile profile;
  const MoreOptionsList({
    Key key,
    @required this.currentUser, this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280.0),
      child: ListView.builder(
        itemCount: 1 + _moreOptionsList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: UserCard(user: currentUser, userProfile:profile),
            );
          }
          final List option = _moreOptionsList[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _Option(
              icon: option[0],
              color: option[1],
              label: option[2],
            ),
          );
        },
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _Option({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        if (label == "Tin nhắn"){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagesScreen()),
          )
        }
        else if (label == "Sách"){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookLibraryScreen()),
          )
        }

      },
      child: Row(
        children: [
          Icon(icon, size: 38.0, color: color),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

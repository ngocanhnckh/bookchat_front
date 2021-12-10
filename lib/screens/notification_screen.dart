import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/widgets/noticard.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/models.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        
        slivers: [
          SliverAppBar(
            pinned: true,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Padding(
                padding: EdgeInsets.all(1),
                child: Text(
                  'Thông báo',
                  style: TextStyle(color: Palette.bcBlack),
                )),
            floating: true,
            actions: [
              CircleButton(
                icon: Icons.search,
                iconSize: 25.0,
                onPressed: () => print('Search'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final Noti noti = notiList[index];
                return NotiCard(noti: noti);
              },
              childCount: notiList.length,
            ),
          ),
        ],
      ),
    );
  }
}

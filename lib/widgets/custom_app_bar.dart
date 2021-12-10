import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/widgets/test_image_picker.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomAppBar extends StatelessWidget {
  final BcUser currentUser;
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomAppBar({
    Key key,
    @required this.currentUser,
    @required this.icons,
    @required this.selectedIndex,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 65.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(alignment: Alignment.centerLeft,
            child: Container(
              width: 150,
              child: Image.asset('assets/images/Logo.png')),)
          ),
          Container(
            height: double.infinity,
            width: 600.0,
            child: CustomTabBar(
              icons: icons,
              selectedIndex: selectedIndex,
              onTap: onTap,
              isBottomIndicator: true,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleButton(
                  icon: SimpleLineIcons.magnifier,
                  iconSize: 30.0,
                  onPressed: () => {
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                      )
                  },
                ),
                CircleButton(
                  icon: SimpleLineIcons.bubble,
                  iconSize: 30.0,
                  onPressed: () {
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessagesScreen()),
                        );
                  },
                ),
                const SizedBox(width: 6.0),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen(isCurrentUser: true,)),
                    );
                  },
                  child: ProfileAvatar(imageUrl: currentUser.imageUrl))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_bookchat/screens/menu_screen.dart';
import 'package:flutter_bookchat/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    ExploreSocialWidget(),
    BookScreen(),
    NotificationScreen(),
    MenuScreen(),
  ];
  final List<IconData> _icons = const [
    MdiIcons.homeOutline,
    MdiIcons.web,
    MdiIcons.textBoxMultipleOutline,
    MdiIcons.bellOutline,
    Icons.menu,
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        appBar: Responsive.isDesktop(context)
            ? PreferredSize(
                preferredSize: Size(screenSize.width, 100.0),
                child: CustomAppBar(
                  currentUser: currentUser,
                  icons: _icons,
                  selectedIndex: _selectedIndex,
                   onTap: (index) => setState(() => _selectedIndex = index),
                ),
              )
            : null,
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: !Responsive.isDesktop(context)
            ? Container(
                padding: const EdgeInsets.only(bottom: 12.0),
                      color: Palette.bookChat,
                child: CustomTabBar(
                  icons: _icons,
                  selectedIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}


import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/screens/event_explore_page.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/widgets/explorecardwidget.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreSocialWidget extends StatefulWidget {
  ExploreSocialWidget({Key key}) : super(key: key);

  @override
  _ExploreSocialWidgetState createState() => _ExploreSocialWidgetState();
}

class _ExploreSocialWidgetState extends State<ExploreSocialWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Padding(
            padding: EdgeInsets.all(1),
            child: Text(
              "Khám phá",
              style: TextStyle(color: Palette.bcBlack),
            )),
        actions: [
          CircleButton(
            icon: SimpleLineIcons.magnifier,
            iconSize: 20.0,
            onPressed: () => print('Search'),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFE5E5E5),
        child: Center(
          child: Container(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                SizedBox(height: 50,),
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Text('Khám phá mạng xã hội \nxung quanh bạn.', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(20, 20, 20, 1),
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                  ),),
                ),
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ExploreCard(title: "Trang \ncá nhân", onClick: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen(isCurrentUser: true,)),
                      );
                    },),
                    ExploreCard(title: "Bạn bè \n",)
                ],),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ExploreCard(title: "Nhóm  \n",),
                    ExploreCard(title: "Sự kiện\n",
                      onClick: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EventExplore()),
                        );
                      }
                    )
                ],)
              ],),
            ),
          ),
        )
      ),
    );
  }
}


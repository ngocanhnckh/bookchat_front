import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/screens/desktopauth.dart';
import 'package:flutter_bookchat/screens/mobileauth.dart';
import 'package:flutter_bookchat/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';

import "package:http/http.dart" as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;

///Login screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ///Text field controller, storing textbox's text state
  
  bool loading;

  ///Indicate password visible or not
  bool _passwordVisible;

  ///Set password to not visible at init state
  ///Checking if current Profile isn't null for mobile version
  void checkLogin() async {
    try {
      if (currentProfile != null && currentProfile.id != null) {
        print("Current profile not null: " + currentProfile.displayName);
        //_onLoading();

        currentUser = BcUser(
            name: currentProfile.displayName,
            imageUrl: currentProfile.avatar ??
                "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NavScreen(),
        ));
      } else {
        print("Current profile is null");
        BcUserProfile cup = await getCUser();
        print("Try to get profile " + cup.toString());
        currentProfile = cup;
        if ((cup != null)) {
          currentUser = BcUser(
              name: cup.displayName,
              imageUrl: cup.avatar ??
                  "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png");

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NavScreen()),
              (Route<dynamic> route) => false,
            );
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
  
        loading = false;

      print("Error in init state of login screen: " + e.toString());
    }
  }

  void initState() {
    super.initState();
    checkLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.bookChat,
        body: 
        Responsive.isDesktop(context) ?
        DesktopAuthScreen():
        MobileAuthScreen()
        )
        ;
  }
}

import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  print("Starting Application");
  try {
    BcUserProfile cup = await getCUser();
    print("Try to get profile " + cup.toString());
    currentProfile = cup;
    if ((cup != null)) {
      currentUser = BcUser(
          name: cup.displayName,
          imageUrl: cup.avatar ??
              "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png");
      runApp(LoggedInApp());
    } else
      runApp(App());
  } catch (e) {
    runApp(App());
  }
}

class LoggedInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Bookchat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Palette.bgGrey,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: NavScreen(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return MaterialApp(
             title: 'Bookchat',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                scaffoldBackgroundColor: Palette.bgGrey,
                textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
              ),
            home: new Center(child: CircularProgressIndicator(),)
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return MaterialApp(
          title: 'Bookchat',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Palette.bgGrey,
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          ),
          home: SplashScreen(
              seconds: 15,
              navigateAfterSeconds: new MyApp(),
              title: new Text(
                'Chào mừng bạn đến với Bookchat',
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              image: new Image.asset('assets/images/Frame.png'),
              backgroundColor: Colors.white,
              styleTextUnderTheLoader: new TextStyle(),
              photoSize: 100.0,
              onClick: () => print("Flutter Egypt"),
              loaderColor: Colors.black),
        );
        // Otherwise, sho
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookchat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Palette.bgGrey,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: LoginScreen(),
    );
  }
}

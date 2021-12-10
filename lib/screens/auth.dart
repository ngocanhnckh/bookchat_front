// Copyright 2013 The Flutter Authors. All rights/ Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert' show json, jsonDecode;
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/widgets/modernButton.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile',
]);

class IphoneAuthGG extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<IphoneAuthGG> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return SignInDemo();
        });
  }
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount _currentUser;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleDataFromRESTAPI(_currentUser);
      } else {}
    });
    _handleSignIn();
  }

  Future<void> _handleDataFromRESTAPI(GoogleSignInAccount user) async {
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final idToken = await firebaseUser.user?.getIdToken();
    final http.Response response = await http.get(
      Uri.parse(
          apiurl + '/auth/firebase?idToken=$idToken'),
    );
    if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('tokenid', jsonDecode(response.body)['token']);
      print("Stored " + prefs.getString('tokenid'));
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NavScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    GoogleSignInAccount user = _currentUser;
    if (user != null) {
      currentUser = BcUser(
          name: _currentUser.displayName, imageUrl: _currentUser.photoUrl);

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      //   (Route<dynamic> route) => false,
      // );
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("Đang đăng nhập..."),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: const Text(
                "Đăng nhập với Google và tận hưởng Bookchat ngay lập tức",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: ModernButton(
                label: 'Đăng nhập',
                onTap: () {
                  _handleSignIn();
                }),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.bookChat,
          title: const Text('Đăng nhập với Google'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}

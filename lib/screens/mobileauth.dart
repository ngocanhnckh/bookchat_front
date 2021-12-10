import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/screens/desktopauth.dart';
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
class MobileAuthScreen extends StatefulWidget {
  @override
  _MobileAuthScreenState createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  ///Text field controller, storing textbox's text state
  final usrController = TextEditingController();
  final passController = TextEditingController();
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
         
            loading = false;
      
        }
      }
    } catch (e) {
     
        loading = false;
     
      print("Error in init state of login screen: " + e.toString());
    }
  }

  void initState() {
    super.initState();
    loading = false;
    _passwordVisible = false;
    checkLogin();
  }

  Future<BcUserProfile> fetchUserProfile(String token) async {
    final http.Response response = await http.get(
      Uri.parse(apiurl + '/users/me'),
      headers: {"Authorization": "Bearer $token"},
    );
    print(response.body);
    if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
    } else {
      print('API ${response.statusCode} response: ${response.body}');
      return BcUserProfile.fromJson(jsonDecode(response.body));
    }
  }

  Future<String> _signIn(String name, String password) async {
    loading = true;
    try {
      print("Signing in");
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: name, password: password)
          .then((authResult) async {
        if (authResult.user != null) {
          final _user = authResult.user;

          final idToken = await _user.getIdToken();
          print("current token: " + idToken);
          final http.Response response = await http.get(
            Uri.parse(
                apiurl + '/auth/firebase?idToken=$idToken'),
          );
          if (response.statusCode != 200) {
            print('API ${response.statusCode} response: ${response.body}');
        
              loading = false;
     
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng kiểm tra lại')));
            return "no";
          } else {
            print('API ${response.statusCode} response: ${response.body}');
            BcUserProfile bcu =
                await fetchUserProfile(jsonDecode(response.body)['token']);
            print("Got BC User Profile: " + bcu.displayName);
            currentUser = BcUser(
                name: bcu.displayName,
                imageUrl: bcu.avatar ??
                    "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'tokenid', jsonDecode(response.body)['token']);
            print("Stored " + prefs.getString('tokenid'));
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => NavScreen(),
            ));
            return ("ok");
          }
          //callback(RequestUserSignInResult.Success);

        } else {
          //  setState(() {
          //     loading = false;
          //   });

          return ("wait");
          //callback(RequestUserSignInResult.Fail);
        }
      }).onError((e, stackTrace) {

          loading = false;
 
        print(e.toString());
        if (e.code == 'user-not-found') {
  
          loading = false;
    
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Người dùng không tồn tại')));
      } else if (e.code == 'wrong-password') {
 
          loading = false;

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Mật khẩu sai')));
      } else {
        
          loading = false;
   
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng kiểm tra lại')));
      }
       
        return e.toString();
      });
    }  catch (e) {
      print(e);
  
        loading = false;
     
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vui lòng kiểm tra lại')));
      return ("no");
    }
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    usrController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.bookChat,
        body: Container(
          child: Center(
              child: loading
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/images/Frame.png')),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: usrController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Palette.bookChat),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Palette.bookChat)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Color(0xFFBDBDBD))),
                                filled: true,
                                hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                                hintText: "Email",
                                fillColor: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            obscureText: !_passwordVisible,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: passController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.white)),
                              filled: true,
                              hintStyle: TextStyle(
                                color: Color(0xFFBDBDBD),
                              ),
                              hintText: "Passsword",
                              fillColor: Color(0xFFF9F9F9),
                              prefixIcon: SizedBox(width: 70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Quên mật khẩu?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Login Text Clicked');
                                  }),
                          ]),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: 300,
                          height: 45,
                          child: ElevatedButton(
                            child: Text('Đăng nhập',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: () async {
                              await _signIn(
                                  usrController.text, passController.text);
                              
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Hoặc đăng nhập bằng: ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        IconButton(
                          icon: Icon(FontAwesome.google),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IphoneAuthGG()),
                            );
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Chưa có tài khoản? Đăng ký ngay',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()),
                                    );
                                  }),
                          ]),
                        ),
                      ],
                    )),
        )
        )
        ;
  }
}

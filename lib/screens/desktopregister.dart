import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';

import "package:http/http.dart" as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class DesktopRegisterScreen extends StatefulWidget {
  @override
  _DesktopRegisterScreenState createState() => _DesktopRegisterScreenState();
}

class _DesktopRegisterScreenState extends State<DesktopRegisterScreen> {
  final usrController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  String gender = "Nam";
  String role = "Chọn vai trò";
  bool _passwordVisible;
  
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1910, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void initState() {
    _passwordVisible = false;
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

  Future<int> registerUser(BcUserProfile usr, String token) async{
    print("Insert user info...");
    int res = 1;
    try{
      http
        .put(
      Uri.parse(apiurl + '/users/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(<String, String>{
        'displayName': usr.displayName,
        'gender': usr.gender,
        'bio': usr.bio,
        'dateOfBirth': usr.dateOfBirth,
      }),
    )
        .then((res) async {
      print("got inserted: ");
      print(res.body);
      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('tokenid', token);
        print("Stored " + prefs.getString('tokenid'));
        currentUser = BcUser(
            name: usr.displayName,
            imageUrl:
                "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png");
        getCUser();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NavScreen(),
        ));
        
      }
      
    }).catchError((e) {
      print(e.toString());
      res = 0;
    });
    return res;
    }
    catch (e){
      return 0;
    }
  }

  Function errorSnack() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Đã có lỗi xảy ra, vui lòng kiểm tra lại')));
    return null;
  }

  Future<String> _signUp(String name, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: name, password: password);
      
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
              errorSnack();
            } else {
              print('API ${response.statusCode} response: ${response.body}');
              BcUserProfile bcu =
                  await fetchUserProfile(jsonDecode(response.body)['token']);
              print("Got BC User Profile: " + bcu.displayName);

              String genderE = "male";
              if (gender != "Nam") genderE = "female";

              bcu = BcUserProfile(
                  displayName: nameController.text,
                  gender: genderE,
                  bio: bioController.text,
                  dateOfBirth: "${selectedDate.toLocal()}".split(' ')[0]);
              String checkValue ="ok";
              
                  await registerUser(bcu, jsonDecode(response.body)['token']).then((value){
                      if (value==0) {
                        print("register returned null");
                        errorSnack();
                        checkValue = "no";
                        
                      } else {
                        print("register returned ok");
                        
                      }
                  });
              return checkValue;
            }
            //callback(RequestUserSignInResult.Success);
            return ("wait");
          } else {
            return ("wait");
            //callback(RequestUserSignInResult.Fail);
          }
        }).onError((e, stackTrace) {
            if (e.code == 'weak-password') {
        print('no');
        } else if (e.code == 'email-already-in-use') {
        print('no');
        }
        errorSnack();
        return ("no");
    });
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
              child: SingleChildScrollView(
                child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: titleText(text: "Đăng ký sử dụng mạng xã hội Bookchat"),),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: TextField(
                textAlign: TextAlign.center,
                controller: usrController,
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
                    hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                    hintText: "Email",
                    fillColor: Color(0xFFF9F9F9)),
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
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: DropdownButtonFormField(
                value: gender,
                dropdownColor: Color(0xFFF9F9F9),
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Color(0xFFBDBDBD)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (String newValue) {
                  setState(() {
                    gender = newValue;
                  });
                },
                items: <String>['Nam', 'Nữ']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  );
                }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: DropdownButtonFormField(
                value: role,
                dropdownColor: Color(0xFFF9F9F9),
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Color(0xFFBDBDBD)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (String roles) {
                  setState(() {
                    role = roles;
                  });
                },
                items: <String>['Chọn vai trò', 'Tác giả', 'Dịch giả', 'Độc giả', 'Nhà giáo']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  );
                }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: Row(
                children: [
                  Text("Ngày sinh: " + "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: Text('Chọn ngày'),
                      ),
                    ),
                  ),
                ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: TextField(
                textAlign: TextAlign.center,
                controller: nameController,
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
                    hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                    hintText: "Họ và tên",
                    fillColor: Color(0xFFF9F9F9)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: TextField(
                textAlign: TextAlign.center,
                controller: bioController,
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
                    hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                    hintText: "Mô tả về bạn",
                    fillColor: Color(0xFFF9F9F9)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
                TextSpan(
                    text:
                        'Khi đăng ký bạn đồng ý với điều khoản và chính sách của Bookchat',
                    
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
            height: 30,
          ),
          SizedBox(
            width: 300,
            height: 45,
            child: ElevatedButton(
                child: Text('Đăng ký',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () async {
                  String ok =
                      await _signUp(usrController.text, passController.text);
                  print(ok);
                  if (ok == "no") {}
                },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          
          
          // SizedBox(
          //   height: 20,
          // ),
        ],
      ),
              ))),
    );
  }
}
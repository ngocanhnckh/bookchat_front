import 'dart:convert';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import "package:http/http.dart" as http;

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
//Get the messages
  
  List<BcUserProfile> users = [];
  Future<void> getUser() async{
    final http.Response response = await http.get(
      Uri.parse(apiurl + '/users?limit=100&active=true'),
      headers: await getHeader(),
    );
    print(response.body);
    if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
    } else {
      print('API ${response.statusCode} response: ${response.body}');
      var postJson = jsonDecode(response.body)['data'] as List;
      postJson.forEach((element) {
        BcUserProfile e = BcUserProfile.fromJson(element);
        print(e.displayName);
        e.avatar = e.avatar ?? "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png";
        print(e.avatar);
        setState(() {
          users.add(e);
        });
      });
      
    }
  }
   
  void initState(){
    super.initState();
    getUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: CircleButton(
                icon: SimpleLineIcons.arrow_left,
                  iconSize: 20.0,
                  onPressed: () => Navigator.pop(context),
              ),
              pinned: true,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Padding(
                  padding: EdgeInsets.all(1),
                  child: Text(
                    'Tin nhắn',
                    style: TextStyle(color: Palette.bcBlack),
                  )),
              floating: true,
              actions: [
                CircleButton(
                  icon: SimpleLineIcons.magnifier,
                  iconSize: 20.0,
                  onPressed: () => {
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessagesScreen()),
                      )
                  },
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
                 final BcUserProfile user = users[index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5,0,5,0),
                        child: UserCard(user: BcUser(name: user.displayName,imageUrl: user.avatar), userProfile: user,),
                      ),
                    );
                },
                childCount: users.length,
              ),
            ),

           
          ],
        ),
      ),
    );
  }
}

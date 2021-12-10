///Demo data & Environment
import 'dart:convert';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

///Environment data
var apiurl = "https://api.bookchat.vn";


Future<Map<String, String>> getHeader() async {
  final String token = await getCToken();
  return {"Authorization": "Bearer $token"};
}
///Get current user token
Future<String> getCToken() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Token " + prefs.getString('tokenid'));
    return prefs.getString('tokenid');
  } catch (e) {
    print(e);
    return null;
  }
}

///Get current user profile
Future<BcUserProfile> getCUser() async {
  try{
    print("Getting token");
    final String token = await getCToken();
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
      currentProfile = BcUserProfile.fromJson(jsonDecode(response.body));
      return BcUserProfile.fromJson(jsonDecode(response.body));
    }
  }
  catch(e){
    return null;
  }
}

///Set global variable currentUser
BcUser currentUser = BcUser(
  name: '',
  imageUrl: '',
);

///Set global variable currentProfile
BcUserProfile currentProfile = null;

///Online user demo data
final List<BcUser> onlineUsers = [
  BcUser(
    name: 'David Brooks',
    imageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  BcUser(
    name: 'Jane Doe',
    imageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  BcUser(
    name: 'Matthew Hinkle',
    imageUrl:
        'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1331&q=80',
  ),
  BcUser(
    name: 'Amy Smith',
    imageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=700&q=80',
  ),
  BcUser(
    name: 'Ed Morris',
    imageUrl:
        'https://images.unsplash.com/photo-1521119989659-a83eee488004?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=664&q=80',
  ),
  BcUser(
    name: 'Carolyn Duncan',
    imageUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  BcUser(
    name: 'Paul Pinnock',
    imageUrl:
        'https://images.unsplash.com/photo-1519631128182-433895475ffe?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  BcUser(
      name: 'Elizabeth Wong',
      imageUrl:
          'https://images.unsplash.com/photo-1515077678510-ce3bdf418862?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjF9&auto=format&fit=crop&w=675&q=80'),
  BcUser(
    name: 'James Lathrop',
    imageUrl:
        'https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=592&q=80',
  ),
  BcUser(
    name: 'Jessie Samson',
    imageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  BcUser(
    name: 'David Brooks',
    imageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  BcUser(
    name: 'Jane Doe',
    imageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  BcUser(
    name: 'Matthew Hinkle',
    imageUrl:
        'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1331&q=80',
  ),
  BcUser(
    name: 'Amy Smith',
    imageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=700&q=80',
  ),
  BcUser(
    name: 'Ed Morris',
    imageUrl:
        'https://images.unsplash.com/photo-1521119989659-a83eee488004?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=664&q=80',
  ),
  BcUser(
    name: 'Carolyn Duncan',
    imageUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
  BcUser(
    name: 'Paul Pinnock',
    imageUrl:
        'https://images.unsplash.com/photo-1519631128182-433895475ffe?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  ),
  BcUser(
      name: 'Elizabeth Wong',
      imageUrl:
          'https://images.unsplash.com/photo-1515077678510-ce3bdf418862?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjF9&auto=format&fit=crop&w=675&q=80'),
  BcUser(
    name: 'James Lathrop',
    imageUrl:
        'https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=592&q=80',
  ),
  BcUser(
    name: 'Jessie Samson',
    imageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  ),
];

final List<Story> stories = [
  Story(
    user: onlineUsers[2],
    imageUrl:
        'https://images.unsplash.com/photo-1498307833015-e7b400441eb8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80',
  ),
  Story(
    user: onlineUsers[6],
    imageUrl:
        'https://images.unsplash.com/photo-1499363536502-87642509e31b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
    isViewed: true,
  ),
  Story(
    user: onlineUsers[3],
    imageUrl:
        'https://images.unsplash.com/photo-1497262693247-aa258f96c4f5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=624&q=80',
  ),
  Story(
    user: onlineUsers[9],
    imageUrl:
        'https://images.unsplash.com/photo-1496950866446-3253e1470e8e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
    isViewed: true,
  ),
  Story(
    user: onlineUsers[7],
    imageUrl:
        'https://images.unsplash.com/photo-1475688621402-4257c812d6db?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80',
  ),
  Story(
    user: onlineUsers[2],
    imageUrl:
        'https://images.unsplash.com/photo-1498307833015-e7b400441eb8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80',
  ),
  Story(
    user: onlineUsers[6],
    imageUrl:
        'https://images.unsplash.com/photo-1499363536502-87642509e31b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
    isViewed: true,
  ),
  Story(
    user: onlineUsers[3],
    imageUrl:
        'https://images.unsplash.com/photo-1497262693247-aa258f96c4f5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=624&q=80',
  ),
  Story(
    user: onlineUsers[9],
    imageUrl:
        'https://images.unsplash.com/photo-1496950866446-3253e1470e8e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
    isViewed: true,
  ),
  Story(
    user: onlineUsers[7],
    imageUrl:
        'https://images.unsplash.com/photo-1475688621402-4257c812d6db?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80',
  ),
];

final List<AdsBanner> ads = [
  AdsBanner(
    name: 'Nhã Nam',
    text: '',
    bannerURL: 'http://i.imgur.com/kWY7I31.jpg',
    adsURL: 'http://nhanam.com.vn',
    id: 1,
  ),
  AdsBanner(
      name: 'Phương Nam',
      text: 'Nhà sách phương Nam',
      bannerURL:
          'https://vcdn-kinhdoanh.vnecdn.net/2021/05/04/119729418-108855484299775-2424-2059-1220-1620144743.jpg',
      adsURL: 'https://nhasachphuongnam.com/vi/',
      id: 2),
];

List<Noti> notiList = [
  Noti(
      img:
          'https://scontent.fhan5-7.fna.fbcdn.net/v/t1.6435-1/s200x200/118580675_4635243053389352_4860773742700115081_n.jpg?_nc_cat=103&ccb=1-5&_nc_sid=7206a8&_nc_ohc=QTGfKkkE_x4AX_3yO7W&_nc_ht=scontent.fhan5-7.fna&oh=f529372397982832cbfea6a54690b9ea&oe=616460C0',
      content: 'Hệ thống thông báo sẽ được cập nhật khi có thêm người dùng, bạn vui lòng thử lại sau nhé!',
      time: '1',
      id: 1),
  
];

List<Post> posts = [
];

List<MessageBox> msgBoxes = [
  MessageBox(lastestMessage: "Hello ", user: onlineUsers[0]),
  MessageBox(
      lastestMessage:
          "Bạn đã đọc quyển Cha giàu cha nghèo chưa? Bạn đã đọc quyển Cha giàu cha nghèo chưa?Bạn đã đọc quyển Cha giàu cha nghèo chưa?Bạn đã đọc quyển Cha giàu cha nghèo chưa?",
      user: onlineUsers[1]),
  MessageBox(
      lastestMessage: "Bạn đã đọc quyển Cha giàu cha nghèo chưa?",
      user: onlineUsers[2]),
  MessageBox(
      lastestMessage: "Huấn hoa hồng mới ra sách kinh doanh đấy",
      user: onlineUsers[3]),
  MessageBox(lastestMessage: "Haha", user: onlineUsers[4]),
  MessageBox(lastestMessage: "Ảo thật đấy", user: onlineUsers[5]),
  MessageBox(lastestMessage: "Bạn là nhất", user: onlineUsers[6]),
];

List<BCComment> democmts = [
];

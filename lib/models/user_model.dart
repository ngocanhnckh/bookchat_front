import 'package:flutter_bookchat/data/data.dart';
import 'package:meta/meta.dart';

class BcUser {
  String name;
  String imageUrl;

  BcUser({
    @required this.name,
    @required this.imageUrl,
  });
  
}

String getImage(String url){
  if(url==null){
    return "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png";
  }
  else{
    if (!url.contains("http")){
      return apiurl + url;
    }
    else {
      return url;
    }
  }
}

class BcUserProfile {
  String id;
  String displayName;
  String gender;
  String avatar;
  String bio;
  String dateOfBirth;
  String createdAt;
  bool active;
  BcUserProfile(
      {this.displayName,
      this.gender,
      this.avatar,
      this.bio,
      this.dateOfBirth,
      this.createdAt, this.active});
  BcUserProfile.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        gender = json['gender'],
        avatar = getImage(json['avatar']),
        bio = json['bio'],
        dateOfBirth = json['dateOfBirth'],
        createdAt = json['createdAt'],
        id = json['_id'],
        active = json['active']
        ;
  BcUserProfile.fromAuthor(Map<String, dynamic> json)
      : displayName = json['displayName'],
        gender = json['gender'],
        id = json['_id'],
        active = json['active']
        ;
}

class CommentModel {
  final BcUser user;
  final String comment;
  final DateTime time;

  const CommentModel({
    @required this.user,
    @required this.comment,
    @required this.time,
  });
}

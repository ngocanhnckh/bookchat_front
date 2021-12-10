import 'package:flutter_bookchat/models/user_model.dart';

class eventData {
  String id;
  String name;
  BcUserProfile host;
  String content;
  List<dynamic> attachments;
  String date;
  String createdAt;
  String updatedAt;
  String location;
  eventData(id,name,host,content,attachments,date,createdAt,updatedAt,location);
  eventData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        host = BcUserProfile.fromJson(json['host']),
        content = json['content'],
        attachments = json['attachments'],
        date = json['date'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt']
        //location = json['location']
        ;
}
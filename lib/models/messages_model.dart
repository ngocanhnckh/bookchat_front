import 'package:flutter/material.dart';

import 'models.dart';

class MessageBox {
  final BcUser user;
  final String lastestMessage;
  MessageBox({this.user, this.lastestMessage});
}

class ChatMsg {
  final BcUser user;
  final String msg;
  final String time;

  ChatMsg({this.user, this.msg, this.time});
}

class msgData {
  bool revoked;
  List<dynamic> attachments;
  String content;
  String recipient;
  String sender;
  String createdAt;
  String id;
  msgData(revoked, attachments,content,recipient,sender,createdAt,id);
  msgData.fromJson(Map<String, dynamic> json)
      : revoked = json['revoked'],
      content = json['content'],
      attachments = json['attachments'],
      sender = json['sender'],
      createdAt = json['createdAt'],
      id = json['_id']
        ;
}


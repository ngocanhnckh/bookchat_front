import 'package:flutter/material.dart';

import 'models.dart';

class BCComment {
  final BcUser user;
  final String cmt;
  final String time;

  BCComment({this.user, this.cmt, this.time});
  factory BCComment.fromJson(dynamic json) {
    BcUserProfile bcu = BcUserProfile.fromJson(json['user']);
    BcUser usr = BcUser(name: bcu.displayName, imageUrl: bcu.avatar);
    return BCComment(cmt: json['content'], user: usr);
  }
}

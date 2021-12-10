import 'package:meta/meta.dart';
import 'package:flutter_bookchat/models/models.dart';

class Post {
  final BcUserProfile user;
  final String userID;
  final String caption;
  final String timeAgo;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final String id;
  final List<dynamic> attachments;
  final PostDetails details;
  const Post({
    @required this.user,
    @required this.userID,
    @required this.caption,
    @required this.timeAgo,
    @required this.imageUrl,
    @required this.likes,
    @required this.comments,
    @required this.shares,
    this.id,
    this.attachments,
    this.details
  });
}

class PostDetails {
  String id;
  String createdAt;
  String recent;
  BcUserProfile author;
  String content;
  List<dynamic> attachments;
  bool hasLiked;
  int commentCount;
  int likeCount;
  PostDetails(this.id, this.createdAt, this.author, this.content,
      this.attachments, this.hasLiked, this.recent,this.commentCount,this.likeCount);
  factory PostDetails.fromJson(dynamic json) {
    print("converting date time");
    var date = DateTime.parse(json['createdAt']);
    var now = DateTime.now();
    var diff = now.difference(date).inMinutes;
    var rec = "";
    if (diff > 1440) {
      diff = now.difference(date).inDays;
      rec = diff.toString() + " ngày";
    } else if (diff > 59) {
      diff = now.difference(date).inHours;
      rec = diff.toString() + " giờ";
    } else {
      rec = diff.toString() + " phút";
    }

    return PostDetails(
        json['_id'] as String,
        json['createdAt'] as String,
        BcUserProfile.fromJson(json['author']),
        json['content'] as String,
        json['attachments'] as List<dynamic>,
        json['hasLiked'] as bool,
        rec,
        json['commentCount'] as int,
        json['likeCount'] as int
        );
  }
}

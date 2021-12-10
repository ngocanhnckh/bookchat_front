
import 'package:flutter_bookchat/models/user_model.dart';

class bookData {
  BcUserProfile translator;
  BcUserProfile author;
  int price;
  String sender;
  String thumbnail;
  List<dynamic> genres;
  String publishDate;
  String publisher;
  String description;
  String name;
  String id;
  bookData(translator,author,price,sender,thumbnail,genres,publishDate,publisher,description,name,id);
  bookData.fromJson(Map<String, dynamic> json)
      : 
      translator = (json['translator']==null) ? null : BcUserProfile.fromAuthor(json['translator']),
      author = (json['author']==null) ? null : BcUserProfile.fromAuthor(json['author']),
      price = json['price'],
      sender = json['sender'],
      thumbnail = json['thumbnail'],
      genres = json['genres'],
      publishDate = json['publishDate'],
      publisher = json['publisher'],
      description = json['description'],
      name = json['name'],
      id = json['_id']
      ;
}
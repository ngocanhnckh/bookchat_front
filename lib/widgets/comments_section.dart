import 'dart:convert';
import 'dart:io';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class CommentBox extends StatefulWidget {
  final Function() notifyParent;
  final String postID;
  const CommentBox({Key key, this.postID, this.notifyParent}) : super(key: key);
  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  List<BCComment> comments = [];
  Future<void> updateComments() {
    String pid = widget.postID;
    print(apiurl + '/posts/$pid/comments?limit=100');
    http
        .get(Uri.parse(
            apiurl + '/posts/$pid/comments?limit=100'))
        .then((value) {
      print(value.body);
      var postJson = jsonDecode(value.body)['data'] as List;
      print("got postJson");
      List<BCComment> pds =
          postJson.map((js) => BCComment.fromJson(js)).toList();
      print("mapped pds");
      setState(() {
        comments = pds;
      });
      widget.notifyParent();
    }).onError((error, stackTrace) {
      print("cant get comments");
      print(error.toString());
    });
  }

  final cmtControl = TextEditingController();
  final _scrollcontroller = ScrollController();

  Future<void> submitComment(String cmt) async {
    String token = await getCToken();
    String pid = widget.postID;
    http.post(
      Uri.parse(apiurl + '/posts/$pid/comments'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        'content':cmt,
      })
    ).then((value) {
      print(value.body);
      setState(() {
      comments.insert(0, BCComment(user: currentUser, cmt: cmt));
    });
      updateComments();

    }).onError((error, stackTrace) {
      print(error.toString());
    });
    
    // _scrollcontroller.animateTo(
    //   0.0,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 300),
    // );
  }

  void initState() {
    super.initState();
    updateComments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                controller: _scrollcontroller,
                reverse: true,
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 10),
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: ProfileAvatar(imageUrl: comments[index].user.imageUrl)),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comments[index].user.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(comments[index].cmt)
                            ],
                          ),
                        ],
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: cmtControl,
                        onFieldSubmitted: (String value) async {
                          submitComment(value);
                          cmtControl.text = "";
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    BorderSide(color: Color(0xFFBDBDBD))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    BorderSide(color: Color(0xFFBDBDBD))),
                            filled: true,
                            hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                            hintText: "Bình luận",
                            fillColor: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        submitComment(cmtControl.text);
                        cmtControl.text = "";
                      },
                      icon: Icon(FontAwesome.send)),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

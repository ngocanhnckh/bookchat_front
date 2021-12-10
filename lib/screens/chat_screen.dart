import 'dart:async';
import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import "package:http/http.dart" as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_bookchat/utils/socket.dart';

List<ChatMessage> messages = [];
Timer timer;

class ChatScreen extends StatefulWidget {
  final BcUserProfile partner;
  ChatScreen({Key key, this.partner}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var sContr = ScrollController();

  ChatUser chatUser = ChatUser(
      name: currentUser.name,
      avatar: currentUser.imageUrl,
      uid: currentProfile.id);

  Future<void> getMessages() async {
    List<ChatMessage> messagesu = [];
    String recid = widget.partner.id;
    print(apiurl + '/messages?recipientID=$recid&limit=100');
    final http.Response response = await http.get(
      Uri.parse(apiurl + '/messages?recipientID=$recid&limit=100'),
      headers: await getHeader(),
    );
    //print(response.body);
    if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
    } else {
      print('API ${response.statusCode} response: ${response.body}');
      var getJS = jsonDecode(response.body)['data'] as List;
      getJS.forEach((element) {
        msgData msg = msgData.fromJson(element);
        print(msg.sender + ":" + msg.content);
        if (msg.sender == chatUser.uid)
          messagesu.add(ChatMessage(
              text: msg.content,
              user: chatUser,
              createdAt: DateTime.parse(msg.createdAt)));
        else
          messagesu.add(ChatMessage(
              text: msg.content,
              user: ChatUser(name: widget.partner.displayName),
              createdAt: DateTime.parse(msg.createdAt)));
      });
      if (messagesu.length != messages.length) {
        setState(() {
          messages = messagesu;
        });
        for(int i = 0; i<=15; i++){
          if (sContr != null) {
          var scrollPosition = sContr.position;
          if (scrollPosition.maxScrollExtent > scrollPosition.minScrollExtent)
            sContr.animateTo(
              scrollPosition.maxScrollExtent,
              duration: new Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
        }
        }
        
      }
      
    }
  }

  void updateParent() {
    getMessages();
  }

  void initState() {
    super.initState();

    getMessages();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getMessages());
    messages = [
      ChatMessage(
          text: "Đây là một tin nhắn demo",
          user: ChatUser(name: widget.partner.displayName)),
    ];
    eventSocket eS = new eventSocket(notifyParent: updateParent);
    print("Call listener");
    eS.Listen();
  }

  Future<void> postMessage(String message) async {
    final http.Response response = await http.post(
        Uri.parse(apiurl + '/messages'),
        headers: await getHeader(),
        body: {"recipientID": widget.partner.id, "content": message});
    print(response.body);
    if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
    } else {
      print('API ${response.statusCode} response: ${response.body}');
      var res = response.body;
    }
  }

  void onSend(ChatMessage message) {
    messages.add(message);
    postMessage(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CircleButton(
          icon: SimpleLineIcons.arrow_left,
          iconSize: 20.0,
          onPressed: () {
            timer.cancel();
            Navigator.pop(context);
          },
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Padding(
            padding: EdgeInsets.all(1),
            child: Text(
              widget.partner.displayName,
              style: TextStyle(color: Palette.bcBlack),
            )),
        actions: [
          CircleButton(
            icon: SimpleLineIcons.magnifier,
            iconSize: 20.0,
            onPressed: () => print('Search'),
          ),
        ],
      ),
      body: DashChat(
        messagePadding: EdgeInsets.all(12),
        scrollController: sContr,
        messages: messages,
        user: chatUser,
        showAvatarForEveryMessage: false,
        showUserAvatar: false,
        sendOnEnter: true,
        onSend: onSend,
        inputDecoration:
            InputDecoration.collapsed(hintText: "Soạn tin nhắn..."),
        messageDecorationBuilder: (ChatMessage msg, bool isUser) {
          return BoxDecoration(
              color: isUser ? Palette.bcBlack : Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(20)
              // example

              );
        },
      ),
    );
  }
}

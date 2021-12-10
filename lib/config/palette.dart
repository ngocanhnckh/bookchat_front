import 'package:flutter/material.dart';

class Palette {
  static const Color scaffold = Colors.white;
  static const Color bookChat = Color(0xFFFFE536);
  static const Color bcBlack = Color(0xFF202020);
  static const Color iconColor = Color(0xFF141414);
  static const Color backColor = Color(0xFFF9F9F9);
  static const Color bcBlue = Color(0xFF5BCDF6);
  static const Color bgGrey = Color(0xFFE5E5E5);
  static const Color bookChatBlack = Color(0xFF141414);
  static const LinearGradient createRoomGradient = LinearGradient(
    colors: [Color(0xFF496AE1), Color(0xFFCE48B1)],
  );

  static const Color online = Color(0xFF5BCDF6);

  static const LinearGradient storyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );
}

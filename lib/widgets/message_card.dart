// import 'package:flutter_bookchat/data/data.dart';
// import 'package:flutter_bookchat/models/models.dart';
// import 'package:flutter_bookchat/screens/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bookchat/models/models.dart';
// import 'package:flutter_bookchat/widgets/widgets.dart';

// class MessageCard extends StatefulWidget {
//   final MessageBox msgBox;

//   const MessageCard({Key key, this.msgBox}) : super(key: key);
//   @override
//   _MessageCardState createState() => _MessageCardState();
// }

// class _MessageCardState extends State<MessageCard> {
//   @override
//   void onClick(BcUseruser) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ChatScreen(partner: user)),
//     );
//   }

//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//                           print("hello");
//                           onClick(widget.msgBox.user);
//                         },
//       child: Padding(
//         padding: EdgeInsets.all(5),
//         child: Container(
//           child: Card(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       width: 10,
//                     ),
//                     ProfileAvatar(imageUrl: widget.msgBox.user.imageUrl),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(widget.msgBox.user.name + ": ",
//                         textAlign: TextAlign.left,
//                         overflow: TextOverflow.ellipsis,
//                         style: new TextStyle(fontWeight: FontWeight.bold)),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           print("hello");
//                           onClick(widget.msgBox.user);
//                         },
//                         child: Container(
//                           child: Text(widget.msgBox.lastestMessage,
//                               textAlign: TextAlign.left,
//                               overflow: TextOverflow.ellipsis,
//                               style: new TextStyle()),
//                         ),
//                       ),
//                     ),
//                     PopupMenuButton(
//                         onSelected: (selectedValue) {
//                           print(selectedValue);
//                         },
//                         itemBuilder: (BuildContext ctx) => [
//                               PopupMenuItem(child: Text('Lưu trữ'), value: '1'),
//                               PopupMenuItem(
//                                   child: Text('Đánh dấu là chưa đọc'),
//                                   value: '2'),
//                             ])
//                     // Expanded(
//                     //     child: Align(
//                     //         alignment: Alignment.bottomRight,
//                     //         child: ContextMenu()))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

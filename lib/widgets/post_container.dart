import 'dart:convert';

import 'package:flutter_bookchat/data/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'comments_section.dart';

class PostContainer extends StatefulWidget {
  final Post post;
  final Function() notifyParent;
  final String id;
  const PostContainer({
    Key key,
    @required this.post,
    this.id, this.notifyParent, 
  }) : super(key: key);

  @override
  _PostContainerState createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  int imgMode = 0;
  List<dynamic> images = [];
  void initState(){
    super.initState();
    if (widget.post.attachments == null || widget.post.attachments.length==0){
      print("no attach");
    }
    else if (widget.post.attachments.length == 1){
      print("1 attach " + apiurl + widget.post.attachments[0]);
      imgMode = 1;
      setState(() {
        images=widget.post.attachments;
      });
    }
    else{
      print("more attach");
      imgMode = 2;
    }
  }
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: isDesktop ? 5.0 : 10.0,
      ),
      elevation: isDesktop ? 1.0 : 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: (BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        )),
        padding: const EdgeInsets.symmetric(vertical: 22.0),
        child: Column(
          
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(post: widget.post,notifyParent: widget.notifyParent,),
                  const SizedBox(height: 4.0),
                  SizedBox(height: 10),
                  SelectableText(widget.post.caption),
                  imgMode != 1
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 6.0),
                ],
              ),
            ),
            imgMode == 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CachedNetworkImage(imageUrl: apiurl + widget.post.attachments[0].toString()),
                  )
                : const SizedBox.shrink(),
           
            imgMode == 2
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GridView.builder(
                    //scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              crossAxisCount: 3,
                            ),
                            itemCount: widget.post.attachments.length,
                            itemBuilder: (context, index) {
                              // Item rendering
                              return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(apiurl+widget.post.attachments[index].toString()),
                                    ),
                                  ),
                                );
                            },
                          ),
                  )
                : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: _PostStats(
                    post: widget.post,
                    id: widget.id,
                    notifyParent: widget.notifyParent,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;
  final Function() notifyParent;
  const _PostHeader({
    Key key,
    @required this.post, this.notifyParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(imageUrl: post.user.avatar),
        const SizedBox(width: 15.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.user.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${post.timeAgo} • ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        (post.user.id != currentProfile.id) ?
        
        ContextMenu(
          text: ["Báo cáo bài viết"],
          onclick: [
            (){ 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã báo cáo bài viết')));
             },
          ]
        ) : ContextMenu(
          text: ["Xóa bài viết"],
          onclick: [
            () async { 
              var id = post.id;
              await deleteAPI("/posts/$id", null, null);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa bài viết')));
                notifyParent();
             },
          ]
        ) 
      ],
    );
  }
}

class _PostStats extends StatelessWidget {
  final Post post;
  final String id;
  final Function() notifyParent;
  const _PostStats({
    Key key,
    @required this.post,this.id, this.notifyParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                // decoration: BoxDecoration(
                //   color: Palette.bcBlack,
                //   shape: BoxShape.circle,
                // ),
                child: const Icon(
                  LineIcons.heart,
                  size: 18.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  '${post.likes}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Text(
                '${post.comments}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              const Icon(
                LineIcons.commentDotsAlt,
                size: 18.0,
                color: Colors.black,
              ),
              // const SizedBox(width: 8.0),
              // Text(
              //   '${post.shares} chia sẻ',
              //   style: TextStyle(
              //     color: Colors.grey[600],
              //   ),
              // )
            ],
          ),
        ),
        //const Divider(),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            _PostButton(
              icon: Icon(
                MdiIcons.thumbUpOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Thích',
              onTap: () async {
                await http.put(
                  Uri.parse(apiurl + '/posts/$id/likes'),
                  headers: await getHeader()
                ).then((value){
                  print(value.body);
                  notifyParent();
                });
              },
            ),
            SizedBox(
              width: 20,
            ),
            _PostButton(
              icon: Icon(
                MdiIcons.commentOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Bình luận',
              onTap: () => {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (BuildContext buildContext,
                        Animation animation, Animation secondaryAnimation) {
                      return Center(
                        child: Container(
                          width: Responsive.isDesktop(context)
                              ? 600.0
                              : MediaQuery.of(context).size.width,
                          height: Responsive.isDesktop(context)
                              ? 500.0
                              : MediaQuery.of(context).size.height,
                          padding: EdgeInsets.all(0),
                          color: Colors.black,
                          child: Scaffold(
                              appBar: AppBar(
                                iconTheme:
                                    IconThemeData(color: Palette.bcBlack),
                                title: const Center(
                                    child: Text('Bình luận',
                                        style:
                                            TextStyle(color: Palette.bcBlack))),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                actions: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              body: CommentBox(
                                postID: id, notifyParent: notifyParent
                              )),
                        ),
                      );
                    }); 
                })
                
              },
            ),
            SizedBox(
              width: 20,
            ),
            _PostButton(
              icon: Icon(
                MdiIcons.shareOutline,
                color: Colors.grey[600],
                size: 25.0,
              ),
              label: 'Chia sẻ',
              onTap: () => print('Share'),
            )
          ],
        ),
        Row(
          children: [
            const Divider(
                height: 10.0, thickness: 1, color: Palette.bookChatBlack)
          ],
        )
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function onTap;

  const _PostButton({
    Key key,
    this.icon,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          focusColor: Colors.white,
          hoverColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Palette.bcBlack),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 4.0),
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

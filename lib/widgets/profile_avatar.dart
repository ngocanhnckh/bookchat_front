import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import "package:http/http.dart" as http;
class ProfileAvatar extends StatefulWidget {
  final String imageUrl;
  final bool isActive;
  final bool hasBorder;
  final String userName;
  const ProfileAvatar({
    Key key,
    @required this.imageUrl,
    this.isActive = false,
    this.hasBorder = false, 
    this.userName = "",

  }) : super(key: key);
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String img = "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png";
  Future<void> checkImg() async{
    if(widget.imageUrl!=null){
      print("Image link: " + widget.imageUrl);
      
      try {
        final response = await http.get(Uri.parse(widget.imageUrl));
        print(response.statusCode);
         if(response.statusCode!=200){
           print("IMage not found");
          }
          else{
            setState(() {
              img = widget.imageUrl;
            });
          }
      }
      catch(e){
        print(e);
      }
     
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkImg();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Palette.bcBlack,
          child: CircleAvatar(
            radius: widget.hasBorder ? 17.0 : 20.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: widget.imageUrl!=null ? CachedNetworkImageProvider(widget.imageUrl,
            ) : CachedNetworkImageProvider("https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png"),
          ),
        ),
        widget.isActive
            ? Positioned(
                bottom: 58.0,
                right: 0.0,
                child: Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: BoxDecoration(
                    color: Palette.online,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Positioned(
        bottom: 0.0,
        child: Text(widget.userName))
      ],
    );
  }
}



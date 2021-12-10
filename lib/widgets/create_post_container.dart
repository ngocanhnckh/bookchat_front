import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;

List<Asset> image1 = [];
class CreatePostContainer extends StatefulWidget {
  final BcUser currentUser;
  final Function() callFunction;
  const CreatePostContainer({
    Key key,
    @required this.currentUser, this.callFunction,
  }) : super(key: key);

  @override
  _CreatePostContainerState createState() => _CreatePostContainerState();
}

class _CreatePostContainerState extends State<CreatePostContainer> {
  final postContent = TextEditingController();
  List<XFile> _imageFileList = [];
  
  dynamic _pickImageError;
  ImagePicker _picker = ImagePicker();
 
  
  ///This function post a new status to API
  Future<void> postStatus() async {
    String token = await getCToken();
    
     List<MultipartFile> multipartImageList = <MultipartFile>[];
      if (null != image1) {
        for (XFile asset in _imageFileList) {
          Uint8List data = await asset.readAsBytes();
          List<int> list = data.cast();
          MultipartFile multipartFile = new MultipartFile.fromBytes(
            list,
            filename: 'load_image.jpg',
            contentType: MediaType("image", "jpg")
          );
          multipartImageList.add(multipartFile);
        }
      }
    FormData formData = FormData.fromMap({
        'content': postContent.text,
        'attachments': multipartImageList
      });

    await Dio().post(apiurl + '/posts',
      data: formData,
      options: Options(
        headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              "Authorization": "Bearer $token"
            },
      )
    ).then((value) {
      print(value.statusCode);
      print(value.data);
      widget.callFunction();
      Navigator.pop(context);
    }
    
    ).onError((error, stackTrace) {
      print("error "+ error.toString());
    });
    // http
    //     .post(Uri.parse(apiurl + '/posts'),
    //         headers: {
    //           'Content-Type': 'application/json; charset=UTF-8',
    //           "Authorization": "Bearer $token"
    //         },
    //         body: jsonEncode({'content': postContent.text}))
    //     .then((value) => {print(value.body)})
    //     // ignore: missing_return
    //     .onError((error, stackTrace) {
    //   print(error);
    // });
  }
  
   Widget _previewImages() {
    if (_imageFileList==null) {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
     
       return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (context, index) {
              // Why network for web?
              // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(_imageFileList[index].path)
                    : Image.file(File(_imageFileList[index].path)),
              );
            },
            itemCount: _imageFileList.length,
          ),
          label: 'image_picker_example_picked_images');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 5.0 : 0.0),
      elevation: isDesktop ? 1.0 : 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: (BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        )),
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                ProfileAvatar(imageUrl: widget.currentUser.imageUrl),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    onTap: () {
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                                 
                            return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                              void pickImage() async{
                                      print("Picking...");
                                          try {
                                            final pickedFileList = await _picker.pickMultiImage();
                                            if(pickedFileList!=null){
                                              setState(() {
                                                _imageFileList = pickedFileList;
                                              });
                                              
                                            print("Picked " + _imageFileList.length.toString() + " images");
                                            }
                                          } catch (e) {
                                            setState(() {
                                              print("Error taking images " + e.toString());
                                              _pickImageError = e;
                                            });
                                          }
                                    }
                              return Center(
                              child: Container(
                                width: isDesktop
                                    ? 600.0
                                    : MediaQuery.of(context).size.width,
                                height: isDesktop
                                    ? 500.0
                                    : MediaQuery.of(context).size.height,
                                padding: EdgeInsets.all(0),
                                color: Colors.black,
                                child: Scaffold(
                                    appBar: AppBar(
                                      iconTheme:
                                          IconThemeData(color: Palette.bcBlack),
                                      title: const Center(
                                          child: Text('Bài viết mới',
                                              style: TextStyle(
                                                  color: Palette.bcBlack))),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      actions: <Widget>[
                                        IconButton(
                                          icon: const Icon(
                                            Icons.check,
                                            color: Palette.bcBlue,
                                          ),
                                          tooltip: 'Đăng bài viết',
                                          onPressed: () {
                                            postStatus();
                                            
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Đã đăng bài viết')));
                                          },
                                        ),
                                        // TextButton(
                                        //   style: TextButton.styleFrom(
                                        //     primary: Palette.bcBlack,
                                        //     textStyle: const TextStyle(fontSize: 20),
                                        //   ),

                                        //   onPressed: () {
                                        //     ScaffoldMessenger.of(context).showSnackBar(
                                        //         const SnackBar(content: Text('Đã đăng bài viết')));
                                        //   },
                                        //   child: const Text('Đăng'),
                                        // ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    ),
                                    body: Container(
                                      height: isDesktop
                                          ? null
                                          : MediaQuery.of(context).size.height,
                                      child: Column(
                                        mainAxisSize: isDesktop
                                            ? MainAxisSize.min
                                            : MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const SizedBox(width: 8.0),
                                              ProfileAvatar(
                                                  imageUrl: (currentProfile.avatar!=null) ? currentProfile.avatar : widget.currentUser.imageUrl ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: TextField(
                                                  controller: postContent,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  minLines: 1,
                                                  maxLines: isDesktop ? 10 : 5,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                    hintText:
                                                       (currentProfile!=null) ? currentProfile.displayName + ' đang muốn chia sẻ điều gì?' : 'Bạn đang muốn chia sẻ điều gì?',
                                                  ),
                                                ),
                                              ),
                                          
                                            ],
                                          ),
                                          Text("Picked " + _imageFileList.length.toString()),
                                          
                                          Expanded(
                                            child: 
                                            (_imageFileList.length!=0) ? 
                                            GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: 0,
                                                  mainAxisSpacing: 0,
                                                  crossAxisCount: 3,
                                                ),
                                                itemCount: _imageFileList.length,
                                                itemBuilder: (context, index) {
                                                  // Item rendering
                                                  return Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(_imageFileList[index].path),
                                                        ),
                                                      ),
                                                    );
                                                },
                                              ): Text("No image"),
                                          ),
                                         
                                          Expanded(
                                              child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 60,
                                              decoration: (BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              )),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // CircleButton(
                                                      //     icon: LineIcons.book,
                                                      //     iconSize: 25,
                                                      //     onPressed: () {}),
                                                      CircleButton(
                                                          icon: LineIcons.image,
                                                          iconSize: 25,
                                                          onPressed: () async {
                                                            //Setting images
                                                            pickImage();
                                                          }),
                                                      // CircleButton(
                                                      //     icon: LineIcons.user,
                                                      //     iconSize: 25,
                                                      //     onPressed: () {})
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          }); 
                        });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(
                      hintText: (currentProfile!=null) ? currentProfile.displayName + ' đang muốn chia sẻ điều gì?' : 'Bạn đang muốn chia sẻ điều gì?',
                    ),
                  ),
                )
              ],
            ),
            //define a spacing
            SizedBox(
              //Use of SizedBox
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePickerWidget extends StatefulWidget {
  

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
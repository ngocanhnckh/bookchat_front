import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/book_model.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/models/user_model.dart';
import 'package:flutter_bookchat/screens/your_book_shelf.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http_parser/http_parser.dart';

class ProfileScreen extends StatefulWidget {
  final String usrId;
  final bool isCurrentUser;
  
  const ProfileScreen({Key key, this.usrId, this.isCurrentUser})
      : super(key: key);
  
  @override
 
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BcUserProfile usp = null;
  var loading = true;
  
  var img="https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png";

  List<bookData> mybookList = [];

  Future<void> getmyBook() async{
    List<bookData> books = [];
    var getBooks = await callAPI('/bookshelf/mine',['limit'],['10']);
    print(getBooks.toString());
    if (getBooks!=null){
      var postJson = jsonDecode(getBooks)['data'] as List;
      postJson.forEach((element) {
        bookData book = bookData.fromJson(element);
        books.add(book);
      });
      print("Books length " + books.length.toString());
      books.shuffle();
      setState(() {
        mybookList = books;
      });
    }
  }

  Future<void> checkImg() async{
    if(usp.avatar==null){
       final response = await http.get(Uri.parse(usp.avatar));
      if(response.statusCode==200){
          img=usp.avatar;
      }
      else{
        print("Image not found");
      }
    }
  }
 
  List<Post> postLists = [];
  var bioContent = TextEditingController();
  Future<void> getPost() async{
    //await setCP();
    print("Current id: " + currentProfile.id);
    var currentUserId = currentProfile.id;
    http.get(
            Uri.parse(apiurl + '/posts?limit=100&userId=$currentUserId'))
        .then((value) {
      print(value.body);
      var postJson = jsonDecode(value.body)['data'] as List;
      print("got postJson");
      List<PostDetails> pds =
          postJson.map((js) => PostDetails.fromJson(js)).toList();
      print("mapped pds");
      List<Post> postList = [];
      if (pds != null) {
        Set<PostDetails> set = Set.from(pds);
        set.forEach((element) {
          print(element.author.displayName);
          postList.add(Post(
               caption: element.content,
              user: element.author,
              likes:
                  element.likeCount,
              shares: 0,
              comments: element.commentCount,
              timeAgo: element.recent + " trước",
              id: element.id,
              attachments: element.attachments,
              details: element
              ));
        });
        setState(() {
          postLists = postList;
        });
          
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Function updatePost(){
    getPost();
    
  }
  Function updateProfile(){
    setState(() {
      usp.bio = currentProfile.bio;
    });
  }
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
    builder: (context){
      final TextEditingController _textEditingController = TextEditingController();
      bool isChecked = false;
      return StatefulBuilder(builder: (context,setState){
        return AlertDialog(
          content: DialogChanger(
          title: "Sửa tiểu sử",
          hint: "Tiểu sử của bạn",
          textController: bioContent,
          ),
          actions: [
            ModernButton(label: "Sửa tiểu sử", onTap: () async {
              print("Xin chao" + bioContent.text);
              var putContent = {
                  "bio": bioContent.text,
                };
              
              print(putContent.toString());

              await putAPI("/users/me", 
                putContent
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã sửa tiểu sử')));
              currentProfile.bio = bioContent.text;
              //Dont know why the hell I have to call it twice
              updateProfile();
              updateProfile();
              
              Navigator.pop(context);
            })
          ],
        );
      });
    });
  }

  Future<void> getUser() async{
    if (widget.isCurrentUser){
      usp = currentProfile;
      setState(() {
        bioContent.text = usp.bio;
      });
      getmyBook();
      loading = false;
      print(currentProfile.avatar);
      if(currentProfile.avatar!=null)
      setState(() {
        img=currentProfile.avatar;
      });
        
    }
    else{
      var userID = widget.usrId;
      var result = await callAPI("/users/$userID", null, null);
      if(result!=null){
        
        usp = BcUserProfile.fromJson(jsonDecode(result)['data']);
        setState(() {
          bioContent.text = usp.bio;
        });
        loading = false;
      }
    }
  }

  void initState() {
    
    
    getUser();
    getPost();
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Material(child:Container(
      color: Color(0xFFE5E5E5),
      child: 
      loading ? Center(child: CircularProgressIndicator()) :
      CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: CircleButton(
              icon: SimpleLineIcons.arrow_left,
              iconSize: 20.0,
              onPressed: () => Navigator.pop(context),
            ),
            pinned: true,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Padding(
                padding: EdgeInsets.all(1),
                child: Text(
                  usp.displayName,
                  style: TextStyle(color: Palette.bcBlack),
                )),
            floating: true,
            actions: [
              CircleButton(
                icon: SimpleLineIcons.magnifier,
                iconSize: 20.0,
                onPressed: () => print('Search'),
              ),
            ],
          ),
          SliverToBoxAdapter(child: 
          
            Builder(
              builder: (context) {
                return Material(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                    child: Stack(
                      //alignment: Alignment.center,
                      children: <Widget>[
                          SizedBox(
                            
                            height: 200,
                            width: double.infinity, 
                            child: Image(image: NetworkImage('https://images.pexels.com/photos/694740/pexels-photo-694740.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'),
                            fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 180,
                            left: 30,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: CachedNetworkImageProvider(img),
                                ),
                                SizedBox(width: 5,),
                                Column(
                                  children: [
                                    Text(usp.displayName, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16,))
                                  ],
                                )
                              ],
                            )
                          ),
                          Positioned(
                            top: 235,
                            left: 85,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Palette.bgGrey, // border color
                                  shape: BoxShape.circle,
                                ),
                              child: IconButton(icon: Icon(SimpleLineIcons.camera, size: 10), onPressed: () async {
                                  String token = await getCToken();
                                  ImagePicker _picker = ImagePicker();
                                  print("Picking...");
                                          try {
                                            final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                                            Uint8List bytes = await pickedImage.readAsBytes();
                                            List<int> list = bytes.cast();
                                            MultipartFile multipartFile = new MultipartFile.fromBytes(
                                              list,
                                              filename: 'load_image.jpg',
                                              contentType: MediaType("image", "jpg")
                                            );
                                            FormData formData = FormData.fromMap({
                                              'avatar': multipartFile
                                            });
                                            await Dio().post(apiurl + '/users/me/avatar',
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
                                                Navigator.pop(context);
                                              }
                                              
                                              ).onError((error, stackTrace) {
                                                print("error "+ error.toString());
                                              });
                                          } catch (e) {
                                            print(e.toString());
                                          }
                              },),
                            )
                          )

                      ],
                    ),
                    
                  ),
                );
              }
            )
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 20,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: 
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Tiểu sử',style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Expanded(child: Align(
                              alignment: Alignment.bottomRight,
                              child: 
                              (widget.isCurrentUser) ?
                              IconButton(icon: Icon(SimpleLineIcons.pencil, size: 15,), onPressed: () { 
                                  
                                 showInformationDialog(context);

                               },) : Container()
                            ))
                          ],
                        ),
                        SizedBox(height: 3,),
                        Text(usp.bio)
                      ],
                    )
                  )                
                ),
            ),
          ),
          SliverToBoxAdapter(
            child: 
            Container(
                           padding: EdgeInsets.all(10),
                           child: Card(
                              
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // padding: const EdgeInsets.fromLTRB(10,0,10,0),
                                      child: Row(
                                        children: [
                                          Container(
                                          padding: EdgeInsets.only(left: 10),  
                                          child: Text('Tủ sách của tôi',style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(icon: Icon(SimpleLineIcons.arrow_right, size: 15),
                                                onPressed: (){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => YourBookSelf()),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                    padding: EdgeInsets.all(8),
                                    height: 200.0,
                                    color: Colors.white,
                                        child: ListView.builder(
                                          // padding: const EdgeInsets.symmetric(
                                          //   vertical: 10.0,
                                          //   horizontal: 4.0,
                                          // ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: mybookList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Image(image: NetworkImage(mybookList[index].thumbnail)),
                                            );
                                          },
                                        ),
                                      
                                    ),
                                  ],
                                ),
                              )
                    ),
                  ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final Post post = postLists[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PostContainer(post: post, id:post.id, notifyParent: updatePost),
                );
              },
              childCount: postLists.length,
            ),
          ),
        ],
      ),
    ));
  }
}

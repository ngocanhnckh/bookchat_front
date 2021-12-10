import 'dart:convert';
import 'package:flutter_bookchat/widgets/ads_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'screens.dart';

class HomeScreen extends StatefulWidget 

{
 
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();
 
  List<Post> postLists = [];
  Future<void> setCP() async{
    currentProfile = await getCUser();
  }
  Future<List<Post>> getPost() {
    setCP();
    print("Getting post...");
    http
        .get(
            Uri.parse(apiurl + '/posts?limit=100'))
        .then((value) {
      print(value.body);
      var postJson = jsonDecode(value.body)['data'] as List;
      print("got postJson");
      List<PostDetails> pds =
          postJson.map((js) => PostDetails.fromJson(js)).toList();
      print("mapped pds");
      if (pds != null) {
        Set<PostDetails> set = Set.from(pds);
        List<Post> postList = [];
        
        set.forEach((element) {
          postList.add(Post(
              caption: element.content,
              user: element.author,
              userID: element.author.id,
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
          postLists = postList.reversed.toList();
        });
        return postList;
      }
    }).onError((error, stackTrace) {
      print(error.toString());
      return null;
    });
  }

 Function updatePost(){
    getPost();
  }
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    getPost();
  }

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Responsive(
          mobile:
              _HomeScreenMobile(scrollController: _trackingScrollController, plist: postLists,notifyParent: updatePost),
          desktop:
              _HomeScreenDesktop(scrollController: _trackingScrollController, plist: postLists,notifyParent: updatePost),
        ),
      ),
    );
  }
}

class _HomeScreenMobile extends StatefulWidget {
  final TrackingScrollController scrollController;
  final List<Post> plist;
  final Function() notifyParent;
  const _HomeScreenMobile({
    Key key,
    @required this.scrollController, this.plist, this.notifyParent
  }) : super(key: key);

  @override
  __HomeScreenMobileState createState() => __HomeScreenMobileState();
}

class __HomeScreenMobileState extends State<_HomeScreenMobile> {
  List<BcUserProfile> users = [];
  Future<void> getUser() async{
    List<BcUserProfile> userss = [];
    final http.Response response = await http.get(
      Uri.parse(apiurl + '/users?limit=100&active=true'),
      headers: await getHeader(),
    );
    print(response.body);
    if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
    } else {
      print('API ${response.statusCode} response: ${response.body}');
      var postJson = jsonDecode(response.body)['data'] as List;
      postJson.forEach((element) {
        BcUserProfile e = BcUserProfile.fromJson(element);
        print(e.displayName);
        e.avatar = e.avatar ?? "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png";
        userss.add(e);
        
      });
      setState(() {
        users = userss;
      });
    }
  }
  void initState(){
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Container(
            width: 150,
            child: Image.asset('assets/images/Logo.png', fit: BoxFit.cover)),
          floating: true,
          actions: [
            CircleButton(
              icon: SimpleLineIcons.magnifier,
              iconSize: 20.0,
              onPressed: () => {print('Searchhh')},
            ),
            CircleButton(
              icon: SimpleLineIcons.bubble,
              iconSize: 20.0,
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesScreen()),
                )
              },
            ),
            CircleButton(
              icon: SimpleLineIcons.user,
              iconSize: 20.0,
              onPressed: () => {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            isCurrentUser: true,
                          )),
                )
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          sliver: SliverToBoxAdapter(
            child: AdsSlider(
              adsList: ads,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          sliver: SliverToBoxAdapter(
            child: Rooms(onlineUsers: users),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          sliver: SliverToBoxAdapter(
            child: CreatePostContainer(currentUser: currentUser, callFunction: widget.notifyParent)
          ),
        ),
        SliverList(
          
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final Post post = widget.plist[index];
              return PostContainer(post: post, id: post.id, notifyParent: widget.notifyParent,);
            },
            childCount: widget.plist.length,
          ),
        ),
      ],
    );
  }
}

class _HomeScreenDesktop extends StatefulWidget {
   final TrackingScrollController scrollController;
    final List<Post> plist;
    final Function() notifyParent;
    const _HomeScreenDesktop({
      Key key,
      @required this.scrollController, this.plist, this.notifyParent,
    }) : super(key: key);
  @override
  __HomeScreenDesktopState createState() => __HomeScreenDesktopState();
}

class __HomeScreenDesktopState extends State<_HomeScreenDesktop> {
 List<BcUserProfile> users = [];
  Future<void> getUser() async{
    List<BcUserProfile> userss = [];
    final http.Response response = await http.get(
      Uri.parse(apiurl + '/users?limit=100&active=true'),
      headers: await getHeader(),
    );
    print(response.body);
    if (response.statusCode != 200) {
      print('API ${response.statusCode} response: ${response.body}');
      return null;
    } else {
      print('API ${response.statusCode} response: ${response.body}');
      var postJson = jsonDecode(response.body)['data'] as List;
      postJson.forEach((element) {
        BcUserProfile e = BcUserProfile.fromJson(element);
        print(e.displayName);
        e.avatar = e.avatar ?? "https://p.kindpng.com/picc/s/451-4517876_default-profile-hd-png-download.png";
        userss.add(e);
        
      });
      setState(() {
        users = userss;
      });
    }
  }
  void initState(){
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: MoreOptionsList(currentUser: currentUser, profile: currentProfile)
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 600.0,
          child: CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              // SliverPadding(
              //   padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
              //   sliver: SliverToBoxAdapter(
              //     child: Stories(
              //       currentUser: currentUser,
              //       stories: stories,
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(child:SizedBox(height: 10,)),
              SliverToBoxAdapter(
                child: CreatePostContainer(currentUser: currentUser, callFunction: widget.notifyParent,),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                sliver: SliverToBoxAdapter(
                  child: Rooms(onlineUsers: users),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate
                (
                  (context, index) {
                    final Post post = widget.plist[index];
                    return PostContainer(post: post, id: post.id, notifyParent:widget.notifyParent);
                  },
                  childCount: widget.plist.length,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ContactsList(users: users),
            ),
          ),
        ),
      ],
    );
  }
}


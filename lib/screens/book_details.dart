import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/book_model.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/button_with_icon.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetails extends StatefulWidget {
  final bookData bookdata;
  bool added = false;

  BookDetails({Key key, this.bookdata, this.added}) : super(key: key);
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  var Wrating = 0.0;
  var textController = TextEditingController();
  bool loading = true;
  Future<void> getMyreview() async {
    var bookID = widget.bookdata.id;
    var review = await callAPI("/books/$bookID/my_review", null, null);
    if (review!=null){
      print(review);
      if (jsonDecode(review)['rating'] as double != null) 
      setState(() {
        Wrating =  jsonDecode(review)['rating'] as double;
      });
    }
    setState(() {
      loading=false;
    });
  }
  var authorName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyreview();
    try{
      if (widget.bookdata.author.displayName!=null){
      setState(() {
        authorName=widget.bookdata.author.displayName;
      });
    }
    }
    catch (e){
      
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: (loading == true) ? 
        Center(child: CircularProgressIndicator(),) :
        Container(
          child: CustomScrollView(
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
                      widget.bookdata.name,
                      style: TextStyle(color: Palette.bcBlack),
                    )),
                floating: true,
                
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.bookdata.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),      
                ),
              ),
              SliverFillRemaining(
                child: Container(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        bottom: TabBar(
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: Palette.bookChat),
                              tabs: [
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Tổng quát",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Đánh giá",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                
                              ]
                        ),
                      ),
                      body: TabBarView(children: [
                        Container(
                          color: Colors.white,
                          child: 
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                SizedBox(height: 10,),
                                Text(widget.bookdata.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                Text(authorName, style: TextStyle(fontSize: 22),),
                                SizedBox(height: 20,),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                ),
                                SizedBox(height: 10,),
                               
                                  Row(
                                  children: <Widget>[
                                      Flexible(
                                        child: new  Text(
                                          widget.bookdata.description,
                                          style: TextStyle(
                                              color: Color(0xff141414),
                                              fontSize: 14,
                                          ),),
                                        )
                                      ],
                                  ),
                                  SizedBox(height: 30,),
                                  (!widget.added) ?
                                  ButtonWithIcon(text:"Thêm vào tủ",icon: Icon(SimpleLineIcons.plus), onClick: (){
                                    print("add book");
                                    postAPI("/bookshelf/mine", {
                                      "bookId": widget.bookdata.id
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã thêm sách')));
                                    Navigator.pop(context);
                                  },) : 
                                  ButtonWithIcon(text:"Xóa khỏi tủ",icon: Icon(SimpleLineIcons.trash), onClick: (){
                                    print("add book");
                                    var id = widget.bookdata.id;
                                    deleteAPI("/bookshelf/mine/$id",null,null);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã yêu cầu xóa sách')));
                                    Navigator.pop(context);
                                  },),

                              ],),
                            ),
                          )
                        ,),
                        Container(
                          color: Colors.white,
                          child: 
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: SingleChildScrollView(
                              child: Column(children: [
                                SizedBox(height: 20,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Text("Đánh giá trung bình",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: 
                                       Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                          Icon(UniconsLine.star),
                                          SizedBox(width: 10,),
                                          Text("4.5",
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                        ],)
                                    )
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                   
                                    RatingBar.builder(
                                      initialRating: Wrating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        Wrating = rating;
                                      },
                                    ),

                                  ],
                                ),
                                SizedBox(height: 20,),
                                roundedTextBox(hintText: "Lời bình",textControl: textController),
                                SizedBox(height: 20,),
                                ModernButton(label: "Đánh giá", onTap: (){
                                  var bookID = widget.bookdata.id;
                                  postAPI("/books/$bookID/my_review", {
                                    "rating": Wrating.toString(),
                                    "content": textController.text
                                  });
                                })
                              ],),
                            ),
                          )
                        ,),
                      ]),
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
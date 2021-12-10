import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/data/data.dart';
import 'package:flutter_bookchat/models/book_model.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';

class BookLibraryScreen extends StatefulWidget {
  

  

  @override
  _BookLibraryScreenState createState() => _BookLibraryScreenState();
}

class _BookLibraryScreenState extends State<BookLibraryScreen> {
  List<bookData> bookList = [];
  String nextUrl = "";
  Future<void> getBook() async{
    List<bookData> books = [];
    var getBooks = await callAPI('/books',['limit'],['100']);
    print(getBooks.toString());
    if (getBooks!=null){
      var postJson = jsonDecode(getBooks)['data'] as List;
      nextUrl = jsonDecode(getBooks)['nextUrl'];
      postJson.forEach((element) {
        bookData book = bookData.fromJson(element);
        books.add(book);
      });
      print("Books length " + books.length.toString());
      books.shuffle();
      setState(() {
        bookList = books;
      });
    }
  }
  Future<void> getBookNext() async{
    List<bookData> books = bookList;
    var getBooks = await callAPI(nextUrl.replaceAll(apiurl, ""),null,null);
    print(getBooks.toString());
    if (getBooks!=null){
      var postJson = jsonDecode(getBooks)['data'] as List;
      postJson.forEach((element) {
        bookData book = bookData.fromJson(element);
        books.add(book);
      });
      print("Books length " + books.length.toString());
    
      setState(() {
        bookList = books;
      });
    }
  }
  void initState(){
    super.initState();
    getBook();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
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
                    'Thư viện sách',
                    style: TextStyle(color: Palette.bcBlack),
                  )),
              floating: true,
              actions: [
                CircleButton(
                  icon: SimpleLineIcons.magnifier,
                  iconSize: 20.0,
                  onPressed: () => print('Thư viện sách'),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: 
                  Card(
                      color: Palette.bookChat,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                      height: 50,
                      child: Row(children: [
                        SizedBox(
                          width: 20
                        ),
                        Text('Thêm sách mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        Expanded(
                          child: 
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){}, 
                            icon: Icon(SimpleLineIcons.settings, size: 20)
                            ),
                          )
                        ),
                         SizedBox(
                          width: 20
                        ),

                      ]),
                  )),
              ),
            ),
            SliverFillRemaining(
              child: SizedBox(
                child: DefaultTabController(
                length: 3,
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
                                child: Text("Sách",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Tác giả",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Nhà xuất bản",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ]
                    ),
                  ),
                  body: TabBarView(children: [
                      Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            
                            children: [
                              Container(
                                height: 100,
                                child: Row(
                                  children: [
                                    SizedBox(width: 30,),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(color: Colors.white)),
                                      filled: true,
                                      hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                                      hintText: "Nhập nội dung tìm kiếm",
                                      fillColor: Color(0xFFF9F9F9)),
                                      ),
                                    ),
                                    SizedBox(width: 30,),
                                    Container(child: 
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: IconButton(onPressed: (){}, icon: Icon(SimpleLineIcons.magnifier), color: Colors.black,)),
                                    ),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              (bookList.length==0) ? Container() : 
                              SizedBox(
                                 height: MediaQuery.of(context).size.height,
                                 child: ResponsiveGridList(
                                                  desiredItemWidth: 170,
                                                  minSpacing: 10,
                                                  children: bookList.map((i) {
                                                    return Container(
                                                      height: 320,
                                                      alignment: Alignment(0, 0),
                                                      child: BookCard(bookdata: i,added: false,),
                                                    );
                                                  }).toList()
                                ),
                              ),
                              ModernButton(label: 'Tải thêm', onTap: (){getBookNext();}),
                              SizedBox(height: 10,)
                            ]
                          ),
                        )
                      ),
                    Icon(Icons.movie),
                    Icon(Icons.games),
                  ]),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/book_model.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';

class YourBookSelf extends StatefulWidget {


  @override
  _YourBookSelfState createState() => _YourBookSelfState();
}

class _YourBookSelfState extends State<YourBookSelf> {
  
  List<bookData> bookList = [];

  Future<void> getBook() async{
    List<bookData> books = [];
    var getBooks = await callAPI('/bookshelf/mine',['limit'],['100']);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
            backgroundColor: Colors.white,
            leading: CircleButton(
                icon: SimpleLineIcons.arrow_left,
                  iconSize: 20.0,
                  onPressed: () => Navigator.pop(context),
              ),
            title: Padding(
                padding: EdgeInsets.all(1),
                
                child: Text(
                  'Tủ sách của bạn',
                  style: TextStyle(color: Palette.bcBlack),
                )),
            actions: [
              CircleButton(
                icon: Icons.search,
                iconSize: 25.0,
                onPressed: () => print('Search'),
              ),
            ],
          ),
          
          body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: (bookList.length==0) ? Container() : 
                              SizedBox(
                                 height: MediaQuery.of(context).size.height,
                                 child: ResponsiveGridList(
                                                  desiredItemWidth: 170,
                                                  minSpacing: 10,
                                                  children: bookList.map((i) {
                                                    return Container(
                                                      height: 320,
                                                      alignment: Alignment(0, 0),
                                                      child: BookCard(bookdata: i, added: true,),
                                                    );
                                                  }).toList()
                                ),
                              )
                )
              ]
            )
          );
  }
}

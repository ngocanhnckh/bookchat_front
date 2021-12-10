import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/book_model.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/screens/your_book_shelf.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class BookScreen extends StatefulWidget {
  
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {

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

  List<bookData> bookList = [];

  Future<void> getBook() async{
    List<bookData> books = [];
    var getBooks = await callAPI('/books',['limit'],['10']);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmyBook();
    getBook();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bgGrey,
      
      appBar: AppBar(
            backgroundColor: Colors.white,
            title: Padding(
                padding: EdgeInsets.all(1),
                
                child: Text(
                  'Thư viện sách',
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
          
          body: Container(
            
            child: 
               SingleChildScrollView(
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                     
                       Center(
                         child: Container(
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
                                          child: Text('Tủ sách của bạn',style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
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
              Center(
                         child: Container(
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
                                          child: Text('Khám phá thư viện',style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(icon: Icon(SimpleLineIcons.arrow_right, size: 15),
                                                onPressed: (){
                                                  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => BookLibraryScreen()),
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
                                          itemCount: bookList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Image(image: NetworkImage(bookList[index].thumbnail)),
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
                     
                  ],
              ),
               ),
            )
          );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bookchat/models/book_model.dart';
import 'package:flutter_bookchat/screens/book_details.dart';

class BookCard extends StatelessWidget {
  final bookData bookdata;
  bool added = false;
  BookCard({Key key, this.bookdata, this.added}) : super(key: key);
  ///Book card
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookDetails(bookdata: bookdata,added: added,)),
          );
        },
        child: 
        Container(
              width: 169.13,
              height: 283.97,
              child: Stack(
                  children:[Container(
                      width: 169.13,
                      height: 273.97,
                      child: Stack(
                          children:[SizedBox(
                              width: 169.13,
                              height: 283.97,
                              child: Material(
                                  color: Colors.white,
                                  elevation: 10, 
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                      padding: const EdgeInsets.only(bottom: 88, ),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                              SizedBox(
                                                  width: 169.13,
                                                  height: 175.98,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                    bookdata.thumbnail
                                                                    ),
                                                            fit: BoxFit.cover
                                                        ),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0), ),
                                                      ),
                                                  ),
                                              ),
                                          ],
                                      ),
                                  ),
                              ),
                          ),
                          Positioned.fill(
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                      width: 169.13,
                                      height: 87.99,
                                      child: Material(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16), ),
                                      ),
                                  ),
                              ),
                          ),],
                      ),
                  ),
                  Positioned(
                      left: 16.61,
                      top: 195.20,
                      child: Container(
                          width: 126.96,
                          height: 68.63,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                  SizedBox(
                                      width: 100.64,
                                      height: 32.32,
                                      child: Text(
                                          bookdata.name,
                                          style: TextStyle(
                                              color: Color(0xff141414),
                                              fontSize: 14,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w700,
                                          ),
                                      ),
                                  ),
                                  SizedBox(
                                      width: 126.96,
                                      height: 19.32,
                                      child: Text(
                                          (bookdata.author == null) ? "" :
                                          bookdata.author.displayName,
                                          style: TextStyle(
                                              color: Color(0xff141414),
                                              fontSize: 16,
                                          ),
                                      ),
                                  ),
                              ],
                          ),
                      ),
                  ),],
              ),
          ),
    );
  }
}
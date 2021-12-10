import 'package:flutter/material.dart';

class SquareCard extends StatefulWidget {
  final String heading;
  final String content;
  final Function() onClick;
  final Icon iconButton;
  const SquareCard({Key key, this.heading, this.content, this.onClick, this.iconButton}) : super(key: key);

  @override
  _SquareCardState createState() => _SquareCardState();
}

class _SquareCardState extends State<SquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
            width: 170,
            height: 170,
            child: Center(child: 
            
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 5, top: 22, bottom: 12, ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                      SizedBox(
                          width: 170,
                          height: 70.01,
                          child: Text(widget.heading,
                              style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 24,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w700,
                              ),
                          ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: (widget.iconButton!=null) ? SizedBox(
                          width: 170,
                          height: 45,
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Align(alignment: Alignment.topRight, child: widget.iconButton)
                            ),
                        ) : SizedBox(
                          width: 170,
                          height: 45,
                          child: Text(widget.content,
                            style: TextStyle(
                                color: Color(0xffbdbdbd),
                                fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
              ),
          ),
            
        ),
  )),
    );
  }
}
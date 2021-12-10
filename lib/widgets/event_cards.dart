import 'package:flutter/material.dart';
import 'package:flutter_bookchat/models/models.dart';

class EventCard extends StatelessWidget {
  
  final eventData event;

  const EventCard({Key key, this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
            width: 354,
            height: 245,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                    SizedBox(
                        width: 354,
                        height: 245,
                        child: Material(
                            color: Colors.white,
                            elevation: 12, 
                           
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                                children:[
                                    Positioned.fill(
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: SizedBox(
                                                width: 354,
                                                height: 157,
                                                child: Material(
                                                    color: Color(0xff141414),
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0), ),
                                                ),
                                            ),
                                        ),
                                    ),
                                    Positioned.fill(
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: SizedBox(
                                                width: 354,
                                                height: 79,
                                                child: Material(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16), ),
                                                ),
                                            ),
                                        ),
                                    ),
                                    Positioned(
                                        left: 16,
                                        top: 170,
                                        child: Container(
                                            width: 300,
                                            height: 55,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  
                                                     Row(
                                                    children: <Widget>[
                                                        Flexible(
                                                        child: new  Text(
                                                            event.name,
                                                        style: TextStyle(
                                                            color: Color(0xff141414),
                                                            fontSize: 20,
                                                            fontFamily: "Roboto",
                                                            fontWeight: FontWeight.w700,
                                                        ),overflow: TextOverflow.ellipsis),
                                                            )
                                                        ],
                                                    ),
                                                    SizedBox(height: 2),
                                                   
                                                    Row(
                                                    children: <Widget>[
                                                        Flexible(
                                                        child: new  Text(
                                                            event.content,
                                                            style: TextStyle(
                                                                color: Color(0xff141414),
                                                            fontSize: 16,
                                                            ),overflow: TextOverflow.ellipsis),
                                                            )
                                                        ],
                                                    )
                                                ],
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
  }
}
import 'dart:convert';

import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/event_model.dart';
import 'package:flutter_bookchat/screens/explore_event.dart';
import 'package:flutter_bookchat/screens/screens.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/event_cards.dart';
import 'package:flutter_bookchat/widgets/square_card.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class EventExplore extends StatefulWidget {
  

  @override
  _EventExploreState createState() => _EventExploreState();
}

class _EventExploreState extends State<EventExplore> {
  List<eventData> events =[];
  Future<void> getEvent() async{
    List<eventData> eventss=[];
    var getEventList = await callAPI("/events", ["limit"], ["30"]);
    if (getEventList!=null){
      print("Parsing Event");
      var postJson = jsonDecode(getEventList)['data'] as List;
      postJson.forEach((element) {
        print("event:");
        print(element.toString());
        eventData event = eventData.fromJson(element);
        print("parsed:");
        if(event!=null)
        eventss.add(event);
      });
      print("Events length " + eventss.length.toString());
     
      setState(() {
        events = eventss;
      });
    }
  }
   @override
  void initState() {
    // TODO: implement initState
    getEvent();
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
                'Sự kiện',
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
            child: Container(
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
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10,)
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SquareCard(heading: "Khám phá\nsự kiện",content: events.length.toString() + " sự kiện", onClick: (){
                      
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExploreEventsScreen()),
                      );
                    },),
                    SizedBox(width: 10,),
                    SquareCard(heading: "Tổ chức\nsự kiện", content:"", iconButton: Icon(SimpleLineIcons.plus), onClick: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateNewEventPage()),
                      );

                    },)
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10,)
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: 25),
                child: Text("Lời mời tham gia sự kiện",
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20,),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10,)
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Flex(
                    direction: Responsive.isDesktop(context)? Axis.horizontal : Axis.vertical,
                    children: (events!=null) ? events.map((i) {
                                                    return 
                                                      Padding(
                                                        padding: const EdgeInsets.all(15.0),
                                                        child: EventCard(event: i,),
                                                      );
                                                    
                                                  }).toList() : <Widget>[Text("Nothing")]
                  ),
              )
            ),
          ],
        )
      );
  }
}
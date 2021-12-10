import 'package:flutter_bookchat/config/palette.dart';
import 'package:flutter_bookchat/models/models.dart';
import 'package:flutter_bookchat/utils/apiutils.dart';
import 'package:flutter_bookchat/widgets/dateSelector.dart';
import 'package:flutter_bookchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CreateNewEventPage extends StatefulWidget {
  

  @override
  _CreateNewEventPageState createState() => _CreateNewEventPageState();
}

class _CreateNewEventPageState extends State<CreateNewEventPage> {
  DateTime dateEvent = DateTime.now();
  var eventName = TextEditingController();
  var eventDescription = TextEditingController();
  var eventLocation = TextEditingController();
  
  Future<void> postEvent() async{
    postAPI("/events", {
      "name": eventName.text,
      "content": eventDescription.text,
      "date": dateEvent.toString(),
      "location": eventLocation.text
    });
    ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã gửi sự kiện')));
    Navigator.pop(context);
  }
  @override
  void initState() {
    // TODO: implement initState
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
                  'Tạo sự kiện mới',
                  style: TextStyle(color: Palette.bcBlack),
              )),
         
        ),
          
          body: Container(
            padding: EdgeInsets.all(10),
            child: CustomScrollView(
              slivers: [
                
                SliverToBoxAdapter(
                  child: roundedTextBox(hintText: "Tên sự kiện",textControl: eventName,),
                ),
                
                SliverToBoxAdapter(
                  child: SizedBox(height: 15),
                ),

                SliverToBoxAdapter(
                  child: titleText(text: "Thời gian tổ chức",)
                ),
                SliverToBoxAdapter(
                  child: dateSelector(title: "Ngày: ", selectedDate: dateEvent,),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 15),
                ),
                  SliverToBoxAdapter(
                  child: titleText(text: "Mô tả sự kiện",)
                ), 
                SliverToBoxAdapter(
                  child: roundedTextBox(hintText: "Mô tả ", lines: 5,textControl: eventDescription,),
                ),
                SliverToBoxAdapter(
                  child: titleText(text: "Địa điểm",)
                ), 
                 SliverToBoxAdapter(
                  child: roundedTextBox(hintText: "Nhập địa điểm ", lines: 2,textControl: eventLocation,),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 15),
                ),
                SliverToBoxAdapter(
                  child: ModernButton(label: "Tiếp tục", onTap: (){
                    postEvent();
                  },),
                )
              ],
            ),
          )
        );
  }
}
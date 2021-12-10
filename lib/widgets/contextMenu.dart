import 'package:flutter/material.dart';

class ContextMenu extends StatefulWidget {
  List<String> text;
  List<Function> onclick;
  ContextMenu({this.text,this.onclick});

  @override
  _ContextMenuState createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  List<PopupMenuItem> popupMenu = [];
  void initState(){
    List<PopupMenuItem> menus = [];
    int count = 0;
    widget.text.forEach((element) {
      menus.add(
        PopupMenuItem(child: Text(element), value: count)
      );
      count++;
      
    });
    setState(() {
      popupMenu = menus;
    });
  }
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selectedValue) {
        Function exec = widget.onclick[selectedValue];
        exec();
      },
      itemBuilder: (BuildContext ctx) => 
          popupMenu
    );
  }
}


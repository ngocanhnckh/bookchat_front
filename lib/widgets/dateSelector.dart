import 'package:flutter/material.dart';

class dateSelector extends StatefulWidget {
  final String title;
  DateTime selectedDate = DateTime.now();
  dateSelector({Key key, this.title, this.selectedDate}) : super(key: key);
  

  @override
  _dateSelectorState createState() => _dateSelectorState();
}

class _dateSelectorState extends State<dateSelector> {
  @override
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(1910, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.selectedDate)
      setState(() {
        widget.selectedDate = picked;
      });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Row(
              children: [
                Text(widget.title + "${widget.selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      child: Text('Chọn ngày'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
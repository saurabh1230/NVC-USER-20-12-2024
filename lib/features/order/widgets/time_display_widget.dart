import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeDisplayWidget extends StatelessWidget {
  final String datetime;

  // Constructor to accept datetime as parameter
  const TimeDisplayWidget({Key? key, required this.datetime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      // Convert the datetime string to a DateTime object
      DateTime parsedDate = DateTime.parse(datetime);

      // Format the time part (hours and minutes only)
      String formattedTime = DateFormat('HH:mm').format(parsedDate);

      return Text(
        formattedTime,
        style: TextStyle(fontSize: 16),
      );
    } catch (e) {
      return Text(
        'Invalid Date',
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    }
  }
}

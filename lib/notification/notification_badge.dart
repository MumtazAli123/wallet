// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotification;
  const NotificationBadge({super.key, required this.totalNotification});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      padding:  EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child:  Center(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Text(
            "$totalNotification",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}

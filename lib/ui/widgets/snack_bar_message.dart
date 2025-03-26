import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String message, int duration,
    {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    backgroundColor: isError ? Colors.red : Colors.green,
    duration: Duration(seconds: duration),
  ));
}

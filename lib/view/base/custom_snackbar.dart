import 'package:flutter/material.dart';

void showCustomSnackBar(String message, BuildContext context,
    {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 500),
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(message),
    ),
  );
}

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

enum ToastType { success, error }

class PredefinedToast {
  static void showToast(String message, ToastType type) {
    Color backgroundColor;

    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        break;
      case ToastType.error:
        backgroundColor = Colors.red;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

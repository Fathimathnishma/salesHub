import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saleshub/core/utils/app_colors.dart';

class AppToast {
  static void show({required String message, bool isError = false}) {
    if (message.trim().isEmpty) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError
          ? Colors.red
          : AppColors.textSecondary.withOpacity(0.4),
      textColor: isError
          ? Colors.black
          : AppColors.textSecondary.withOpacity(0.4),
      fontSize: 16.0,
    );
  }
}

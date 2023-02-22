import 'package:flutter/material.dart';

class AppColor {
  static final _app = AppColor._internal();

  factory AppColor() => _app;

  AppColor._internal();

  var isDarkMode = false;

  Color get backgroundColor => isDarkMode ? Colors.black : Colors.white;

  Color get backgroundPrimaryColor => isDarkMode ? Colors.white : Colors.black;

  Color get taskColor =>
      isDarkMode ? Colors.grey.shade700 : Colors.yellow.shade200;
}

final appColor = AppColor();

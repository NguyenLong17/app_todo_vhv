import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static final _app = AppController._internal();

  factory AppController() => _app;

  AppController._internal();

  bool isDarkMode = false;


  bool isLanguage = false;

  String get languageApp => isLanguage ? "en" : "vi";


  Color get backgroundColor => isDarkMode ? Colors.black : Colors.white;

  Color get backgroundPrimaryColor => isDarkMode ? Colors.white : Colors.black;

  Color get taskColor =>
      isDarkMode ? Colors.grey.shade700 : Colors.yellow.shade200;
}


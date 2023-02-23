import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static final _app = AppController._internal();

  factory AppController() => _app;

  AppController._internal();

  RxBool isDarkMode = false.obs;


  RxBool isLanguage = false.obs;

  String get languageApp => isLanguage.value ? "en" : "vi";


  Color get backgroundColor => isDarkMode.value ? Colors.black : Colors.white;

  Color get backgroundPrimaryColor => isDarkMode.value ? Colors.white : Colors.black;

  Color get taskColor =>
      isDarkMode.value ? Colors.grey.shade700 : Colors.yellow.shade200;
}


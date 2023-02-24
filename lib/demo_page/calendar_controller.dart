import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' as path;
import 'package:todo_app/model/todo.dart';

class CalendarController extends GetxController {
  static final _singleton = CalendarController._internal();

  factory CalendarController() => _singleton;

  CalendarController._internal();


  final timeController = TextEditingController();



}

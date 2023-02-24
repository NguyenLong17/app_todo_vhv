import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/controller/app_controller.dart';


class HiveManager {
  static final _manager = HiveManager._internal();

  factory HiveManager() => _manager;

  HiveManager._internal();

  final _currentBox = 'config';
   String? timeHive;


  Future init() async {
    await Hive.initFlutter();
    await Hive.openBox(_currentBox);
  }

  Future<dynamic> getValue(String key) async {
    final box = Hive.box(_currentBox);
    final value = box.get(key);
    if (value != null) {

      return jsonDecode(value);

    }
    return null;
  }

  Future<void> setValue(String key, dynamic value) async {
    final box = Hive.box(_currentBox);
    if (value == null) {
      box.put(key, null);
    } else {
      box.put(key, jsonEncode(value));
    }

  }


}

const TodoAppLanguage = 'todoAppLanguage';
const TodoAppTheme = 'TodoAppTheme';


final hive = HiveManager();
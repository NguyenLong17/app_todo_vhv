import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:todo_app/model/todo.dart';

class SembastToDoController extends GetxController {
  static final _singleton = SembastToDoController._internal();

  factory SembastToDoController() => _singleton;

  SembastToDoController._internal();

  RxList<Todo> listToDo = <Todo>[].obs;
  // RxList<Todo> listToDoFilter = <Todo>[].obs;
  // bool onFilter = false;

  final timeController = TextEditingController();


  RxList<Todo> listToDoFilByTime = <Todo>[].obs;
  bool? checkUpdate;

  String dbPath = 'sample.db';
  var store = intMapStoreFactory.store('19');
  DatabaseFactory dbFactory = databaseFactoryIo;

  Future insertTodo({required String time, required String task}) async {
    final Rx<Todo> todo = Rx(Todo(complete: false));
    todo.value.task = task;
    todo.value.time = time;
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    await store.add(db, todo.value.toMap());
    listToDo.insert(0, todo.value);
    SembastToDoController().update();
  }

  Future<RxList<Todo>> getAllTodo() async {
    listToDo.clear();
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');

    final recordSnapshots = await store.find(db);

    listToDo.addAll(recordSnapshots
        .map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo.obs.value;
    })
        .toList()
        .obs);
    SembastToDoController().update();

    return listToDo;
  }

  Future reloadListtodo() async {
    listToDo.clear();
    timeController.text = "";
    getAllTodo();
    SembastToDoController().update();

  }

  Future<List<Todo>> getTodoByTime(BuildContext context) async {
    timeController.text = "";
    DateTime? dateTime;
    final datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (datePick != null && datePick != dateTime) {
      dateTime = datePick;

      timeController.text = DateFormat('dd-MM-yyyy').format(dateTime);
    }

    listToDo.clear();
    Future.delayed(Duration(seconds: 1));
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    final finder = Finder(filter: Filter.equals("time", timeController.text));

    final recordSnapshots = await store.find(
      db,
      finder: finder,
    );

    listToDo.addAll(recordSnapshots
        .map((snapshot) {
          final todo = Todo.fromMap(snapshot.value);
          todo.id = snapshot.key;
          return todo;
        })
        .toList()
        .obs);
    SembastToDoController().update();
    return listToDo;
  }

  Future<Rx<Todo>> getTodoByID(Rx<Todo> todo) async {
    checkUpdate = true;
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    var key = todo.value.id;

    await store.record(key ?? 0).put(db, todo.value.toMap());

    final todoSelect =
        await store.record(key ?? 0).get(db) as Map<String, dynamic>;
    final data = Todo.fromMap(todoSelect);
    SembastToDoController().update();
    return data.obs;
  }

  Future updateTodo({
    required Rx<Todo> todo,
    required String time,
    required String task,
  }) async {
    todo.value.task = task;
    todo.value.time = time;
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');

    final finder = Finder(filter: Filter.byKey(todo.value.id));
    await store.update(
      db,
      todo.value.toMap(),
      finder: finder,
    );

    checkUpdate = false;
    SembastToDoController().update();
  }

  Future completeTodo({
    required Rx<Todo> todo,
  }) async {
    todo.value.complete = !todo.value.complete;
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');

    final finder = Finder(filter: Filter.byKey(todo.value.id));
    await store.update(
      db,
      todo.value.toMap(),
      finder: finder,
    );
    checkUpdate = false;
    // sembastToDoController.update();
    SembastToDoController().update();
  }

  Future deleteTodo(Rx<Todo> todo) async {
    listToDo.remove(todo.value);

    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');

    final finder = Finder(filter: Filter.byKey(todo.value.id));
    await store.delete(
      db,
      finder: finder,
    );
    SembastToDoController().update();
  }
}

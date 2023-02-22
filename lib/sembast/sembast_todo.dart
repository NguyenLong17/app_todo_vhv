import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:todo_app/model/todo.dart';

class SembastToDo {
  static final _singleton = SembastToDo._internal();

  factory SembastToDo() => _singleton;

  SembastToDo._internal();

  int? key;

  List<Todo> listToDo = [];
  bool onFilter = false;
  List<Todo> listToDoFilByTime = [];

  // final todo = Todo();

  String dbPath = 'sample.db';
  var store = intMapStoreFactory.store('16');
  DatabaseFactory dbFactory = databaseFactoryIo;

  Future insert(
      {required Todo todo, required String time, required String task}) async {
    todo.task = task;
    todo.time = time;
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    await store.add(db, todo.toMap());
    listToDo.add(todo);
  }

  Future<List<Todo>> getAllSortedByID() async {
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    final finder = Finder(sortOrders: [
      SortOrder("time"),
    ]);

    final recordSnapshots = await store.find(
      db,
      finder: finder,
    );

    listToDo = recordSnapshots.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
    return listToDo;
  }

  Future<List<Todo>> getByTime(String time) async {
    onFilter = true;
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    final finder = Finder(filter: Filter.equals("time", time));

    final recordSnapshots = await store.find(
      db,
      finder: finder,
    );

    listToDoFilByTime = recordSnapshots.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
    return listToDoFilByTime;
  }

  void reload() {
    onFilter = false;
    getAllSortedByID();
  }

  Future<Todo> getByID(Todo todo) async {
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    final key = todo.id;

    await store.record(key!).put(db, todo.toMap());

    final todoSelect = await store.record(15).get(db) as Map<String, dynamic>;
    final data = Todo.fromMap(todoSelect);
    return data;
  }

  Future update(
      {required Todo todo, required String time, required String task}) async {
    todo.task = task;
    todo.time = time;
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');

    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(
      db,
      todo.toMap(),
      finder: finder,
    );
  }

  Future delete(Todo todo) async {
    final path = await getApplicationDocumentsDirectory();

    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');

    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(
      db,
      finder: finder,
    );
    listToDo.remove(todo);
  }
}

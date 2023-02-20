import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as path;
import 'package:todo_app/model/todo.dart';


class Sembast {
Future create() async {
  // File path to a file in the current directory
  print('Sembast.create');
    String dbPath = 'sample.db';
  DatabaseFactory dbFactory = databaseFactoryIo;

// We use the database factory to open the database
  Database db = await dbFactory.openDatabase(dbPath);

  // dynamically typed store
  var store = StoreRef.main();
// Easy to put/get simple values or map
// A key can be of type int or String and the value can be anything as long as it can
// be properly JSON encoded/decoded
  await store.record('title').put(db, 'Simple application');
  await store.record('version').put(db, 10);
  await store.record('settings').put(db, {'offline': true});

// read values
  var title = await store.record('title').get(db) as String;
  print('Sembast.create: $title');
    var version = await store.record('version').get(db) as int;
  var settings = await store.record('settings').get(db) as Map;

// ...and delete
  await store.record('version').delete(db);
}
}

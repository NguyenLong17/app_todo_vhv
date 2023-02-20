import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class Sembast {
  String dbPath = 'sample.db';
  DatabaseFactory dbFactory = databaseFactoryIo;

 Future<void> createDB() async {


   var dir = await getApplicationDocumentsDirectory();
// make sure it exists
   await dir.create(recursive: true);
// build the database path
   var dbPath = join(dir.path, 'my_database.db');
// open the database
   var db = await databaseFactoryIo.openDatabase(dbPath);

   var store = StoreRef.main();
   await store.record('title').put(db, 'Simple application');
   var title = await store.record('title').get(db) as String;
   // print('Sembast.createDB: $title');
  }

}

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../model/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final List<Todo> listToDo = [];
  String? birthDateInString;
  DateTime? birthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task',
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: false,
                    controller: _dateTimeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'DateTime',
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                    onTap: () {
                      getDateTine();
                    },
                    child: Icon(
                      Icons.calendar_month,
                      size: 64,
                    )),
              ],
            ),
            GestureDetector(
                onTap: () {
                  create();
                },
                child: Container(
                  child: Text('Add'),
                )),
            Expanded(child: buildListToDo()),
          ],
        ),
      ),
    );
  }

  Widget buildListToDo() {
    return ListView.separated(
      itemCount: listToDo.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final todo = listToDo[index];
        return Card(
          child: Row(
            children: [
              Text(
                todo.task,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 16,
              ),
              Text(todo.timeStamp),
            ],
          ),
        );
      },
    );
  }
  Future create() async {
    // File path to a file in the current directory
    print('Sembast.create');
    String dbPath = 'sample.db';
    final path = await getApplicationDocumentsDirectory();
    DatabaseFactory dbFactory = databaseFactoryIo;

// We use the database factory to open the database
    Database db = await dbFactory.openDatabase('${path.path}/$dbPath');
    print('Sembast.create11');

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
  Future addTdo() async {
//     Directory appDocDirectory = await getApplicationDocumentsDirectory();
//
//     Directory(appDocDirectory.path+'/'+'dir').create(recursive: true)
// // The created directory is returned as a Future.
//         .then((Directory directory) {
//       print('Path of New Dir: '+directory.path);
//     });
    setState(() {
      Todo? todo;
      todo?.timeStamp = _dateTimeController.text;
      todo?.isDone = true;
      todo?.task = _taskController.text;
      listToDo.add(todo ??
          Todo(
              task: _taskController.text,
              isDone: true,
              timeStamp: "None"));
    });
  }

  void getDateTine() async {
    final datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (datePick != null && datePick != birthDate) {
      birthDate = datePick;
      birthDateInString =
          "${birthDate?.day}/${birthDate?.month}/${birthDate?.year}";
      _dateTimeController.text = birthDateInString ?? '';
    }
    setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:todo_app/sembast_todo.dart';

import '../model/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = TextEditingController();
  final _dateTimeController = TextEditingController();

  String? dateTimeString;
  DateTime? birthDate;
  final todo = Todo();

  @override
  void initState() {
    SembastToDo().getAllSortedByID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.downloading))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            buildBodyTask(),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      SembastToDo().update(
                          todo: todo,
                          time: _dateTimeController.text,
                          task: _taskController.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 32,
                      width: 64,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.green,
                      )),
                      child: const Text('Add'),
                    )),
                SizedBox(
                  width: 32,
                ),

              ],
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: buildListToDo(SembastToDo().listToDo),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBodyTask() {
    return Column(
      children: [
        TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task',
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                autocorrect: false,
                enableSuggestions: false,
                controller: _dateTimeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'DateTime',
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
                onTap: () {
                  getDateTine();
                },
                child: const Icon(
                  Icons.calendar_month,
                  size: 64,
                )),
          ],
        ),
      ],
    );
  }

  Widget buildListToDo(List items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 16,
      ),
      itemBuilder: (BuildContext context, int index) {
        final todo = items[index];
        return Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      todo.task ?? "",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      todo.time ?? "",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  SembastToDo().getByID(todo).then((todo) {
                    setState(() {
                      print('Task: ${todo.task}');
                      _taskController.text = todo.task ?? "";
                      _dateTimeController.text = todo.time ?? "";
                    });
                  });
                },
                icon: Icon(
                  Icons.settings,
                ),
              ),

              GestureDetector(
                  onTap: () {
                    addToDo();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32,
                    width: 64,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        )),
                    child: const Text('Update'),
                  )),
              SizedBox(width: 8,),
              IconButton(
                onPressed: () {
                  SembastToDo().delete(todo);
                },
                icon: Icon(
                  Icons.delete,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addToDo() {
    SembastToDo().insert(
      todo: todo,
      time: _dateTimeController.text,
      task: _taskController.text,
    );
    setState(() {
      _dateTimeController.text = "";
      _taskController.text = "";
    });
  }

  void updateToDo() {}

  void getDateTine() async {
    final datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (datePick != null && datePick != birthDate) {
      birthDate = datePick;
      dateTimeString =
          "${birthDate?.day}/${birthDate?.month}/${birthDate?.year}";
      _dateTimeController.text = dateTimeString ?? '';
    }
    setState(() {});
  }
}

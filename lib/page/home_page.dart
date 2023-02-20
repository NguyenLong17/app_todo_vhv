import 'package:flutter/material.dart';

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
                  addTdo();
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

  Future addTdo() async {
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

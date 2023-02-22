import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../sembast/sembast_todo.dart';

class TaskPage extends StatefulWidget {
  final Todo todo;

  const TaskPage({super.key, required this.todo});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final taskController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    taskController.text = widget.todo.task ?? "";
    timeController.text = widget.todo.time ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: taskController,
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
                    enableSuggestions: false,
                    readOnly: false,
                    enabled: false,
                    controller: timeController,
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
                      setState(() {
                        showTime(context: context);
                      });
                    },
                    child: const Icon(
                      Icons.calendar_month,
                      size: 64,
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                if (widget.todo == Todo()) {
                  SembastToDo().update(
                      todo: widget.todo,
                      time: timeController.text,
                      task: taskController.text);
                } else {
                  SembastToDo().insert(
                      todo: widget.todo,
                      time: timeController.text,
                      task: taskController.text);
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                "Complete",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.amber),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  void showTime({
    required BuildContext context,
  }) async {
    String? dateTimeString;
    DateTime? dateTime;

    final datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (datePick != null && datePick != dateTime) {
      dateTime = datePick;
      dateTimeString = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      timeController.text = dateTimeString;
    }
  }
}

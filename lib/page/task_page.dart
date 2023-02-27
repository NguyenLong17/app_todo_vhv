import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/sembast_controller.dart';
import 'package:todo_app/generated/l10n.dart';

import '../model/todo.dart';

class TaskPage extends StatefulWidget {
  final Rx<Todo> todo;

  const TaskPage({super.key, required this.todo});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final taskController = TextEditingController();
  final timeController = TextEditingController();

  final SembastToDoController sembastToDoController =
      Get.put(SembastToDoController());

  @override
  void initState() {
    taskController.text = widget.todo.value.task ?? "";
    timeController.text = widget.todo.value.time ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: S.of(context).Task,
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.of(context).DateTime,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                    onTap: () {
                      showTime(context: context);
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
                if (SembastToDoController().checkUpdate == true) {
                  SembastToDoController().updateTodo(
                      todo: widget.todo,
                      time: timeController.text,
                      task: taskController.text);
                } else {
                  SembastToDoController().insertTodo(
                    time: timeController.text,
                    task: taskController.text,
                  );
                }

                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).Complete,
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
      dateTimeString = DateFormat('yyyy-MM-dd').format(dateTime);

      timeController.text = dateTimeString;
    }
  }
}

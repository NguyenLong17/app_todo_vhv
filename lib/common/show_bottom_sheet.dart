import 'package:flutter/material.dart';
import 'package:todo_app/page/task_page.dart';

import '../model/todo.dart';

void showBottomSheetTask({
  required BuildContext context,
  Todo? todo,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        child: TaskPage(
          todo: todo ?? Todo(),
        ),
      );
    },
  );
}

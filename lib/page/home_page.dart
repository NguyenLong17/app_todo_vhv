import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/show_bottom_sheet.dart';
import 'package:todo_app/controller/sembast_controller.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:get/get.dart';

import '../controller/app_controller.dart';
import '../model/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final SembastToDoController sembastToDoController =
      Get.put(SembastToDoController());

  final AppController appStateController = Get.put(AppController());

  @override
  void initState() {
    SembastToDoController().getAllTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
        builder: (_) => Scaffold(
              backgroundColor: appStateController.backgroundColor,
              appBar: AppBar(
                backgroundColor: appStateController.backgroundColor,
                foregroundColor: appStateController.backgroundPrimaryColor,
                title: Text(S.of(context).TodoApp),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.downloading)),
                  IconButton(
                    onPressed: () {
                      appStateController.isDarkMode.value =
                          !appStateController.isDarkMode.value;
                      appStateController.update();
                    },
                    icon: appStateController.isDarkMode.value
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode),
                  ),
                  IconButton(
                    onPressed: () {
                      appStateController.isLanguage.value =
                          !appStateController.isLanguage.value;
                      appStateController.update();
                    },
                    icon: Icon(Icons.language),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: appStateController.backgroundPrimaryColor,
                foregroundColor: appStateController.taskColor,
                onPressed: () {
                  showBottomSheetTask(context: context);
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    searchTodo(),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: buildListToDo(
                        sembastToDoController.listToDo,
                      ),
                    ),
                    SizedBox(
                      height: 72,
                    )
                  ],
                ),
              ),
            ));
  }

  Widget buildListToDo(RxList<Todo> items) {
    return GetBuilder<SembastToDoController>(
      builder: (_) => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 16,
        ),
        itemBuilder: (BuildContext context, int index) {
          final todo = items[index].obs;
          return GestureDetector(
            onTap: () {
              SembastToDoController().getTodoByID(todo);
              showBottomSheetTask(context: context, todo: todo);
            },
            onLongPress: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.only(top: 8),
                      // alignment: Alignment.centerLeft,
                      height: 128,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              SembastToDoController().deleteTodo(todo);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.restore_from_trash_outlined,
                              size: 32,
                            ),
                          ),
                          Text(
                            S.of(context).Delete,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Card(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color:
                  todo.value.complete ? Colors.green : Colors.yellow.shade100,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        sembastToDoController.completeTodo(todo: todo);
                      },
                      icon: todo.value.complete
                          ? Icon(Icons.check_box)
                          : Icon(Icons.square_outlined),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            todo.value.task ?? "",
                            maxLines: 5,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            todo.value.time ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchTodo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: GetBuilder<SembastToDoController>(builder: (_) {
              return TextField(
                style:
                    TextStyle(color: appStateController.backgroundPrimaryColor),
                enableSuggestions: false,
                readOnly: false,
                enabled: false,
                controller: SembastToDoController().timeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: S.of(context).DateTime,
                    labelStyle: TextStyle(
                      color: appStateController.backgroundPrimaryColor,
                    )),
              );
            }),
          ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
              onTap: () {
                // getTime();
                SembastToDoController().getTodoByTime(context);
              },
              child: Icon(
                Icons.calendar_month,
                size: 64,
                color: appStateController.backgroundPrimaryColor,
              )),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              SembastToDoController().reloadListtodo();
            },
            child: Text(
              S.of(context).Cancel,
              style: TextStyle(
                fontSize: 16,
                color: appStateController.backgroundPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future getTime() async {
  //   DateTime? dateTime;
  //   final datePick = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2100));
  //   if (datePick != null && datePick != dateTime) {
  //     dateTime = datePick;
  //
  //     timeController.text = DateFormat('dd-MM-yyyy').format(dateTime);
  //   }
  //   SembastToDoController().getTodoByTime(timeController.text);
  // }
}

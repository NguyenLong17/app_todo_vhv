import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/show_bottom_sheet.dart';
import 'package:todo_app/controller/sembast_controller.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:todo_app/common/hive_manager.dart';

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
    hive.getValue(TodoAppLanguage);
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
                        SembastToDoController().sortByTime();
                      },
                      icon: const Icon(Icons.sort)),
                  IconButton(
                    onPressed: () {
                      appStateController.isDarkMode =
                          !appStateController.isDarkMode;
                      appStateController.update();

                      hive.setValue(
                          TodoAppTheme, appStateController.isDarkMode);
                    },
                    icon: appStateController.isDarkMode
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode),
                  ),
                  IconButton(
                    onPressed: () {
                      appStateController.isLanguage =
                          !appStateController.isLanguage;
                      appStateController.update();
                      hive.setValue(
                          TodoAppLanguage, appStateController.isLanguage);
                    },
                    icon: const Icon(Icons.language),
                  ),
                  Center(
                    child: Text(
                      appStateController.languageApp,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  )
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
                    const SizedBox(
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

          var inputFormat = DateFormat('yyyy-MM-dd');
          var dateInput = inputFormat.parse(todo.value.time ?? '');

          var outputFormat = DateFormat('dd-MM-yyyy');
          var dateOutput = outputFormat.format(dateInput); //

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
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Card(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color:
                  todo.value.complete ? Colors.green : Colors.yellow.shade100,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        sembastToDoController.completeTodo(todo: todo);
                      },
                      icon: todo.value.complete
                          ? const Icon(Icons.check_box)
                          : const Icon(Icons.square_outlined),
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
                            dateOutput,
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
                // enableSuggestions: false,
                readOnly: false,
                enabled: false,
                controller: SembastToDoController().timeController,
                decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(
                          width: 1,
                          color: appStateController.backgroundPrimaryColor),
                    ),
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
              SembastToDoController().reloadListTodo();
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
}

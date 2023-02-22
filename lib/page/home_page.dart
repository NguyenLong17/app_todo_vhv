import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/show_bottom_sheet.dart';
import 'package:todo_app/sembast/sembast_todo.dart';



import '../common/color_app.dart';
import '../model/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _timeController = TextEditingController();

  String? dateTimeString;
  DateTime? dateTime;

  @override
  void initState() {
    SembastToDo().getAllSortedByID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColor.backgroundColor,
        foregroundColor: appColor.backgroundPrimaryColor,
        title: const Text("Todo App"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.downloading)),
          IconButton(
            onPressed: () {
              setState(() {
                appColor.isDarkMode = !appColor.isDarkMode;
              });
            },
            icon: appColor.isDarkMode
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.language),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor.backgroundPrimaryColor,
        foregroundColor: appColor.taskColor,
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
              height: 16,
            ),
            searchTodo(),
            const SizedBox(
              height: 16,
            ),
            if (SembastToDo().onFilter == false) ...{
              Expanded(
                child: buildListToDo(
                  SembastToDo().listToDo,
                ),
              ),
            } else ...{
              Expanded(
                child: buildListToDo(
                  SembastToDo().listToDoFilByTime,
                ),
              ),
            }
          ],
        ),
      ),
    );
  }

  Widget buildListToDo(List<Todo> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 16,
      ),
      itemBuilder: (BuildContext context, int index) {
        final todo = items[index];
        return GestureDetector(
          onTap: () {
            SembastToDo().getByID(todo);
            showBottomSheetTask(context: context, todo: todo);
          },
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.only(top: 8),
                    // alignment: Alignment.centerLeft,
                    height: 100,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            SembastToDo().delete(todo);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.restore_from_trash_outlined,
                            size: 32,
                          ),
                        ),
                        const Text(
                          "Delete",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Card(
            color: Colors.yellow.shade100,


            child: Padding(

              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.square_outlined)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          todo.task ?? "",
                          maxLines: 5,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          todo.time ?? "",
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
    );
  }

  Widget searchTodo() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(color: appColor.backgroundPrimaryColor),
            enableSuggestions: false,
            readOnly: false,
            enabled: false,
            controller: _timeController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DateTime',
                labelStyle: TextStyle(
                  color: appColor.backgroundPrimaryColor,
                )),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                getTime();
              });
            },
            child: Icon(
              Icons.calendar_month,
              size: 64,
              color: appColor.backgroundPrimaryColor,
            )),
        const SizedBox(
          width: 16,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _timeController.text = "";
              SembastToDo().reload();
            });
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              fontSize: 16,
              color: appColor.backgroundPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Future getTime() async {
    final datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (datePick != null && datePick != dateTime) {
      dateTime = datePick;

      // dd-MM-yyyy
      // dateTimeString = DateFormat('dd-MM-yyyy').format(dateTime!);


      //d/M/yyyy or dd/MM/yyyy
      dateTimeString = "${dateTime?.day}/${dateTime?.month}/${dateTime?.year}";
      _timeController.text = dateTimeString ?? "";


      print('_HomePageState.getTime: ${_timeController.text}');
      SembastToDo().getByTime(_timeController.text);
    await  Future.delayed(Duration(seconds: 3));
      setState(() {
      });
    }
  }
}

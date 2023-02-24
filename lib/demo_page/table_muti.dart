import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/controller/sembast_controller.dart';
import 'package:todo_app/model/todo.dart';

class CalendarDemo extends StatefulWidget {
  @override
  _CalendarDemoState createState() => _CalendarDemoState();
}

class _CalendarDemoState extends State<CalendarDemo> {
  late Map<DateTime, List<Todo>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  final SembastToDoController sembastToDoController =
  Get.put(SembastToDoController());

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Todo> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ESTech Calendar"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map(
                (Todo todo) => ListTile(
              title: Card(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color:
                todo.obs.value.complete ? Colors.green : Colors.yellow.shade100,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          sembastToDoController.completeTodo(todo: todo.obs);
                        },
                        icon: todo.obs.value.complete
                            ? Icon(Icons.check_box)
                            : Icon(Icons.square_outlined),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              todo.obs.value.task ?? "",
                              maxLines: 5,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              todo.obs.value.time ?? "",
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Add Event"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  if (_eventController.text.isEmpty) {

                  } else {
                    if (selectedEvents[selectedDay] != null) {
                      selectedEvents[selectedDay]?.add(
                        Todo(task: _eventController.text, complete: false),
                      );
                    } else {
                      selectedEvents[selectedDay] = [
                        Todo(task: _eventController.text, complete: false)
                      ];
                    }

                  }
                  Navigator.pop(context);
                  _eventController.clear();
                  setState((){});
                  return;
                },
              ),
            ],
          ),
        ),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  Todo({
    this.task,
    required this.complete,
    this.showUpdate,
    this.time,
    this.id,
  });

  String? task;
  bool complete = false;
  bool? showUpdate;
  String? time;
  int? id;

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'complete': complete,
      'showUpdate': showUpdate,
      "time": time,
      "id": id,
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      task: map['task'],
      complete: map['complete'],
      showUpdate: map['showUpdate'],
      time: map['time'],
      id: map["id"],
    );
  }




}

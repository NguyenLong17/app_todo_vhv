class Todo {
  Todo({
    this.task,
    this.complete,
    this.time,
    this.id,
  });


  String? task;
  bool? complete;
  String? time;
  int? id;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'task': task,
      'complete': complete,
      "time": time,
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map["id"],
      task: map['task'],
      complete: map['complete'],
      time: map['time'],
    );
  }
}

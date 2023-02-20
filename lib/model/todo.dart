class ToDo {
  final int id;
  final String name;
  final String date;

  ToDo({
    required this.id,
    required this.name,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'date': date};
  }

  factory ToDo.fromMap(int id, Map<String, dynamic> map) {
    return ToDo(
      id: id,
      name: map['name'],
      date: map['date'],
    );
  }

  ToDo copyWith({
    required int id,
    required String name,
    required String date,
  }) {
    return ToDo(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
    );
  }
}

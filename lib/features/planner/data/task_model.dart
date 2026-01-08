class Task {
  final String id;
  final String name;
  final String time;
  final bool isDone;

  const Task({
    required this.id,
    required this.name,
    required this.time,
    this.isDone = false,
  });

  Task copyWith({String? id, String? name, String? time, bool? isDone}) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
    );
  }
}

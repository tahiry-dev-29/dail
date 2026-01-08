class SubTask {
  final String id;
  final String name;
  final bool isDone;

  const SubTask({required this.id, required this.name, this.isDone = false});

  SubTask copyWith({String? id, String? name, bool? isDone}) {
    return SubTask(
      id: id ?? this.id,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
    );
  }
}

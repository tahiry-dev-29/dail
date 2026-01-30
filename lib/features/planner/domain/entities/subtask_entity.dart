class SubTaskEntity {
  final String id;
  final String name;
  final String description;
  final bool isDone;
  final String time;
  final DateTime? deadline;
  final bool isFavorite;

  const SubTaskEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.isDone = false,
    this.time = '00:00',
    this.deadline,
    this.isFavorite = false,
  });

  SubTaskEntity copyWith({
    String? id,
    String? name,
    String? description,
    bool? isDone,
    String? time,
    DateTime? deadline,
    bool? isFavorite,
  }) {
    return SubTaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      time: time ?? this.time,
      deadline: deadline ?? this.deadline,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

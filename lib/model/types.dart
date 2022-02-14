class Todo {
  final String id;
  final String? title;
  final String? memo;

  const Todo({
    required this.id,
    this.title,
    this.memo,
  });

  Todo copy({
    String? id,
    String? title,
    String? memo,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      memo: memo ?? this.memo,
    );
  }

  @override
  String toString() => '$id, $title, $memo';
}

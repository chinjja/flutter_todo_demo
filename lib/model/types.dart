class Todo {
  final String? id;
  final String? title;
  final String? memo;
  final String uid;

  const Todo({
    this.id,
    this.title,
    this.memo,
    required this.uid,
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
      uid: uid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'memo': memo,
    };
  }

  @override
  String toString() => '$id, $title, $memo';
}

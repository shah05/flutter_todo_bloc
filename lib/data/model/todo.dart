class Todo {
  final String id;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;

  Todo(
      {required this.id,
      required this.description,
      required this.createdAt,
      required this.updatedAt,
      required this.isCompleted});

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        description = json['description'],
        isCompleted = json['completed'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']);
}

class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  Task({this.id, required this.title, required this.description, this.isCompleted = false});

  // Convert a task to a map for Hive/Database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Convert a map back into a task object
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

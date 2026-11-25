class TaskModel {
  final int? id; // Unique task ID (null for a new task)
  final String title; // Stores task title
  final String description; // Stores task description
  final String dueDate; // Stores task due date
  final bool isCompleted; // Stores task completion status

  TaskModel({
    this.id, // SQLite generates ID when inserting a task
    required this.title, // Title is compulsory
    required this.description, // Description is compulsory
    required this.dueDate, // Due date is compulsory
    this.isCompleted = false, //New tasks are pending by default
  });

  // Converts Task object into Map for SQLite

  Map<String, dynamic> toMap() {
    return {
      "id": id, // Task ID
      "title": title, // Task title
      "description": description, // Task description
      "dueDate": dueDate, // Task due date
      "isCompleted": isCompleted ? 1 : 0, // Task completion status
    };
  }
  // Converts SQLite Map data back into Task object

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"] as int?, // Reads task ID
      title: map["title"] as String, // Reads task title
      description: map["description"] as String, // Reads task description
      dueDate: map["dueDate"] as String, // Reads task due date
      isCompleted: map["isCompleted"] == 1, // Reads task completion status
    );
  }
}

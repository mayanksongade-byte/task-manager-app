// Imports Flutter's testing tools like test(), group() and expect().
import 'package:flutter_test/flutter_test.dart';

// Imports our TaskModel class so we can create task objects.
import 'package:task_manager/models/task_model.dart';

// Every Dart test starts running from the main() function.
void main() {
  // group() keeps all TaskModel tests together in one group.
  group('TaskModel Tests', () {
    // test() creates one individual test.
    // This test checks whether a new task gets Pending status automatically.
    //Test 1
    test('New task should have Pending status by default', () {
      // Create a new task using our TaskModel class.
      final task = TaskModel(
        // Set the task title.
        title: 'Learn Flutter',

        // Set the task description.
        description: 'Practice Flutter basics',

        // Set the task due date.
        dueDate: '2026-11-30',

        // We don't provide isCompleted.
        // Therefore, the default value from TaskModel should be false.
      );

      // Check whether the task title is correct.
      expect(task.title, 'Learn Flutter');

      // Check whether the task description is correct.
      expect(task.description, 'Practice Flutter basics');

      // Check whether the due date is correct.
      expect(task.dueDate, '2026-11-30');

      // Check whether the new task is Pending (false means not completed).
      expect(task.isCompleted, false);
    });

    // Test 2: Check whether a TaskModel converts into a Map correctly.
    test('Task should convert into a Map correctly', () {
      // Create a sample task.
      final task = TaskModel(
        title: 'Learn Flutter', // Task title.
        description: 'Practice Flutter basics', // Task description.
        dueDate: '2026-11-30', // Task due date.
      );

      // Convert the task object into a Map.
      final taskMap = task.toMap();

      // Check whether the Map contains the correct title.
      expect(taskMap['title'], 'Learn Flutter');

      // Check whether the Map contains the correct description.
      expect(taskMap['description'], 'Practice Flutter basics');

      // Check whether the Map contains the correct due date.
      expect(taskMap['dueDate'], '2026-11-30');

      // SQLite stores false as 0.
      expect(taskMap['isCompleted'], 0);

      // A new task has no database ID yet.
      expect(taskMap['id'], null);
    });

    // Test 3: Check whether a Map converts back into a TaskModel correctly.
    test('Map should convert into a TaskModel correctly', () {
      // Create sample data in Map format, similar to SQLite data.
      final taskMap = {
        'id': 1, // Database task ID.
        'title': 'Learn Dart', // Task title.
        'description': 'Practice Dart programming', // Task description.
        'dueDate': '2026-11-30', // Task due date.
        'isCompleted': 1, // 1 means Completed.
      };

      // Convert the Map into a TaskModel object.
      final task = TaskModel.fromMap(taskMap);

      // Check whether the task ID is correct.
      expect(task.id, 1);

      // Check whether the title is correct.
      expect(task.title, 'Learn Dart');

      // Check whether the description is correct.
      expect(task.description, 'Practice Dart programming');

      // Check whether the due date is correct.
      expect(task.dueDate, '2026-11-30');

      // Check whether 1 was correctly converted into true.
      expect(task.isCompleted, true);
    });
  });
}

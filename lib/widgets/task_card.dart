import 'package:flutter/material.dart';

import '../models/task_model.dart';

// This widget displays one task inside a rounded card.
class TaskCard extends StatelessWidget {
  final TaskModel task;

  // These functions are provided by HomeScreen.
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Get colors from the current app theme.
    final colors = Theme.of(context).colorScheme;

    return Card(
      // Space between task cards.
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      elevation: 2,
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            // Button to mark a task completed or pending.
            IconButton(
              onPressed: onToggle,
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted
                    ? Colors.green
                    : colors.onSurfaceVariant,
                size: 30,
              ),
            ),

            // Task information.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Calendar icon and due date.
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 17,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Due: ${task.dueDate}',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Edit and delete buttons.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, color: colors.primary),
                  tooltip: 'Edit task',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete task',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

# Task Manager App

A simple and user-friendly Task Manager mobile application built with Flutter. It helps users create, organize, update, search, and track their daily tasks.

## Features

- **Task Management:** Add, edit, and delete tasks.
- **Task Status:** Mark tasks as Pending or Completed.
- **Task Filters:** View All, Pending, or Completed tasks.
- **Search:** Search tasks by title.
- **Due Dates:** Select and display task due dates.
- **Local Storage:** Store tasks using SQLite so they remain available after restarting the app.
- **Dark Mode:** Switch between Light Mode and Dark Mode.
- **Theme Persistence:** Remember the selected theme after restarting the app.
- **Validation:** Prevent saving tasks with missing required information.
- **Confirmation:** Ask for confirmation before deleting a task.

## Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language |
| GetX | State management and navigation |
| SQLite | Local task database |
| SharedPreferences | Save theme preference |
| Flutter Test | Unit testing |

## 📁 Project Structure

```text
lib/
│
├── main.dart
│
├── controllers/
│   ├── task_controller.dart
│   └── theme_controller.dart
│
├── database/
│   └── database_helper.dart
│
├── models/
│   └── task_model.dart
│
├── screens/
│   ├── add_edit_task_screen.dart
│   └── home_screen.dart
│
├── utils/
│   └── app_colors.dart
│
└── widgets/
    ├── task_card.dart
    └── task_summary.dart
```

### Architecture

- **Models:** Defines the task data structure.
- **Controllers:** Handles application state and business logic using GetX.
- **Database:** Manages local SQLite storage and CRUD operations.
- **Screens:** Contains the application's main UI screens.
- **Widgets:** Contains reusable UI components.
- **Utils:** Contains shared application colors and styling.

## Installation and Setup

### 1. Clone the repository

```bash
git clone https://github.com/mayanksongade-byte/task-manager-app.git
```

### 2. Open the project folder

```bash
cd task-manager-app
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

## State Management – GetX

This application uses GetX for state management.

The `TaskController` manages task-related operations, including:

- Loading tasks.
- Adding new tasks.
- Updating existing tasks.
- Deleting tasks.
- Changing task status.
- Searching and filtering tasks.

Observable variables (`.obs`) and `Obx()` help update the user interface when the application state changes.

## Local Storage – SQLite

SQLite is used to store task information locally on the device.

The database stores:

- Task ID
- Task title
- Task description
- Due date
- Completion status

The `DatabaseHelper` handles database operations such as inserting, reading, updating, and deleting tasks.

This allows tasks to remain saved even after closing and reopening the application.

## Theme Preference – SharedPreferences

SharedPreferences stores the user's selected theme preference locally.

The application remembers whether the user selected Light Mode or Dark Mode and restores that preference when the application restarts.

## Testing

The project includes three unit tests for the TaskModel:

1. Verify the default task status is Pending.
2. Verify a TaskModel converts into a Map correctly.
3. Verify a Map converts into a TaskModel correctly.

Run the tests using:

```bash
flutter test
```

Check code quality using:

```bash
flutter analyze
```

## AI Tools Used

- ChatGPT – Used for learning, understanding Flutter concepts, debugging assistance, and development guidance.

## Developer

**Mayank Songade**

GitHub: [mayanksongade-byte](https://github.com/mayanksongade-byte)

Repository: [Task Manager App](https://github.com/mayanksongade-byte/task-manager-app)

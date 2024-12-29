import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_helper.dart';
import 'task_model.dart';
import 'preferences_model.dart';

class TaskViewModel extends StateNotifier<List<Task>> {
  TaskViewModel() : super([]);

  // Fetch tasks from the database
  Future<void> fetchTasks() async {
    final tasks = await DatabaseHelper.instance.fetchTasks();
    state = tasks.map((task) => Task.fromMap(task)).toList();
  }

  // Add a task to the database
  Future<void> addTask(Task task) async {
    await DatabaseHelper.instance.insertTask(task.toMap());
    await fetchTasks();
  }

  // Edit an existing task
  Future<void> editTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task.toMap());
    await fetchTasks();
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await fetchTasks();
  }
}

final taskProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel();
});

class PreferencesViewModel extends StateNotifier<Preferences> {
  PreferencesViewModel() : super(Preferences(isDarkMode: false, sortOrder: 'date'));

  // Toggle theme preference
  void toggleTheme() {
    state = Preferences(
      isDarkMode: !state.isDarkMode,
      sortOrder: state.sortOrder,
    );
  }

  // Toggle sort order preference
  void toggleSortOrder() {
    final newSortOrder = state.sortOrder == 'date' ? 'priority' : 'date';
    state = Preferences(isDarkMode: state.isDarkMode, sortOrder: newSortOrder);
  }
}

final preferencesProvider = StateNotifierProvider<PreferencesViewModel, Preferences>((ref) {
  return PreferencesViewModel();
});

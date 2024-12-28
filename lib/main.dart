import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_view_model.dart';
import 'task_model.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('preferences');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

    return MaterialApp(
      title: 'Task Manager',
      theme: preferences.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(taskProvider.notifier).fetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final preferences = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: Icon(preferences.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(preferencesProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: tasks.isEmpty
            ? const Text('No Data')
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        IconButton(
                          icon: Icon(
                            task.isCompleted ? Icons.undo : Icons.check,
                            color: task.isCompleted ? Colors.red : Colors.green,
                          ),
                          onPressed: () {
                            ref.read(taskProvider.notifier).editTask(Task(
                              id: task.id,
                              title: task.title,
                              description: task.description,
                              isCompleted: !task.isCompleted,
                            ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showTaskDialog(task);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref.read(taskProvider.notifier).deleteTask(task.id!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTaskDialog([Task? task]) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Enter Title'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Enter Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newTask = Task(
                  id: task?.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  isCompleted: task?.isCompleted ?? false,
                );
                if (task == null) {
                  ref.read(taskProvider.notifier).addTask(newTask);
                } else {
                  ref.read(taskProvider.notifier).editTask(newTask);
                }
                Navigator.pop(context);
              },
              child: Text(task == null ? 'Add' : 'Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

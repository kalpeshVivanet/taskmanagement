import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskmanagement/views/home_page.dart';
import 'viewmodels/task_view_model.dart';

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
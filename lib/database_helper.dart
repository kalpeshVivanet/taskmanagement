import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  // Insert task
  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  // Fetch all tasks
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  // Update task
  Future<int> updateTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.update('tasks', task, where: 'id = ?', whereArgs: [task['id']]);
  }

  // Delete task
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}

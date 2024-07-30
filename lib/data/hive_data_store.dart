import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/models/task.dart';

/// All the [CRUD] operations methods for HiveDB

class HiveDataStore{
  /// Box name 
  static const boxName = 'taskBox';

  /// Our current Box with all the saved data inside -Box<Task>
  final Box<Task> box = Hive.box<Task>(boxName);

  /// Add a new task to the box
  Future<void> addTask(Task task) async {
    await box.put(task.id, task);
  }
  /// Show Task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  /// Update Task 
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  /// Delete Task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  ///Listen to changes in the box
  ///using this method we can listen to changes in the box
  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}
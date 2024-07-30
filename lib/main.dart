import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/data/hive_data_store.dart';
import 'package:hive_todo/models/task.dart';
import 'package:hive_todo/views/home/home_view.dart';

Future<void> main() async {
  /// Initialize Hive DB before runApp
  await Hive.initFlutter();

  /// Register Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  /// Open Hive Box
  Box box = await Hive.openBox<Task>(HiveDataStore.boxName);

  /// By implementing this line, any task that have been written but not marked as done
  /// within a day will be automatically removed from database the following day
  for (var task in box.values) {
    if (task.createdAtTime.day != DateTime.now().day && task.isDone == false) {
      task.delete();
    } else {
      /// Do nothing
    }
  }

  runApp(BaseWidget(child: const MyApp()));
}

/// The inherited widget provides us with a convenient way to pass data
/// between widgets without having to pass it down the widget tree manually.
class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);

  final HiveDataStore dataStore = HiveDataStore();
  @override
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hive Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 45,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 21,
        ),
        displaySmall: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
        headlineSmall: TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
        titleSmall: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontWeight: FontWeight.w300,
        ),
      )),
      home: const HomeView(),
    );
  }
}

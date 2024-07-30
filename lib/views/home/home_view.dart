import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/extension/space_exs.dart';
import 'package:hive_todo/main.dart';
import 'package:hive_todo/models/task.dart';
import 'package:hive_todo/utils/app_str.dart';
import 'package:hive_todo/utils/constants.dart';
import 'package:hive_todo/views/home/components/task_widget.dart';
import 'package:hive_todo/views/home/widget/fab.dart';
import 'package:hive_todo/views/home/widget/home_app_bar.dart';
import 'package:hive_todo/views/home/widget/slider_drawer.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerkey = GlobalKey<SliderDrawerState>();

  /// Check value of circle Indicator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  /// Check Done Tasks
  int checkDoneTasks(List<Task> task) {
    int i = 0;
    for (Task doneTask in task) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// For sorting tasks by date
          tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

          return Scaffold(
            backgroundColor: Colors.white,
            //FAB
            floatingActionButton: const Fab(),

            //Body
            body: SliderDrawer(
              key: drawerkey,
              isDraggable: false,
              animationDuration: 1000,
              //Drawer
              slider: CustomDrawer(),

              //App Bar
              appBar: HomeAppBar(
                drawerkey: drawerkey,
              ),

              //Main Body
              child: _buildHomeBody(textTheme, base, tasks),
            ),
          );
        });
  }

  //Home Body
  Widget _buildHomeBody(
    TextTheme textTheme,
    BaseWidget base,
    List<Task> tasks,
  ) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          // Custom App Bar
          Container(
            margin: const EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    value: checkDoneTasks(tasks) / valueOfIndicator(tasks),
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.blue,
                    ),
                    color: Colors.white,
                  ),
                ),

                25.w,

                // Top Level Task Info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    3.h,
                    Text("${checkDoneTasks(tasks)} of ${valueOfIndicator(tasks)} task", style: textTheme.titleMedium),
                  ],
                ),
              ],
            ),
          ),

          //Divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          //Tasks
          SizedBox(
            width: double.infinity,
            height: 500,
            child: tasks.isNotEmpty

                // Task list is not empty
                ? ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      /// Get current task
                      var task = tasks[index];
                      return Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (_) {
                            base.dataStore.deleteTask(task: task);
                          },
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              5.w,
                              const Text(
                                AppStr.deletedTask,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          key: Key(task.id),
                          child: TaskWidget(
                            task: task,
                          ));
                    })

                /// Task list is empty
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Lottie Animation
                      FadeIn(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Lottie.asset(
                            lottieURL,
                            animate: tasks.isNotEmpty ? false : true,
                          ),
                        ),
                      ),

                      //Subtext
                      FadeInUp(
                        from: 30,
                        child: const Text(
                          AppStr.doneAllTask,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

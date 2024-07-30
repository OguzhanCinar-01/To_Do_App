import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_todo/main.dart';
import 'package:hive_todo/utils/constants.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerkey});

  final GlobalKey<SliderDrawerState> drawerkey;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animateController;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    animateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    animateController.dispose();
    super.dispose();
  }

  // OnToggle
  void onDrawerToggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        widget.drawerkey.currentState!.openSlider();
        animateController.forward();
      } else {
        animateController.reverse();
        widget.drawerkey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Menu Icon
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: IconButton(
                onPressed: onDrawerToggle,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: animateController,
                  size: 40,
                ),
              ),
            ),

            //Trash Icon
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {
                  base.isEmpty
                      ? noTaskWarning(context)
                      : deleteAllTaskDialog(context);
                },
                icon: const Icon(
                  Icons.delete,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

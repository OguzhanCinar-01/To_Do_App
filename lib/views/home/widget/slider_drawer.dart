import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_todo/extension/space_exs.dart';
import 'package:hive_todo/utils/app_colors.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  // Icons
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];
  // Texts
  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: AppColors.primaryGradientColor,
      )),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://avatars.githubusercontent.com/u/91388754?v=4"),
            radius: 50,
          ),
          8.h,
          Text(
            'Oguzhan ÇINAR',
            style: textTheme.displayMedium,
          ),
          Text('Flutter Developer', style: textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: widget.icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
        
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      leading: Icon(widget.icons[index], color: Colors.white,),
                      title: Text(widget.texts[index],style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

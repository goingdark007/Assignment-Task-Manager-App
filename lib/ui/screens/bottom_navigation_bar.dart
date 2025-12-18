import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/screens/cancelled_task.dart';
import 'package:of9_task_manager/ui/screens/completed_task.dart';
import 'package:of9_task_manager/ui/screens/new_task.dart';
import 'package:of9_task_manager/ui/screens/progress_task.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int selected = 0;

  List<Widget> pages = [
    NewTask(),
    ProgressTask(),
    CompletedTask(),
    CancelledTask(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selected],
      bottomNavigationBar: NavigationBar(

        selectedIndex: selected,

        onDestinationSelected: (index) {
          setState(() {
            selected = index;
          });
        },

        destinations: const [
          NavigationDestination(icon: Icon(Icons.file_copy), label: 'New Task'),
          NavigationDestination(icon: Icon(Icons.refresh), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.done_all), label: 'Completed'),
          NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
        ]
      ),
    );
  }

}
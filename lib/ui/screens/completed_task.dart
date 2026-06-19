import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/widgets/task_list_view.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';
import 'package:provider/provider.dart';

import '../../core/enums/api_state.dart';
import '../../providers/task_provider.dart';

class CompletedTask extends StatefulWidget{

  const CompletedTask ({super.key});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask>{


  Future<void> _loadData() async {

    final TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
    Future.wait([
      taskProvider.getTasksByStatus(status: 'completed')
    ]);

  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Consumer(
        builder: (context, TaskProvider taskProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Visibility(
              visible: taskProvider.taskListState != ApiState.isLoading,
              replacement: Center(child: CircularProgressIndicator()),
              child: TaskListView(
                  taskList: taskProvider.completedTasks,
                  chipColor: Colors.lightGreen,
                  refreshParent: _loadData)
            ),
          );
        }
      )
    );
  }

}
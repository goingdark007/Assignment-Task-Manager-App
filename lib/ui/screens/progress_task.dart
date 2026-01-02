import 'package:flutter/material.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:of9_task_manager/ui/widgets/task_list_view.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';

class ProgressTask extends StatefulWidget {

  const ProgressTask({super.key});

  @override
  State<ProgressTask> createState() => _ProgressTaskState();

}

class _ProgressTaskState extends State<ProgressTask>{



  Future<void> _loadData() async {

    final TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
    Future.wait([
      taskProvider.getTasksByStatus(status: 'progress')
    ]);

  }

  @override
  void initState() {
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
          builder: (context, TaskProvider tasProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Visibility(
                visible: tasProvider.taskListState != ApiState.isLoading,
                replacement: Center(child: CircularProgressIndicator()),
                child: TaskListView(
                    taskList: tasProvider.progressTasks,
                    chipColor: Colors.purple,
                    refreshParent: _loadData
                ),
              ),
            );
          }
        )
    );
  }

}
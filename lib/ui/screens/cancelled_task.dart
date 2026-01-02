import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/widgets/task_list_view.dart';
import 'package:provider/provider.dart';

import '../../core/enums/api_state.dart';
import '../../providers/task_provider.dart';
import '../widgets/tm_app_bar.dart';

class CancelledTask extends StatefulWidget{

  const CancelledTask ({super.key});

  @override
  State<CancelledTask> createState() => _CancelledTaskState();
}

class _CancelledTaskState extends State<CancelledTask>{


  Future<void> _loadData() async {

    final TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
    Future.wait([
      taskProvider.getTasksByStatus(status: 'cancelled')
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
          builder: (context, TaskProvider taskProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Visibility(
                visible: taskProvider.taskListState != ApiState.isLoading,
                replacement: Center(child: CircularProgressIndicator()),
                child: TaskListView(
                    taskList: taskProvider.cancelledTasks,
                    chipColor: Colors.redAccent,
                    refreshParent: _loadData
                )
              ),
            );
          }
        )
    );
  }

}
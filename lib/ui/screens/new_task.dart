import 'package:flutter/material.dart';
import 'package:of9_task_manager/providers/task_provider.dart';
import 'package:of9_task_manager/ui/widgets/task_list_view.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';
import 'package:provider/provider.dart';

import '../../core/enums/api_state.dart';
import '../widgets/task_count_status.dart';

class NewTask extends StatefulWidget {

  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();

}

class _NewTaskState extends State<NewTask>{


  Future<void> _loadData() async {
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
    Future.wait([
      taskProvider.getAllTaskCount(),
      taskProvider.getTasksByStatus(status: 'new')
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
      appBar: const TMAppBar(),
      body: Consumer(
        builder: (context, TaskProvider taskProvider, child) {
          return Column(
            crossAxisAlignment: .center,
            children: [
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                child: SizedBox(
                  height: 90,
                  child: Visibility(
                    visible: taskProvider.taskCountState != ApiState.isLoading,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: .horizontal,
                        itemCount: taskProvider.taskStatusCount.length,
                        itemBuilder: (context, index) =>
                            TaskCountStatus(
                                title: taskProvider.taskStatusCount[index].status,
                                count: taskProvider.taskStatusCount[index].count
                            ),
                        separatorBuilder: (context, index) => const SizedBox(width: 3)
                    ),
                  ),
                ),
              ),

              Expanded(
                  child: Visibility(
                    visible: taskProvider.taskListState != ApiState.isLoading,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: TaskListView(
                        taskList: taskProvider.newTasks,
                        chipColor: Colors.blue,
                        refreshParent: _loadData),
                  )

              )

            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/add_new_task'),
          child: const Icon(Icons.add)
      ),
    );
  }

}

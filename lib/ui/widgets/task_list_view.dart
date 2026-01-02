import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/widgets/task_card.dart';
import 'package:provider/provider.dart';

import '../../data/models/task_model.dart';
import '../../providers/task_card_provider.dart';

class TaskListView extends StatelessWidget{

  final List<TaskModel> taskList;
  final Color chipColor;
  final Future<void> Function() refreshParent;


  const TaskListView({
    super.key,
    required this.taskList,
    required this.chipColor,
    required this.refreshParent
  });

  @override
  Widget build(BuildContext context) {
    return  ListView.separated(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: TaskCardProvider(),
          child: TaskCard(
            taskModel: taskList[index],
            refreshParent: () async {
              await refreshParent();
            },
            chipColor: chipColor,
                ),
        ); },
      separatorBuilder: (context, index) => const SizedBox(height: 4),
    );
  }

}
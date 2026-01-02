import 'package:flutter/material.dart';
import 'package:of9_task_manager/providers/task_card_provider.dart';
import 'package:provider/provider.dart';

import '../../core/enums/api_state.dart';
import '../../data/models/task_model.dart';

class TaskCard extends StatefulWidget {

  final TaskModel taskModel;
  final Color chipColor;
  final VoidCallback refreshParent;

  const TaskCard({
    super.key,
    required this.taskModel,
    required this.chipColor,
    required this.refreshParent
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {


  void statusDialog () {

    final TaskCardProvider taskCardProvider = Provider.of<TaskCardProvider>(context, listen: false);

    taskCardProvider.showChangeStatusDialog(context: context, taskModel: widget.taskModel, refreshParent: widget.refreshParent);

  }



  Future<void> deleteTask() async {

    final TaskCardProvider taskCardProvider = Provider.of<TaskCardProvider>(context, listen: false);

    await taskCardProvider.deleteTask(context: context, taskModel: widget.taskModel, refreshParent: widget.refreshParent);

  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: Colors.white,
          title: Text(widget.taskModel.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18)
          ),
          subtitle: Column(
            crossAxisAlignment: .start,
            children: [
              Text(widget.taskModel.description, style: Theme.of(context).textTheme.bodyMedium),
              Text('Date: ${widget.taskModel.createdData}', style: Theme.of(context).textTheme.bodySmall),
              Consumer(
                builder: (context, TaskCardProvider taskCardProvider, child) {
                  return Row(
                    //mainAxisSize: .min,
                    children: [
                      Chip(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        label: Text(widget.taskModel.status),
                        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                        backgroundColor: widget.chipColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      const Spacer(),
                      Visibility(
                          visible: taskCardProvider.changeTaskStatusState != ApiState.isLoading,
                          replacement: Center(child: CircularProgressIndicator()),
                          child: IconButton(onPressed: statusDialog, icon: Icon(Icons.edit_note_rounded, color: Colors.green,),)),
                      Visibility(
                          visible: taskCardProvider.deleteTaskState != ApiState.isLoading,
                          replacement: Center(child: CircularProgressIndicator()),
                          child: IconButton(onPressed: deleteTask, icon: Icon(Icons.delete, color: Colors.red,),))
                    ],
                  );
                }
              ),

            ],
          ),
        ),
      ),
    );
  }
}
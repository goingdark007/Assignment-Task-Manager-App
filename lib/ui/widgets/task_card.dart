import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import 'custom_snack_bar.dart';

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

  bool _changeStatusInProgress = false;
  bool _deleteLoading = false;

  void showChangeStatusDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: .min,
            children: [
              ListTile(
                onTap: () => changeStatus('New'),
                title: const Text('New'),
                trailing: widget.taskModel.status == 'New' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
              ListTile(
                onTap: () => changeStatus('Progress'),
                title: const Text('Progress'),
                trailing: widget.taskModel.status == 'Progress' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
              ListTile(
                onTap: () => changeStatus('Cancelled'),
                title: const Text('Cancelled'),
                trailing: widget.taskModel.status == 'Cancelled' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
              ListTile(
                onTap: () => changeStatus('Completed'),
                title: const Text('Completed'),
                trailing: widget.taskModel.status == 'Completed' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
            ],
          ),
        )
    );
  }

  Future<void> changeStatus(String status) async {
    setState(() {
      _changeStatusInProgress = true;
    });
    final APIResponse response = await ApiCaller.getRequest(url: Urls.changeStatus(widget.taskModel.id, status));
    setState(() {
      _changeStatusInProgress = false;
    });
    if(response.isSuccess){
      widget.refreshParent();
      if(!mounted) return;
      Navigator.pop(context);
    } else {
      if(!mounted) return;
      showSnackBarMessage(context, response.errorMessage.toString());
    }

  }

  Future<void> deleteTask() async {

    setState(() {
      _deleteLoading = true;
    });

    final APIResponse response = await ApiCaller.getRequest(url: Urls.deleteTaskURL(widget.taskModel.id));

    setState(() {
      _deleteLoading = false;
    });

    if(response.isSuccess){
      widget.refreshParent();
      if(!mounted) return;
      showSnackBarMessage(context, 'Task Deleted Successfully');
    } else {
      if(!mounted) return;
      showSnackBarMessage(context, response.errorMessage.toString());
    }

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
              Row(
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
                      visible: !_changeStatusInProgress,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: IconButton(onPressed: showChangeStatusDialog, icon: Icon(Icons.edit_note_rounded, color: Colors.green,),)),
                  Visibility(
                      visible: !_deleteLoading,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: IconButton(onPressed: deleteTask, icon: Icon(Icons.delete, color: Colors.red,),))
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
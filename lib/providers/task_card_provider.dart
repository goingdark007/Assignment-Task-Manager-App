import 'package:flutter/material.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:of9_task_manager/data/models/task_model.dart';

import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';
import '../ui/widgets/custom_snack_bar.dart';

class TaskCardProvider extends ChangeNotifier{

  ApiState _changeTaskStatusState = ApiState.initial;
  ApiState _deleteTaskState = ApiState.initial;
  String? _errorMessage;


  ApiState get changeTaskStatusState => _changeTaskStatusState;
  ApiState get deleteTaskState => _deleteTaskState;
  String? get errorMessage => _errorMessage;





  void showChangeStatusDialog({required BuildContext context,required TaskModel taskModel, required VoidCallback refreshParent}){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: .min,
            children: [
              ListTile(
                onTap: () => changeStatus('New', taskModel, refreshParent, context),
                title: const Text('New'),
                trailing: taskModel.status == 'New' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
              ListTile(
                onTap: () => changeStatus('Progress', taskModel, refreshParent, context),
                title: const Text('Progress'),
                trailing: taskModel.status == 'Progress' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
              ListTile(
                onTap: () => changeStatus('Cancelled', taskModel, refreshParent, context),
                title: const Text('Cancelled'),
                trailing: taskModel.status == 'Cancelled' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
              ListTile(
                onTap: () => changeStatus('Completed', taskModel, refreshParent, context),
                title: const Text('Completed'),
                trailing: taskModel.status == 'Completed' ? Icon(Icons.check, color: Colors.green,) : null,
              ),
            ],
          ),
        )
    );
  }

  Future<void> changeStatus(String status, TaskModel taskModel, VoidCallback refreshParent, BuildContext context) async {
    _changeTaskStatusState = ApiState.isLoading;

    notifyListeners();

    final APIResponse response = await ApiCaller.getRequest(url: Urls.changeStatus(taskModel.id, status));

    if(response.isSuccess){
      refreshParent();
      _changeTaskStatusState = ApiState.success;
      if(!context.mounted) return;
      Navigator.pop(context);
      notifyListeners();
    } else {

     _changeTaskStatusState = ApiState.error;
     _errorMessage = response.errorMessage;
      notifyListeners();

    }

  }

  Future<void> deleteTask({required BuildContext context,required TaskModel taskModel, required VoidCallback refreshParent}) async {

    _deleteTaskState = ApiState.isLoading;

    notifyListeners();


    final APIResponse response = await ApiCaller.getRequest(url: Urls.deleteTaskURL(taskModel.id));



    if(response.isSuccess){
      _deleteTaskState = ApiState.success;
      refreshParent();
      notifyListeners();
      if(!context.mounted) return;
      showSnackBarMessage(context, 'Task Deleted Successfully');
    } else {
      _deleteTaskState = ApiState.error;
      _errorMessage = response.errorMessage;
      notifyListeners();
      if(!context.mounted) return;
      showSnackBarMessage(context, response.errorMessage.toString());
    }

  }

}
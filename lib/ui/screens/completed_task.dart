import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/widgets/task_card.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/custom_snack_bar.dart';

class CompletedTask extends StatefulWidget{

  const CompletedTask ({super.key});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask>{

  bool _getCompletedTaskProgress = false;
  List<TaskModel> _completedTaskList = [];

  Future<void> _getAllTasks() async {

    setState(() {
      _getCompletedTaskProgress = true;
    });

    final APIResponse response = await ApiCaller.getRequest(url: Urls.completedTaskURL);

    setState(() {
      _getCompletedTaskProgress = false;
    });

    List<TaskModel> taskList = [];

    if(response.isSuccess){

      for(Map<String, dynamic> item in response.body['data']){
        taskList.add(TaskModel.fromJson(item));
      }

    } else {

      if(!mounted) return;
      showSnackBarMessage(context, response.errorMessage.toString());

    }

    _completedTaskList = taskList;

  }

  @override
  void initState(){
    super.initState();
    _getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Visibility(
          visible: !_getCompletedTaskProgress,
          replacement: Center(child: CircularProgressIndicator()),
          child: ListView.separated(
              itemCount: _completedTaskList.length,
              itemBuilder: (context, index) =>
                TaskCard(
                    taskModel: _completedTaskList[index],
                    refreshParent: (){
                      _getAllTasks();
                    },
                    chipColor: Colors.green),
              separatorBuilder: (context, index) => SizedBox(height: 5)
              ),
        ),
      )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:of9_task_manager/data/models/task_model.dart';

import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/task_card.dart';
import '../widgets/tm_app_bar.dart';

class CancelledTask extends StatefulWidget{

  const CancelledTask ({super.key});

  @override
  State<CancelledTask> createState() => _CancelledTaskState();
}

class _CancelledTaskState extends State<CancelledTask>{

  bool _getCancelledTaskProgress = false;
  List<TaskModel> _cancelledTaskList = [];

  Future<void> _getAllTasks() async {

    setState(() {
      _getCancelledTaskProgress = true;
    });

    final APIResponse response = await ApiCaller.getRequest(url: Urls.cancelledTaskURL);

    setState(() {
      _getCancelledTaskProgress = false;
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

    _cancelledTaskList = taskList;

  }

  @override
  void initState() {
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
            visible: !_getCancelledTaskProgress,
            replacement: Center(child: CircularProgressIndicator()),
            child: ListView.separated(
                itemCount: _cancelledTaskList.length,
                itemBuilder: (context, index) =>
                    TaskCard(
                        taskModel: _cancelledTaskList[index],
                        refreshParent: () {
                          _getAllTasks();                      },
                        chipColor: Colors.redAccent),
                separatorBuilder: (context, index) => SizedBox(height: 5)
            ),
          ),
        )
    );
  }

}
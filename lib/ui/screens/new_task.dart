import 'package:flutter/material.dart';
import 'package:of9_task_manager/data/models/task_model.dart';
import 'package:of9_task_manager/data/services/api_caller.dart';
import 'package:of9_task_manager/ui/widgets/custom_snack_bar.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/models/task_status_count_model.dart';
import '../../data/utils/urls.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_status.dart';

class NewTask extends StatefulWidget {

  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();

}

class _NewTaskState extends State<NewTask>{

  bool _getTaskStatusCountProress = false;
  bool _getNewTaskProgress = false;
  List<TaskStatusCountModel> _taskCountList = [];
  List<TaskModel> _newTaskList = [];

  Future<void> _getAllTaskCount() async {
    setState(() {
      _getTaskStatusCountProress = true;
    });

    final APIResponse response = await ApiCaller.getRequest(url: Urls.taskCountURl);

    setState(() {
      _getTaskStatusCountProress = false;
    });

    List<TaskStatusCountModel> countList = [];

    if(response.isSuccess){

      for(Map<String, dynamic> item in response.body['data']){
        countList.add(TaskStatusCountModel.fromJson(item));
      }
      
    } else {
      if(!mounted) return;
      showSnackBarMessage(context, response.errorMessage.toString());
    }

    _taskCountList = countList;
  }

  Future<void> _getAllNewTasks() async {

    setState(() {
      _getNewTaskProgress = true;
    });

    final APIResponse response = await ApiCaller.getRequest(url: Urls.newTaskURL);

    setState(() {
      _getNewTaskProgress = false;
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

    _newTaskList = taskList;

  }

  @override
  void initState() {
    super.initState();
    _getAllTaskCount();
    _getAllNewTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Column(
        crossAxisAlignment: .center,
        children: [
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            child: SizedBox(
              height: 90,
              child: Visibility(
                visible: !_getTaskStatusCountProress,
                replacement: Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: .horizontal,
                    itemCount: _taskCountList.length,
                    itemBuilder: (context, index) =>
                        TaskCountStatus(
                            title: _taskCountList[index].status,
                            count: _taskCountList[index].count
                        ),
                    separatorBuilder: (context, index) => const SizedBox(width: 3)
                ),
              ),
            ),
          ),

          Expanded(
              child: Visibility(
                visible: !_getNewTaskProgress,
                child: ListView.separated(
                    itemCount: _newTaskList.length,
                    itemBuilder: (context, index) => TaskCard(
                        taskModel: _newTaskList[index],
                        refreshParent: () {
                          _getAllNewTasks();
                          _getAllTaskCount();
                        },
                        chipColor: Colors.blue
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                ),
              )
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/add_new_task'),
          child: const Icon(Icons.add)
      ),
    );
  }

}

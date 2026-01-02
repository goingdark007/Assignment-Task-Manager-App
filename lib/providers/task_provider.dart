import 'package:flutter/widgets.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:of9_task_manager/data/models/task_status_count_model.dart';

import '../data/models/task_model.dart';
import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';

class TaskProvider extends ChangeNotifier{

  List<TaskModel> _newTasks = [];
  List<TaskModel> _progressTasks = [];
  List<TaskModel> _completedTasks = [];
  List<TaskModel> _cancelledTasks = [];
  List<TaskStatusCountModel> _taskStatusCount = [];

  ApiState _taskListState = ApiState.initial;
  ApiState _taskCountState = ApiState.initial;
  String? _errorMessage;

  List<TaskModel> get newTasks => _newTasks;
  List<TaskModel> get progressTasks => _progressTasks;
  List<TaskModel> get completedTasks => _completedTasks;
  List<TaskModel> get cancelledTasks => _cancelledTasks;
  List<TaskStatusCountModel> get taskStatusCount => _taskStatusCount;
  ApiState get taskListState => _taskListState;
  ApiState get taskCountState => _taskCountState;
  String? get errorMessage => _errorMessage;

  Future<void> getAllTaskCount() async {

    _taskCountState = ApiState.isLoading;
    notifyListeners();

    final APIResponse response = await ApiCaller.getRequest(url: Urls.taskCountURl);

    List<TaskStatusCountModel> countList = [];

    if(response.isSuccess){

      for(Map<String, dynamic> item in response.body['data']){
        countList.add(TaskStatusCountModel.fromJson(item));
      }
      _taskCountState = ApiState.success;
      _taskStatusCount = countList;

    } else {
      _taskCountState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Failed to Fetch Task Count';
    }

    notifyListeners();

  }

  Future<void> getTasksByStatus ({required String status}) async {

    _taskListState = ApiState.isLoading;
    notifyListeners();

    String url;

    switch (status) {
      case 'new':
        url = Urls.newTaskURL;
      case 'progress':
        url = Urls.progressTaskURL;
      case 'completed':
        url = Urls.completedTaskURL;
      case 'cancelled':
        url = Urls.cancelledTaskURL;
      default:
        url = Urls.newTaskURL;
    }

    final APIResponse response = await ApiCaller.getRequest(url:url);


    List<TaskModel> taskList = [];

    if(response.isSuccess){

      for(Map<String, dynamic> item in response.body['data']){
        taskList.add(TaskModel.fromJson(item));
      }

      switch (status) {
        case 'new':
          _newTasks = taskList;
        case 'progress':
          _progressTasks = taskList;
        case 'completed':
          _completedTasks = taskList;
        case 'cancelled':
          _cancelledTasks = taskList;
        default:
          _newTasks = taskList;
      }
      _taskListState = ApiState.success;

    } else {
      _taskListState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Failed to Fetch Tasks';

    }

    notifyListeners();



  }



}
class Urls {

  static const String _baseURL = 'http://35.73.30.144:2005/api/v1';

  static final String registrationURl = '$_baseURL/registration';
  static final String loginURl = '$_baseURL/login';
  static final String createTaskURl = '$_baseURL/createTask';
  static final String taskCountURl = '$_baseURL/TaskStatusCount';
  static final String newTaskURL = '$_baseURL/listTaskByStatus/New';
  static final String progressTaskURL = '$_baseURL/listTaskByStatus/Progress';
  static final String completedTaskURL = '$_baseURL/listTaskByStatus/Completed';
  static final String cancelledTaskURL = '$_baseURL/listTaskByStatus/Cancelled';
  static String deleteTaskURL (String taskId) => '$_baseURL/deleteTask/$taskId';
  static String changeStatus (String taskId, String status) => '$_baseURL/updateTaskStatus/$taskId/$status';

}
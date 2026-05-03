class Urls {

  static const String _baseURL = 'https://task-manager-api.ostad.live/api/v1'; // http://35.73.30.144:2005/api/v1

  static final String registrationURl = '$_baseURL/Registration';
  static final String loginURl = '$_baseURL/Login';
  static final String createTaskURl = '$_baseURL/createTask';
  static final String taskCountURl = '$_baseURL/taskStatusCount';
  static final String newTaskURL = '$_baseURL/listTaskByStatus/New';
  static final String progressTaskURL = '$_baseURL/listTaskByStatus/Progress';
  static final String completedTaskURL = '$_baseURL/listTaskByStatus/Completed';
  static final String cancelledTaskURL = '$_baseURL/listTaskByStatus/Cancelled';
  static String deleteTaskURL (String taskId) => '$_baseURL/deleteTask/$taskId';
  static final String updateProfile = '$_baseURL/ProfileUpdate';
  static String changeStatus (String taskId, String status) => '$_baseURL/updateTaskStatus/$taskId/$status';

  static String verifyEmailURL(String email) => '$_baseURL/RecoverVerifyEmail/$email';

  static String verifyOtpURL(String email, String otp) => '$_baseURL/RecoverVerifyOTP/$email/$otp';

  static const String resetPasswordURL = '$_baseURL/RecoverResetPassword';

}
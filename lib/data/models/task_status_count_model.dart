class TaskStatusCountModel {

  final String status;
  final int count;

  TaskStatusCountModel({required this.status, required this.count});

  factory TaskStatusCountModel.fromJson(Map<String, dynamic> json) {

    return TaskStatusCountModel(
      status: json['_id'],
      count: json['sum'],
    );

  }

}
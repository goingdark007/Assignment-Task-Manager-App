class UserModel {

  final String id;
  final String email;
  final String mobile;
  final String createdDate;

  const UserModel ({
    required this.id,
    required this.email,
    required this.mobile,
    required this.createdDate
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['_id'],
      email: json['email'],
      mobile: json['mobile'],
      createdDate: json['createdDate'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'mobile': mobile,
      'createdDate': createdDate
    };
  }

}
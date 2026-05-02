import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:of9_task_manager/data/models/user_model.dart';

class AuthState {
  final String? accessToken;
  final UserModel? userModel;
  final String? errorMessage;
  bool get isLoggedIn => accessToken != null;
  final ApiState authState;


  const AuthState ({this.accessToken, this.userModel, this.authState = ApiState.initial,this.errorMessage = 'Something went wrong'});

  AuthState copyWith({
    String? accessToken,
    UserModel? userModel,
    ApiState? authState,
    String? errorMessage,
  }){
    return AuthState(
      accessToken: accessToken ?? this.accessToken,
      userModel: userModel ?? this.userModel,
      authState: authState ?? this.authState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
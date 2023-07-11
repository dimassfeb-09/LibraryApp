part of 'login_bloc.dart';

class LoginState {
  final String email;
  final String password;
  final String errorMsg;

  LoginState({this.email = '', this.password = '', this.errorMsg = ''});

  LoginState copyWith({String? email, String? password, String? errorMsg}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

class LoginLoading extends LoginState {}

class LoginSuccessed extends LoginState {}

class LoginFailed extends LoginState {
  final String errorMsg;
  LoginFailed({required this.errorMsg}) : super(errorMsg: errorMsg);
}

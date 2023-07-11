part of 'register_bloc.dart';

class RegisterState {
  final String name;
  final String email;
  final String password;
  final String errorMsg;

  RegisterState({this.name = '', this.email = '', this.password = '', this.errorMsg = ''});

  RegisterState copyWith({String? name, String? email, String? password}) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMsg: errorMsg,
    );
  }
}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessedState extends RegisterState {}

class RegisterFailedState extends RegisterState {
  final String errorMsg;
  RegisterFailedState({required this.errorMsg}) : super(errorMsg: errorMsg);
}

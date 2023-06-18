part of 'login_bloc.dart';

class LoginState {
  final bool isRememberMe;

  LoginState({this.isRememberMe = false});

  LoginState copyWith({bool? isRememberMe}) {
    return LoginState(isRememberMe: isRememberMe ?? this.isRememberMe);
  }
}

class RememberMeCheckboxState extends LoginState {
  final bool isRememberMe;
  RememberMeCheckboxState({required this.isRememberMe}) : super(isRememberMe: isRememberMe);
}

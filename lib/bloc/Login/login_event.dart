part of 'login_bloc.dart';

class LoginEvent {}

class RememberMeToggleEvent extends LoginEvent {
  RememberMeToggleEvent();
}

class SubmittedLogInEvent extends LoginEvent {}

class EmailLoginEvent extends LoginEvent {
  final String email;
  EmailLoginEvent({required this.email});
}

class PasswordLoginEvent extends LoginEvent {
  final String password;
  PasswordLoginEvent({required this.password});
}

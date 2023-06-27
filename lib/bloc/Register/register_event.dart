part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class NameEvent extends RegisterEvent {
  final String name;

  NameEvent({required this.name});
}

class EmailEvent extends RegisterEvent {
  final String email;

  EmailEvent({required this.email});
}

class PasswordEvent extends RegisterEvent {
  final String password;

  PasswordEvent({required this.password});
}

class SubmittedRegisterEvent extends RegisterEvent {}

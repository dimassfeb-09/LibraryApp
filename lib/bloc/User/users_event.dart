part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetDetailUserEvent extends UsersEvent {}

class ChangeEmailEvent extends UsersEvent {
  final String email;
  ChangeEmailEvent({required this.email});
}

class ChangeEmailSubmittedEvent extends UsersEvent {}

class ChangePasswordEvent extends UsersEvent {
  final String password;
  ChangePasswordEvent({required this.password});
}

class ChangePasswordSubmittedEvent extends UsersEvent {}

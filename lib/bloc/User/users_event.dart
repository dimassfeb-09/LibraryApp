part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetDetailUserEvent extends UsersEvent {}

class ChangeEmailEvent extends UsersEvent {
  final String email;
  ChangeEmailEvent(this.email);
}

class ChangeEmailSubmittedEvent extends UsersEvent {}

class ChangePasswordEvent extends UsersEvent {}

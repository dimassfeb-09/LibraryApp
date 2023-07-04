part of 'users_bloc.dart';

class UsersState {
  Users? users;
  String email;
  String password;

  UsersState({this.users, this.email = '', this.password = ''});

  UsersState copyWith({Users? users, String? email, String? password}) {
    return UsersState(
      users: users,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class GetDetailUserLoadingState extends UsersState {}

class GetDetailUserSuccessedState extends UsersState {
  GetDetailUserSuccessedState({super.users, super.email, super.password});

  GetDetailUserSuccessedState copyWith({Users? users, String? email, String? password}) {
    return GetDetailUserSuccessedState(
      users: users ?? super.users,
      email: email ?? super.email,
      password: password ?? super.password,
    );
  }
}

class GetDetailUserFailedState extends UsersState {}

class ChangeEmailSubmittedLoadingState extends UsersState {}

class ChangeEmailSubmittedSuccessedState extends UsersState {}

class ChangeEmailSubmittedFailedState extends UsersState {}

part of 'users_bloc.dart';

class UsersState {
  Users? users;
  final String email;
  final String password;
  final String errorMsg;

  UsersState(
      {this.users, this.email = '', this.password = '', this.errorMsg = ''});

  UsersState copyWith({Users? users, String? email, String? password}) {
    return UsersState(
      users: users ?? this.users,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMsg: errorMsg ?? '',
    );
  }
}

class GetDetailUserLoadingState extends UsersState {}

class GetDetailUserSuccessedState extends UsersState {
  GetDetailUserSuccessedState({super.users, super.email, super.password});

  GetDetailUserSuccessedState copyWith(
      {Users? users, String? email, String? password}) {
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

class ChangeEmailSubmittedFailedState extends UsersState {
  @override
  final String errorMsg;
  ChangeEmailSubmittedFailedState({this.errorMsg = ''})
      : super(errorMsg: errorMsg);
}

class ChangePasswordSubmittedLoadingState extends UsersState {}

class ChangePasswordSubmittedSuccessedState extends UsersState {}

class ChangePasswordSubmittedFailedState extends UsersState {
  @override
  final String errorMsg;
  ChangePasswordSubmittedFailedState({this.errorMsg = ''})
      : super(errorMsg: errorMsg);
}

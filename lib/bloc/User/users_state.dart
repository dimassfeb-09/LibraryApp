part of 'users_bloc.dart';

class UsersState {
  Users? users;
  UsersState({this.users});

  UsersState copyWith(Users? users) {
    return UsersState(users: users);
  }
}

class GetDetailUserLoadingState extends UsersState {}

class GetDetailUserSuccessedState extends UsersState {
  GetDetailUserSuccessedState({super.users});

  GetDetailUserSuccessedState copyWith(Users? users) {
    return GetDetailUserSuccessedState(users: users ?? super.users);
  }
}

class GetDetailUserFailedState extends UsersState {}

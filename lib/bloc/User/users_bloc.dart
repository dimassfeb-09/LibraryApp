import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_app/repository/UserRepository.dart';
import 'package:meta/meta.dart';

import '../../models/Users.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersState()) {
    on<GetDetailUserEvent>((event, emit) async {
      try {
        emit(GetDetailUserLoadingState());
        UserRepository userRepository = UserRepository();
        Users user = await userRepository.getDetailInfoUser();
        emit(GetDetailUserSuccessedState().copyWith(users: user));
      } catch (e) {
        throw e.toString();
      }
    });

    on<ChangeEmailEvent>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<ChangeEmailSubmittedEvent>((event, emit) async {
      try {
        String email = state.email;
        emit(ChangeEmailSubmittedLoadingState());

        UserRepository userRepository = UserRepository();
        await userRepository.changeEmailUser(email);

        emit(ChangeEmailSubmittedSuccessedState());
      } catch (e) {
        emit(ChangeEmailSubmittedFailedState(errorMsg: e.toString()));
      }
    });

    on<ChangePasswordEvent>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<ChangePasswordSubmittedEvent>((event, emit) async {
      try {
        String password = state.password;
        emit(ChangePasswordSubmittedLoadingState());

        UserRepository userRepository = UserRepository();
        await userRepository.changePasswordUser(password);

        emit(ChangePasswordSubmittedSuccessedState());
      } catch (e) {
        emit(ChangePasswordSubmittedFailedState(errorMsg: e.toString()));
      }
    });
  }
}

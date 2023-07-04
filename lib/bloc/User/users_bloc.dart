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
        emit(ChangeEmailSubmittedLoadingState());

        UserRepository userRepository = UserRepository();
        await userRepository.changeEmailUser(state.email);

        emit(ChangeEmailSubmittedSuccessedState());
      } catch (e) {
        emit(ChangeEmailSubmittedFailedState());
      }
    });
  }
}

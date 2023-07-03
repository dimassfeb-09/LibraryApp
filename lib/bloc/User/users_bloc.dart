import 'package:bloc/bloc.dart';
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
        emit(GetDetailUserSuccessedState().copyWith(user));
      } catch (e) {
        throw e.toString();
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<RememberMeToggleEvent>(_rememberMeToggle);
  }

  void _rememberMeToggle(RememberMeToggleEvent event, Emitter<LoginState> emit) {
    print(state.isRememberMe);
    emit(state.copyWith(isRememberMe: state.isRememberMe ? false : true));
  }
}

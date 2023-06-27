import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/repository/AuthRepository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<SubmittedLogInEvent>(_submitLogInClicked);
    on<EmailLoginEvent>(_emailEvent);
    on<PasswordLoginEvent>(_passwordEvent);
  }

  void _submitLogInClicked(SubmittedLogInEvent event, Emitter<LoginState> emit) async {
    AuthRepository authRepository = AuthRepository();
    try {
      await authRepository.LoginAuth(email: state.email, password: state.password);
      return emit(LoginSuccessed());
    } catch (e) {
      emit(state.copyWith(email: '', password: ''));
      return emit(LoginFailed(errorMsg: e.toString()));
    }
  }

  void _emailEvent(EmailLoginEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordEvent(PasswordLoginEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }
}

import 'package:bloc/bloc.dart';
import 'package:library_app/repository/AuthRepository.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState()) {
    on<NameEvent>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<EmailEvent>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordEvent>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SubmittedRegisterEvent>((event, emit) async {
      AuthRepository authRepository = AuthRepository();
      try {
        String _name = state.name;
        String _email = state.email;
        String _password = state.password;
        emit(RegisterLoadingState());

        await authRepository.RegisterAuth(name: _name, email: _email, password: _password);

        emit(RegisterSuccessedState());
      } catch (e) {
        emit(RegisterFailedState(errorMsg: e.toString()));
      }
    });
  }
}

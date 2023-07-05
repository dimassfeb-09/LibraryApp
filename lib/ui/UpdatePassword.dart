import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';

import '../bloc/User/users_bloc.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../repository/AuthRepository.dart';

class UpdatePasswordPage extends StatelessWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UsersBloc usersBloc = context.read<UsersBloc>();

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleCustom(title: "Ubah Kata Sandi"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocListener<UsersBloc, UsersState>(
              bloc: usersBloc,
              listener: (_, state) {
                if (state is ChangePasswordSubmittedFailedState) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Failed to update email."),
                      content: Text(state.errorMsg),
                    ),
                  );
                }

                if (state is ChangePasswordSubmittedSuccessedState) {
                  AuthRepository authRepository = AuthRepository();
                  authRepository.logoutAuth();
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text("Berhasil update kata sandi."),
                      content: Text(
                          "Akan dialihkan ke halaman masuk dalam 2 detik.."),
                    ),
                  );

                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  });
                }
              },
              child: TextFieldCustom(
                controller:
                    TextEditingController(text: usersBloc.state.password),
                hintText: "Masukkan password baru",
                onChanged: (value) =>
                    usersBloc..add(ChangePasswordEvent(password: value)),
              ),
            ),
            const SizedBox(height: 20),
            ButtonCustom(
              width: 130,
              title: "Ubah Kata Sandi",
              onTap: () => usersBloc.add(ChangePasswordSubmittedEvent()),
            ),
          ],
        ),
      ),
    );
  }
}

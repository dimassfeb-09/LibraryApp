import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/bloc/User/users_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/button.dart';
import 'package:library_app/components/text_field.dart';
import 'package:library_app/repository/AuthRepository.dart';

class UpdateEmailPage extends StatelessWidget {
  const UpdateEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UsersBloc usersBloc = context.read<UsersBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Ubah Email"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocListener<UsersBloc, UsersState>(
              bloc: usersBloc,
              listener: (_, state) {
                if (state is ChangeEmailSubmittedFailedState) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Failed to update email."),
                      content: Text(state.errorMsg),
                    ),
                  );
                }

                if (state is ChangeEmailSubmittedSuccessedState) {
                  AuthRepository authRepository = AuthRepository();
                  authRepository.logoutAuth();
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text("Berhasil update email."),
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
                controller: TextEditingController(text: usersBloc.state.email),
                hintText: "Masukkan email baru",
                onChanged: (value) =>
                    usersBloc..add(ChangeEmailEvent(email: value)),
              ),
            ),
            const SizedBox(height: 20),
            ButtonCustom(
              title: "Ubah Email",
              onTap: () => usersBloc.add(ChangeEmailSubmittedEvent()),
            ),
          ],
        ),
      ),
    );
  }
}

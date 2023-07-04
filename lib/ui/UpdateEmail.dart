import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/text_field.dart';

import '../bloc/User/users_bloc.dart';

class UpdateEmailPage extends StatelessWidget {
  const UpdateEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleCustom(title: "Ubah Email"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return TextFieldCustom(
                hintText: "Masukkan Email Baru",
                onChanged: (value) {
                  context.read<UsersBloc>().add(ChangeEmailEvent(value));
                },
                controller: TextEditingController(),
              );
            },
          )
        ],
      ),
    );
  }
}

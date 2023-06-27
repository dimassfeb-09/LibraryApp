import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/button.dart';
import 'package:library_app/components/image.dart';
import 'package:library_app/components/text_field.dart';

import '../bloc/Login/login_bloc.dart';
import '../bloc/Register/register_bloc.dart';
import 'Register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LoginBloc loginBloc = context.read<LoginBloc>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.only(top: 70, left: 50, right: 50),
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                const Text(
                  "Masuk",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                const ImageCustom(),
                const SizedBox(height: 30),
                TextFieldCustom(
                  controller: TextEditingController(text: loginBloc.state.email),
                  title: "Email",
                  hintText: "Masukkan email anda",
                  onChanged: (value) => loginBloc..add(EmailLoginEvent(email: value)),
                  type: InputType.email,
                ),
                const SizedBox(height: 20),
                TextFieldCustom(
                  controller: TextEditingController(text: loginBloc.state.password),
                  title: "Kata Sandi",
                  hintText: "Masukkan kata sandi anda",
                  secureText: true,
                  type: InputType.password,
                  onChanged: (value) => loginBloc..add(PasswordLoginEvent(password: value)),
                ),
                const SizedBox(height: 25),
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccessed) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    } else if (state is LoginFailed) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Failed to login."),
                          content: Text(state.errorMsg),
                        ),
                      );
                    }
                  },
                  child: ButtonCustom(
                    title: "Masuk",
                    onTap: () {
                      loginBloc.add(SubmittedLogInEvent());
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text("Belum mempunyai akun My Library App?"),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => RegisterBloc(),
                            child: RegisterPage(),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

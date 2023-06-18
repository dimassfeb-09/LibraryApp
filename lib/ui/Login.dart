import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/button.dart';
import 'package:library_app/components/image.dart';
import 'package:library_app/components/text_field.dart';
import 'package:library_app/ui/ForgotPassword.dart';

import '../bloc/Login/login_bloc.dart';
import 'Register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    LoginBloc loginBloc = LoginBloc();

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
                TextFieldCustom(title: "Email", hintText: "Masukkan email anda", type: InputType.email),
                const SizedBox(height: 20),
                TextFieldCustom(
                  title: "Kata Sandi",
                  hintText: "Masukkan kata sandi anda",
                  secureText: true,
                  type: InputType.password,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => loginBloc..add(RememberMeToggleEvent()),
                      child: BlocBuilder<LoginBloc, LoginState>(
                        bloc: loginBloc,
                        builder: (context, state) => Row(
                          children: [
                            Icon(loginBloc.state.isRememberMe ? Icons.check_box : Icons.check_box_outline_blank),
                            const SizedBox(width: 5),
                            const Text("Ingat saya")
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage())),
                      child: const Text(
                        "Lupa kata sandi?",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const ButtonCustom(title: "Masuk"),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text("Belum mempunyai akun My Library App?"),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
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

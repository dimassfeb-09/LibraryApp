import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/button.dart';
import 'package:library_app/components/text_field.dart';
import 'package:library_app/ui/Login.dart';

import '../bloc/Register/register_bloc.dart';
import '../components/image.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    RegisterBloc registerBloc = context.read<RegisterBloc>();
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
                  "Daftar",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const ImageCustom(),
                TextFieldCustom(
                  controller:
                      TextEditingController(text: registerBloc.state.name),
                  title: "Nama",
                  hintText: "Masukkan nama anda",
                  onChanged: (value) =>
                      context.read<RegisterBloc>()..add(NameEvent(name: value)),
                ),
                const SizedBox(height: 20),
                TextFieldCustom(
                  controller:
                      TextEditingController(text: registerBloc.state.email),
                  title: "Email",
                  hintText: "Masukkan email anda",
                  onChanged: (value) => context.read<RegisterBloc>()
                    ..add(EmailEvent(email: value)),
                ),
                const SizedBox(height: 20),
                TextFieldCustom(
                  controller:
                      TextEditingController(text: registerBloc.state.password),
                  title: "Password",
                  hintText: "Masukkan password anda",
                  secureText: true,
                  type: InputType.password,
                  onChanged: (value) => context.read<RegisterBloc>()
                    ..add(PasswordEvent(password: value)),
                ),
                const SizedBox(height: 25),
                BlocListener<RegisterBloc, RegisterState>(
                  bloc: registerBloc,
                  listener: (context, state) {
                    if (state is RegisterSuccessed) {
                      Navigator.pop(
                        context,
                      );
                    } else if (state is RegisterFailed) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Failed to register."),
                          content: Text(state.errorMsg),
                        ),
                      );
                    }
                  },
                  child: ButtonCustom(
                    title: "Register",
                    onTap: () {
                      registerBloc.add(SubmittedRegisterEvent());
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text("Sudah mempunyai akun My Library App?"),
                    GestureDetector(
                      onTap: () => Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                      child: const Text(
                        "Login",
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

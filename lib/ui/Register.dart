import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/button.dart';
import 'package:library_app/components/loading.dart';
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
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                    left: -127,
                    top: 550,
                    child: Container(
                        height: 517.33,
                        width: 654.91,
                        child: Image.asset("assets/img/Waves.png"))),
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      const Text(
                        "Daftar",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const ImageCustom(),
                      TextFieldCustom(
                        controller: TextEditingController(
                            text: registerBloc.state.name),
                        title: "Nama",
                        hintText: "Masukkan nama anda",
                        onChanged: (value) => context.read<RegisterBloc>()
                          ..add(NameEvent(name: value)),
                      ),
                      const SizedBox(height: 20),
                      TextFieldCustom(
                        controller: TextEditingController(
                            text: registerBloc.state.email),
                        title: "Email",
                        hintText: "Masukkan email anda",
                        onChanged: (value) => context.read<RegisterBloc>()
                          ..add(EmailEvent(email: value)),
                      ),
                      const SizedBox(height: 20),
                      TextFieldCustom(
                        controller: TextEditingController(
                            text: registerBloc.state.password),
                        title: "Password",
                        hintText: "Masukkan password anda",
                        secureText: true,
                        type: InputType.password,
                        onChanged: (value) => context.read<RegisterBloc>()
                          ..add(PasswordEvent(password: value)),
                      ),
                      const SizedBox(height: 25),
                      BlocConsumer<RegisterBloc, RegisterState>(
                        bloc: registerBloc,
                        listener: (context, state) {
                          if (state is RegisterLoadingState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Sedang proses...")));
                          }

                          if (state is RegisterSuccessedState) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Berhasil daftar...")));
                          }

                          if (state is RegisterFailedState) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Gagal daftar."),
                                content: Text(state.errorMsg),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is RegisterLoadingState) {
                            return Container(
                              height: 48,
                              width: 98,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child: loadingCircularProgressIndicator()),
                            );
                          }

                          return ButtonCustom(
                            height: 48,
                            title: "Daftar",
                            onTap: () {
                              registerBloc.add(SubmittedRegisterEvent());
                            },
                          );
                        },
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
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

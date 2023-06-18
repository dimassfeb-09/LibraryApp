import 'package:flutter/material.dart';
import 'package:library_app/components/button.dart';
import 'package:library_app/components/text_field.dart';
import 'package:library_app/ui/Login.dart';

import '../components/image.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                TextFieldCustom(title: "Nama", hintText: "Masukkan nama anda"),
                const SizedBox(height: 20),
                TextFieldCustom(title: "Email", hintText: "Masukkan email anda"),
                const SizedBox(height: 20),
                TextFieldCustom(
                    title: "Password", hintText: "Masukkan password anda", secureText: true, type: InputType.password),
                const SizedBox(height: 25),
                const ButtonCustom(title: "Register"),
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

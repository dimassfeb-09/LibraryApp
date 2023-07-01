import 'package:flutter/material.dart';
import 'package:library_app/components/button.dart';
import 'package:lottie/lottie.dart';

class SuccessOrderPage extends StatelessWidget {
  const SuccessOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF27374D),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("assets/lottie/order-success.json"),
              const Text(
                "Berhasil Pinjam",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonCustom(
                    title: "Beranda",
                    border: Border.all(color: Colors.white),
                    fontTextColor: Colors.white,
                    width: 129,
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                  ),
                  ButtonCustom(
                    title: "Pesanan Saya",
                    border: Border.all(color: Colors.white),
                    fontTextColor: Colors.white,
                    width: 129,
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

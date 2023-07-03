import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyLottie extends StatelessWidget {
  EmptyLottie({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/empty-cart.json"),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
    ;
  }
}

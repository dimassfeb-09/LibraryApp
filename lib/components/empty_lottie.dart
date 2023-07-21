import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum LottieType {EmptyCart, NotFound}

class EmptyLottie extends StatelessWidget {
  EmptyLottie({super.key, required this.title, this.type = LottieType.EmptyCart});
  final String title;
  final LottieType type;

  Widget _lottieType() {
    switch (type){
      case LottieType.EmptyCart:
        return Lottie.asset("assets/lottie/empty-cart.json");
      case LottieType.NotFound:
        return Lottie.asset("assets/lottie/notfound_search.json");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _lottieType(),
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

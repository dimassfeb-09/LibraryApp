import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final String title;

  const ButtonCustom({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("clicked");
      },
      child: Container(
        height: 37,
        width: 98,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF27374D),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}

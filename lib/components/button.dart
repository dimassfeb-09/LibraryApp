import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final String title;
  final double width, height;
  final void Function()? onTap;

  const ButtonCustom({super.key, this.width = 98, this.height = 37, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
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

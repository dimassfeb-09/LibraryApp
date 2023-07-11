import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final String title;
  final Color? fontTextColor;
  final double width, height;
  final BoxBorder? border;
  final Color? color;
  final IconData? icons;
  final void Function()? onTap;

  const ButtonCustom({
    super.key,
    this.width = 98,
    this.height = 37,
    required this.title,
    this.fontTextColor = Colors.white,
    this.border,
    this.icons,
    this.color = const Color(0xFF27374D),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: border,
        ),
        child: title != ''
            ? Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: fontTextColor),
              )
            : Icon(
                icons,
                color: Colors.white,
                size: 25,
              ),
      ),
    );
  }
}

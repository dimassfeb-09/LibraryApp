import 'package:flutter/material.dart';

class AppBarTitleCustom extends StatelessWidget {
  final String title;

  const AppBarTitleCustom({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }
}

import 'package:flutter/material.dart';

class ImageCustom extends StatelessWidget {
  const ImageCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage("assets/img/books.png"),
      height: 202,
      width: 202,
    );
  }
}

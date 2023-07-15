import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum Shadow { none, medium, bold }

enum BorderSize { none, medium, bold }

class CardBook extends StatelessWidget {
  final double height;
  final double width;
  final double radiusSize;
  final EdgeInsetsGeometry margin;
  final String imagePath;
  final Shadow shadow;
  final BorderSize border;

  const CardBook({
    super.key,
    this.height = 300,
    this.width = 200,
    required this.imagePath,
    this.margin = EdgeInsets.zero,
    this.shadow = Shadow.none,
    this.radiusSize = 10,
    this.border = BorderSize.none,
  });

  BoxShadow isShadow() {
    if (shadow == Shadow.medium) {
      return BoxShadow(offset: const Offset(1, 1), color: Colors.black.withOpacity(0.25), blurRadius: 2);
    }

    if (shadow == Shadow.bold) {
      return BoxShadow(offset: const Offset(1, 1), color: Colors.black.withOpacity(0.5), blurRadius: 2);
    }

    return const BoxShadow(
      offset: Offset.zero,
      color: Colors.transparent,
      blurRadius: 0,
    );
  }

  Border isBorder() {
    if (border == BorderSize.medium) {
      return Border.all(width: 1, color: Colors.black.withOpacity(0.25), style: BorderStyle.solid);
    }

    if (border == BorderSize.bold) {
      return Border.all(width: 1, color: Colors.black.withOpacity(0.5), style: BorderStyle.solid);
    }

    return Border.all(width: 0, color: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radiusSize),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imagePath),
          fit: BoxFit.cover,
        ),
        border: isBorder(),
        boxShadow: [isShadow()],
      ),
    );
  }
}

import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

class StatusCard extends StatelessWidget {
  final String status;

  const StatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 80,
      decoration: BoxDecoration(
        color: _colors(),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        status.toCapitalized(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  Color? _colors() {
    switch (status) {
      case "pending":
        return const Color(0xFFFFE6A5);
      case "completed":
        return const Color(0xFF78FF96);
      case "return":
        return const Color(0xFFED8080);
    }
    return null;
  }
}

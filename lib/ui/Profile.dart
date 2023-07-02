import 'package:flutter/material.dart';
import 'package:library_app/components/app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleCustom(title: "Menu"),
        centerTitle: true,
      ),
    );
  }
}

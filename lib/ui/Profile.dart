import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/ui/UpdateEmail.dart';

import '../bloc/User/users_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleCustom(title: "Profile"),
        centerTitle: true,
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        bloc: context.read<UsersBloc>(),
        builder: (context, state) {
          return Column(
            children: [
              Center(
                child: Container(
                  height: 127,
                  width: 127,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.person, size: 82),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    state.users!.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    state.users!.email,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Settings", textAlign: TextAlign.end),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/edit_email'),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    "Ubah Email",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/edit_password'),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    "Ubah Kata Sandi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

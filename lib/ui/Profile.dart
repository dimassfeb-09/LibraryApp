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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    state.users!.email,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UpdateEmailPage(),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  child: Text("Ubah Email"),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                child: Text("Ubah Kata Sandi"),
              ),
            ],
          );
        },
      ),
    );
  }
}

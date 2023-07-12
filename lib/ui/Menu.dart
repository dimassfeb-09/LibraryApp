import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/loading.dart';
import 'package:library_app/helpers/users.dart';
import 'package:library_app/repository/AuthRepository.dart';
import 'package:library_app/ui/Profile.dart';

import '../bloc/User/users_bloc.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    UsersHelper usersHelper = UsersHelper();

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleCustom(title: "Menu"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
            width: double.infinity,
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is GetDetailUserLoadingState) {
                  return loadingCircularProgressIndicator();
                }

                if (state is GetDetailUserSuccessedState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Center(
                              child: Icon(Icons.person),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.users!.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  state.users!.email,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          var usersBloc = context.read<UsersBloc>();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: usersBloc,
                                child: const ProfilePage(),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(color: Color(0xFF0591F6), fontSize: 14),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Aktivitas Saya",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/history_orders'),
                  child: Container(
                    color: Colors.transparent,
                    child: const Row(
                      children: [
                        Icon(Icons.history),
                        const SizedBox(width: 15),
                        Text("Riwayat Pinjam"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/checkouts'),
                  child: Container(
                    color: Colors.transparent,
                    child: const Row(
                      children: [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 15),
                        Text("Keranjang"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/favorite'),
                  child: Container(
                    color: Colors.transparent,
                    child: const Row(
                      children: [
                        Icon(Icons.favorite),
                        SizedBox(width: 15),
                        Text("Favorite"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lainnya",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    AuthRepository authRepository = AuthRepository();
                    authRepository.logoutAuth();

                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        const SizedBox(width: 15),
                        Text("Keluar Akun"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}

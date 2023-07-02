import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/ui/SuccessOrder.dart';

import '../bloc/Order/order_bloc.dart';
import '../components/button.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Pinjam Buku"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Text("Buku yang dipinjam",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<OrderBloc, OrderState>(
                bloc: context.watch<OrderBloc>(),
                builder: (context, state) {
                  print(state);
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.books.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.books[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                                Text(
                                  state.books[index].writer,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Text("1x"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF27374D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Keterangan Peminjaman Buku",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text:
                          """1. Hanya dapat meminjam satu buku dengan judul yang sama
2. Jadwal dan Lokasi pengambilan buku akan diinformasikan
3. Jadwal dan Lokasi pengembalian buku akan diinformasikan
4. Batas pengambilan buku h+3 setelah jadwal ditentukan
5. Batas pengembalian buku h+3 setelah jadwal ditentukan
                  """,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.5)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BORROW
            BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is AddOrderCheckoutsFailedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMsg)),
                  );
                }

                if (state is AddOrderCheckoutsSuccessedState) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => SuccessOrderPage(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: ButtonCustom(
                title: "KONFIRMASI PINJAM",
                width: 165,
                height: 35,
                onTap: () {
                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                  OrderBloc orderBloc = context.read<OrderBloc>();
                  orderBloc.add(AddOrderSubmittedEvent(
                    books: orderBloc.state.books,
                    userID: firebaseAuth.currentUser!.uid,
                  ));
                },
              ),
            ),
            const SizedBox(width: 12),
            // ADD CHECKOUT
          ],
        ),
      ),
    );
  }
}

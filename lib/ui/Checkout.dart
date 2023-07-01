import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/loading.dart';
import 'package:lottie/lottie.dart';

import '../bloc/Book/book_bloc.dart';
import '../bloc/Checkout/checkout_bloc.dart';
import '../bloc/Order/order_bloc.dart';
import '../components/button.dart';
import 'DetailBook.dart';
import 'Order.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Keranjang"),
        centerTitle: true,
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is GetCheckoutUserLoadingState || state is DeleteCheckoutLoadingState) {
            return loadingCircularProgressIndicator();
          } else if (state is GetCheckoutUserSuccessedState || state is DeleteCheckoutSuccessedState) {
            if (state.checkouts.isNotEmpty) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Builder(
                      builder: (context) {
                        var isStockZero = state.checkouts.where((element) => element.book!.stock == 0);
                        if (isStockZero.isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Terdapat ${isStockZero.length} buku dengan stok kosong.",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Text("Buku otomatis tidak akan masuk ke dalam peminjaman.",
                                    style: TextStyle(fontSize: 12))
                              ],
                            ),
                          );
                        }

                        return SizedBox();
                      },
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      itemCount: state.checkouts.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          BookBloc()..add(GetDetailBookEvent(id: state.checkouts[index].book!.id)),
                                    ),
                                    BlocProvider(
                                      create: (context) => CheckoutBloc()
                                        ..add(GetCheckoutBookByUserIDEvent(
                                            userID: firebaseAuth.currentUser!.uid,
                                            bookID: state.checkouts[index].book!.id)),
                                    ),
                                  ],
                                  child: DetailBookPage(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
                            height: 116,
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Container(
                                  height: 116,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(state.checkouts[index].book!.imagePath),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        offset: const Offset(0, 4),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.checkouts[index].book!.title,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(state.checkouts[index].book!.writer,
                                              style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      Text("Stok: ${state.checkouts[index].book!.stock}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  state.checkouts[index].book!.stock <= 0 ? Colors.red : Colors.black)),
                                      Builder(builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            print(context.read<CheckoutBloc>().state.checkouts[index].id);
                                            context.read<CheckoutBloc>().add(DeleteCheckoutEvent(
                                                checkoutID: state.checkouts[index].id,
                                                bookID: state.checkouts[index].book!.id));
                                          },
                                          child: Icon(Icons.delete),
                                        );
                                      }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/lottie/empty-cart.json"),
                    const SizedBox(height: 20),
                    const Text(
                      "Keranjang Kosong...",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state.checkouts.isEmpty) {
            return SizedBox();
          }
          return Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.black.withOpacity(0.5)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // BORROW
                const SizedBox(height: 5),
                ButtonCustom(
                  title: "PINJAM SEKARANG",
                  width: 165,
                  height: 35,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => OrderBloc()..add(AddOrderCheckoutEvent(checkouts: state.checkouts)),
                          child: const OrderPage(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

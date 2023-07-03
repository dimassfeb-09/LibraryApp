import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/bloc/Order/order_bloc.dart';
import 'package:library_app/components/button.dart';
import 'package:library_app/components/loading.dart';

import '../bloc/Book/book_bloc.dart';
import '../bloc/Checkout/checkout_bloc.dart';
import '../components/app_bar.dart';
import 'Order.dart';

class DetailBookPage extends StatelessWidget {
  DetailBookPage({super.key});

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      bloc: context.read<BookBloc>(),
      builder: (context, state) {
        if (state is GetDetailBookLoadingState) {
          return Scaffold(
            appBar: AppBar(title: const AppBarTitleCustom(title: '')),
            body: loadingCircularProgressIndicator(),
          );
        } else if (state is GetDetailBookSuccessedState) {
          return Scaffold(
            appBar: AppBar(
              title: Builder(builder: (context) {
                return AppBarTitleCustom(title: context.watch<BookBloc>().state.detailBook?.title ?? '');
              }),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(state.detailBook!.imagePath),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1, 1),
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.detailBook!.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    state.detailBook!.writer,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardDetailInformationBook(title: 'Halaman', data: state.detailBook!.page.toString()),
                      const SizedBox(width: 20),
                      CardDetailInformationBook(title: 'Bahasa', data: state.detailBook!.language),
                      const SizedBox(width: 20),
                      CardDetailInformationBook(title: 'Terbit', data: state.detailBook!.publish),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stok ${state.detailBook!.stock <= 5 ? "Tersisa" : "Tersedia"}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.detailBook!.stock.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Deskripsi",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.detailBook!.description,
                          textAlign: TextAlign.justify,
                          maxLines: 10,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  Builder(
                    builder: (context) {
                      BookBloc bookBloc = context.read<BookBloc>();
                      return ButtonCustom(
                        title: "PINJAM SEKARANG",
                        width: 165,
                        height: 35,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => OrderBloc()..add(AddOrderEvent(book: bookBloc.state.detailBook!)),
                                child: const OrderPage(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // ADD CHECKOUT
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      if (state is AddCheckoutLoadingState) {
                        return Container(
                          height: 35,
                          width: 35,
                          child: loadingCircularProgressIndicator(title: ""),
                        );
                      }

                      return ButtonCustom(
                        title: "",
                        width: 35,
                        height: 35,
                        icons: state.isCheckout ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                        color: state.isCheckout ? Colors.grey : const Color(0xFF27374D),
                        onTap: () {
                          if (!state.isCheckout) {
                            context.read<CheckoutBloc>().add(
                                  AddCheckoutEvent(
                                    userID: firebaseAuth.currentUser!.uid,
                                    bookID: context.read<BookBloc>().state.detailBook!.id,
                                  ),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Berhasil tambah keranjang!"),
                              duration: Duration(seconds: 1),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Buku sudah di keranjang!"),
                              duration: Duration(seconds: 1),
                            ));
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

Container CardDetailInformationBook({String title = '', required String data}) {
  return Container(
    height: 58,
    width: 58,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.black.withOpacity(0.1),
          blurRadius: 1,
        )
      ],
      border: Border.all(
        color: Colors.black.withOpacity(0.1),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(data, style: TextStyle(fontSize: 10)),
        Text(title, style: TextStyle(fontSize: 10)),
      ],
    ),
  );
}

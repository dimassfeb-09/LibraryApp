import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/loading.dart';
import 'package:library_app/helpers/users.dart';
import 'package:library_app/ui/SuccessOrder.dart';

import '../bloc/Order/order_bloc.dart';
import '../components/button.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    UsersHelper usersHelper = UsersHelper();

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
              child: Text("Buku yang dipinjam", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<OrderBloc, OrderState>(
                bloc: context.watch<OrderBloc>(),
                builder: (context, state) {
                  if (state is AddOrderCheckoutsLoadingState) {
                    return Center(child: loadingCircularProgressIndicator());
                  }
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
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                                Text(
                                  state.books[index].writer,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.5), fontSize: 12),
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
                if (state is AddOrderCheckoutsLoadingState) {
                  loadingCircularProgressIndicator(title: "Sedang proses peminjaman..");
                }

                if (state is AddOrderCheckoutsSuccessedState) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => SuccessOrderPage(),
                    ),
                    (route) => false,
                  );
                }

                if (state is AddOrderCheckoutsFailedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMsg)),
                  );
                }
              },
              child: ButtonCustom(
                title: "KONFIRMASI PINJAM",
                width: 165,
                height: 35,
                onTap: () {
                  OrderBloc orderBloc = context.read<OrderBloc>();
                  orderBloc.add(AddOrderSubmittedEvent(
                    books: orderBloc.state.books,
                    userID: usersHelper.getCurrentUser()!.uid,
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

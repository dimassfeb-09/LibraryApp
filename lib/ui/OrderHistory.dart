import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/loading.dart';
import 'package:library_app/components/status_card.dart';
import 'package:library_app/ui/OrderHistoryDetail.dart';

import '../bloc/Order/order_bloc.dart';
import '../components/empty_lottie.dart';

class HistoryOrderPage extends StatelessWidget {
  const HistoryOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Riwayat Pinjam"),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is GetOrderUserLoadingState) {
            return Center(child: loadingCircularProgressIndicator());
          }

          if (state is GetOrderUserSuccessedState) {
            var invoices = state.orders?.invoices;

            if (invoices == null || invoices.isEmpty) {
              return EmptyLottie(title: "Ups, kamu belum pinjam buku..");
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: invoices.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        '/history_orders_detail',
                        arguments: {
                          'invoices': invoices[index],
                        },
                      ),
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        padding: const EdgeInsets.all(10),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 1,
                            )
                          ],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.book),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "TRXID-${invoices[index].trxID.toString().substring(76, 83)}"),
                                        Text(invoices[index]
                                            .created_at
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                                StatusCard(status: invoices[index].status!)
                              ],
                            ),
                            Divider(
                              color: Colors.black.withOpacity(0.1),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 110,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.black.withOpacity(0.1)),
                                    borderRadius: BorderRadius.circular(3),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          invoices[index]
                                              .books!
                                              .first
                                              .imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                        invoices[index].books!.first.title)),
                              ],
                            ),
                            Builder(
                              builder: (context) {
                                int lengthListBookPerInvoice =
                                    invoices[index].books!.length;
                                if (lengthListBookPerInvoice > 1) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Text(
                                          "Dengan ${lengthListBookPerInvoice - 1} buku lainnya",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

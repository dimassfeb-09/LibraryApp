import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/models/Invoices.dart';

import '../components/status_card.dart';

class OrderHistoryDetailPage extends StatelessWidget {
  const OrderHistoryDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, Invoices>;

    Invoices? invoices = arguments['invoices'];

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Detail Pinjam"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: invoices?.books!.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 116,
                      width: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                invoices!.books![index].imagePath),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoices!.books![index].title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.clip,
                        ),
                        Text(invoices!.books![index].writer,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF27374D),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status",
                          style: TextStyle(color: Colors.white)),
                      StatusCard(status: invoices!.status!),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Transaksi ID",
                          style: TextStyle(color: Colors.white)),
                      Text("TRXID-${invoices!.trxID!.substring(76, 83)}",
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tanggal Transaksi",
                          style: TextStyle(color: Colors.white)),
                      Text(invoices!.created_at!.toString(),
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Alamat Pengambilan",
                          style: const TextStyle(color: Colors.white)),
                      Expanded(
                        child: Text(
                          "Jl. Medan Merdeka Sel. No.11, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Alamat Pengembalian",
                          style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: Text(
                          "Jl. Medan Merdeka Sel. No.11, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

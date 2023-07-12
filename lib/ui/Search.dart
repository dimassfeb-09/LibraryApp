import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/bloc/Book/book_bloc.dart';
import 'package:library_app/components/loading.dart';
import 'package:library_app/components/text_field.dart';

import '../bloc/Checkout/checkout_bloc.dart';
import '../components/app_bar.dart';
import 'DetailBook.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Cari"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextFieldCustom(
                controller: TextEditingController(text: ''),
                hintText: "Cari buku berdasarkan judul, penulis dan penerbit",
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Paling dicari",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  BlocBuilder<BookBloc, BookState>(
                    bloc: context.read<BookBloc>(),
                    builder: (context, state) {
                      if (state is GetBooksLoadingState) {
                        return loadingCircularProgressIndicator();
                      } else if (state is GetBooksSuccessedState) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.trendBooks.length,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) =>
                                            BookBloc()..add(GetDetailBookEvent(id: state.trendBooks[index].id)),
                                      ),
                                      BlocProvider(
                                        create: (context) => CheckoutBloc()
                                          ..add(GetCheckoutBookByUserIDEvent(bookID: state.trendBooks[index].id)),
                                      ),
                                    ],
                                    child: DetailBookPage(),
                                  ),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 116,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(state.trendBooks[index].imagePath),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.black.withOpacity(0.10),
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.trendBooks[index].title,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(state.trendBooks[index].writer, style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

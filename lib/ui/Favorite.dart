import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/loading.dart';

import '../bloc/Book/book_bloc.dart';
import '../bloc/Checkout/checkout_bloc.dart';
import '../bloc/Favorite/favorite_bloc.dart';
import '../components/empty_lottie.dart';
import '../models/Books.dart';
import 'DetailBook.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleCustom(title: "Daftar Favorite"),
        centerTitle: true,
      ),
      body: BlocBuilder(
        bloc: context.read<FavoriteBloc>(),
        builder: (context, state) {
          if (state is GetAllFavoriteLoadingState) {
            return Center(child: loadingCircularProgressIndicator());
          }

          if (state is GetAllFavoriteSuccessedState) {
            List<Books>? books = state.books;

            if (books!.isEmpty) {
              return EmptyLottie(title: "Ups, kamu belum punya favorite..");
            }

            return ListView.builder(
              itemCount: books.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(create: (context) => BookBloc()..add(GetDetailBookEvent(id: books[index].id))),
                            BlocProvider(
                                create: (context) =>
                                    CheckoutBloc()..add(GetCheckoutBookByUserIDEvent(bookID: books[index].id))),
                            BlocProvider(
                                create: (context) => FavoriteBloc()..add(GetFavoriteByBookIDEvent(books[index].id))),
                          ],
                          child: DetailBookPage(),
                        ),
                      ),
                    ).then((result) {
                      // when pop from DetailBook, it will refresh for getting new favorite data
                      if (result != null) {
                        return context.read<FavoriteBloc>().add(GetAllFavoriteByUserIDEvent());
                      }
                    });
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
                                image: CachedNetworkImageProvider(books[index].imagePath), fit: BoxFit.cover),
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
                                    books[index].title,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.clip,
                                  ),
                                  Text(books[index].writer, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              Text(
                                "Stok: ${books[index].stock}",
                                style:
                                    TextStyle(fontSize: 12, color: books[index].stock <= 0 ? Colors.red : Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';

import '../bloc/Book/book_bloc.dart';
import '../bloc/Checkout/checkout_bloc.dart';
import '../bloc/Favorite/favorite_bloc.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Builder(builder: (context) {
              var favoriteBloc = context.watch<FavoriteBloc>();

              if (favoriteBloc.state.books != null) {
                return ListView.builder(
                  itemCount: favoriteBloc.state.books!.length,
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
                                      BookBloc()..add(GetDetailBookEvent(id: favoriteBloc.state.books![index].id)),
                                ),
                                BlocProvider(
                                  create: (context) => CheckoutBloc()
                                    ..add(GetCheckoutBookByUserIDEvent(bookID: favoriteBloc.state.books![index].id)),
                                ),
                                BlocProvider(
                                    create: (context) => FavoriteBloc()
                                      ..add(GetFavoriteByBookIDEvent(favoriteBloc.state.books![index].id)))
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
                                    image: CachedNetworkImageProvider(favoriteBloc.state.books![index].imagePath),
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
                                        favoriteBloc.state.books![index].title,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.clip,
                                      ),
                                      Text(favoriteBloc.state.books![index].writer,
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  Text("Stok: ${favoriteBloc.state.books![index].stock}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              favoriteBloc.state.books![index].stock <= 0 ? Colors.red : Colors.black)),
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
            })
          ],
        ),
      ),
    );
  }
}

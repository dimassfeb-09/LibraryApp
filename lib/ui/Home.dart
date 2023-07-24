import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/bloc/Favorite/favorite_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/loading.dart';
import 'package:library_app/ui/DetailBook.dart';
import 'package:library_app/ui/Favorite.dart';
import 'package:library_app/ui/Search.dart';

import '../bloc/Book/book_bloc.dart';
import '../bloc/Checkout/checkout_bloc.dart';
import '../bloc/Search/search_bloc.dart';
import '../bloc/pages_cubit.dart';
import '../components/card_book.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Utama"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamed('/menu'),
          icon: const Icon(Icons.menu_rounded),
        ),
        actions: const [_IconButtonActionHome()],
      ),
      body: BlocBuilder<BookBloc, BookState>(
        bloc: context.read<BookBloc>(),
        builder: (context, state) {
          if (state is GetBooksLoadingState) {
            return loadingCircularProgressIndicator();
          } else if (state is GetBooksSuccessedState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CardSliderRecommendation(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("Sedang trend",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  _CardSliderTrends(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("Buku baru",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  _CardSliderNewBooks(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      firebaseAuth.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }

    return BlocBuilder<PagesCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: _currentPage(context, state),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Utama",
                tooltip: "Utama",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Cari Buku",
                tooltip: "Cari Buku",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorite Kamu",
                tooltip: "Favorite Kamu",
              ),
            ],
            onTap: (int index) =>
                context.read<PagesCubit>().setCurrentPage(index),
            currentIndex: state,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            showUnselectedLabels: false,
          ),
        );
      },
    );
  }
}

Widget _currentPage(BuildContext context, int index) {
  switch (index) {
    case 1:
      return const SearchPage();
    case 2:
      return BlocProvider(
        create: (context) => FavoriteBloc()..add(GetAllFavoriteByUserIDEvent()),
        child: const FavoritePage(),
      );
    default:
      return const HomeScreen();
  }
}

class _IconButtonActionHome extends StatelessWidget {
  const _IconButtonActionHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed('/search'),
          tooltip: "Search",
          icon: const Icon(Icons.search),
        ),
        Builder(builder: (context) {
          return IconButton(
            tooltip: "Checkout",
            onPressed: () => Navigator.of(context).pushNamed('/checkouts'),
            icon: const Icon(Icons.shopping_cart),
          );
        }),
      ],
    );
  }
}

class _CardSliderRecommendation extends StatelessWidget {
  const _CardSliderRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    BookBloc bookBloc = context.read<BookBloc>();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            aspectRatio: 170 / 250,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            initialPage: 3,
            viewportFraction: 0.5,
          ),
          items: bookBloc.state.recommendationBooks.map((book) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                            create: (context) => BookBloc()
                              ..add(GetDetailBookEvent(id: book.id))),
                        BlocProvider(
                          create: (context) => CheckoutBloc()
                            ..add(
                                GetCheckoutBookByUserIDEvent(bookID: book.id)),
                        ),
                        BlocProvider(
                            create: (context) => FavoriteBloc()
                              ..add(GetFavoriteByBookIDEvent(book.id)))
                      ],
                      child: DetailBookPage(),
                    ),
                  ),
                );
              },
              child: CardBook(
                  imagePath: book.imagePath,
                  height: 250,
                  width: 170,
                  shadow: Shadow.medium),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CardSliderTrends extends StatelessWidget {
  _CardSliderTrends({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    BookBloc bookBloc = context.read<BookBloc>();
    return Container(
      height: 195,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: false,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: bookBloc.state.trendBooks.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => BookBloc()
                      ..add(GetDetailBookEvent(
                          id: bookBloc.state.trendBooks[index].id)),
                  ),
                  BlocProvider(
                    create: (context) => CheckoutBloc()
                      ..add(GetCheckoutBookByUserIDEvent(
                          bookID: bookBloc.state.trendBooks[index].id)),
                  ),
                  BlocProvider(
                      create: (context) => FavoriteBloc()
                        ..add(GetFavoriteByBookIDEvent(
                            bookBloc.state.trendBooks[index].id)))
                ],
                child: DetailBookPage(),
              ),
            ),
          ),
          child: CardBook(
            imagePath: bookBloc.state.trendBooks[index].imagePath,
            height: 195,
            width: 132,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            shadow: Shadow.none,
            border: BorderSize.medium,
          ),
        ),
      ),
    );
  }
}

class _CardSliderNewBooks extends StatelessWidget {
  _CardSliderNewBooks({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    BookBloc bookBloc = context.read<BookBloc>();
    return Container(
      height: 195,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: false,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: bookBloc.state.newBooks.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => BookBloc()
                      ..add(GetDetailBookEvent(
                          id: bookBloc.state.newBooks[index].id)),
                  ),
                  BlocProvider(
                    create: (context) => CheckoutBloc()
                      ..add(GetCheckoutBookByUserIDEvent(
                          bookID: bookBloc.state.newBooks[index].id)),
                  ),
                  BlocProvider(
                      create: (context) => FavoriteBloc()
                        ..add(GetFavoriteByBookIDEvent(
                            bookBloc.state.newBooks[index].id)))
                ],
                child: DetailBookPage(),
              ),
            ),
          ),
          child: CardBook(
            imagePath: bookBloc.state.newBooks[index].imagePath,
            height: 195,
            width: 132,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            shadow: Shadow.none,
            border: BorderSize.medium,
          ),
        ),
      ),
    );
  }
}

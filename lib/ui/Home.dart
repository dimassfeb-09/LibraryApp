import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/components/loading.dart';
import 'package:library_app/ui/Checkout.dart';
import 'package:library_app/ui/DetailBook.dart';
import 'package:library_app/ui/Search.dart';

import '../bloc/Book/book_bloc.dart';
import '../bloc/Checkout/checkout_bloc.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Utama"),
        centerTitle: true,
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
                    child: Text("Sedang trend", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  _CardSliderTrends(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("Buku baru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  _CardSliderNewBooks(),
                  SizedBox(height: 20),
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

class _IconButtonActionHome extends StatelessWidget {
  const _IconButtonActionHome({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? currentUser = firebaseAuth.currentUser;

    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => BookBloc()..add(GetBooksHomeEvent()),
                child: const SearchPage(),
              );
            },
          )),
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => CheckoutBloc()..add(GetCheckoutUserEvent(userID: currentUser?.uid)),
                child: const CheckoutPage(),
              );
            },
          )),
          icon: const Icon(Icons.shopping_cart),
        ),
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
                          create: (context) => BookBloc()..add(GetDetailBookEvent(id: book.id)),
                        ),
                        BlocProvider(
                          create: (context) => CheckoutBloc()
                            ..add(GetCheckoutBookByUserIDEvent(userID: firebaseAuth.currentUser!.uid, bookID: book.id)),
                        ),
                      ],
                      child: DetailBookPage(),
                    ),
                  ),
                );
              },
              child: Container(
                height: 250,
                width: 170,
                decoration: BoxDecoration(
                  image: DecorationImage(image: CachedNetworkImageProvider(book.imagePath), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.25),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 10,
                      color: Colors.grey.withOpacity(0.25),
                    ),
                  ],
                ),
              ),
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
                    create: (context) => BookBloc()..add(GetDetailBookEvent(id: bookBloc.state.trendBooks[index].id)),
                  ),
                  BlocProvider(
                    create: (context) => CheckoutBloc()
                      ..add(GetCheckoutBookByUserIDEvent(
                          userID: firebaseAuth.currentUser!.uid, bookID: bookBloc.state.trendBooks[index].id)),
                  ),
                ],
                child: DetailBookPage(),
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 195,
            width: 132,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(bookBloc.state.trendBooks[index].imagePath), fit: BoxFit.cover),
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(7.76),
            ),
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
                    create: (context) => BookBloc()..add(GetDetailBookEvent(id: bookBloc.state.newBooks[index].id)),
                  ),
                  BlocProvider(
                    create: (context) => CheckoutBloc()
                      ..add(GetCheckoutBookByUserIDEvent(
                          userID: firebaseAuth.currentUser!.uid, bookID: bookBloc.state.newBooks[index].id)),
                  ),
                ],
                child: DetailBookPage(),
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 195,
            width: 132,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(bookBloc.state.newBooks[index].imagePath), fit: BoxFit.cover),
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(7.76),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/app_bar.dart';
import 'package:library_app/ui/DetailBook.dart';
import 'package:library_app/ui/Search.dart';

import '../bloc/Book/book_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleCustom(title: "Home"),
        centerTitle: true,
        actions: [
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardCarouselSlider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("Sedang trend", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            BlocBuilder<BookBloc, BookState>(buildWhen: (previous, current) {
              if (current is GetBooksTrendSuccessedState) {
                return true;
              } else if (current is GetBooksTrendLoadingState) {
                return false;
              }
              return false;
            }, builder: (context, state) {
              return SizedBox(
                height: 195,
                width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: false,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: state.trendBooks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => BookBloc()..add(GetDetailBookEvent(id: state.trendBooks[index].id)),
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
                            image: CachedNetworkImageProvider(state.trendBooks[index].imagePath), fit: BoxFit.cover),
                        color: Colors.grey.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(7.76),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CardCarouselSlider extends StatelessWidget {
  const _CardCarouselSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    return BlocBuilder<BookBloc, BookState>(
      bloc: context.read<BookBloc>(),
      buildWhen: (previous, current) {
        if (current is GetBooksRecommendationSuccessedState) {
          return true;
        }

        return false;
      },
      builder: (context, state) {
        return CarouselSlider(
          options: CarouselOptions(
            height: 300,
            aspectRatio: 170 / 250,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            initialPage: 3,
            viewportFraction: 0.5,
            onPageChanged: (index, reason) {
              _currentIndex = index;
            },
          ),
          items: state.recommendationBooks.map((book) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => BookBloc()..add(GetDetailBookEvent(id: book.id)),
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
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

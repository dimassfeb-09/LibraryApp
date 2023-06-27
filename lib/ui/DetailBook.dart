import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/components/button.dart';

import '../bloc/Book/book_bloc.dart';
import '../components/app_bar.dart';

class DetailBookPage extends StatelessWidget {
  const DetailBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (context) {
          return AppBarTitleCustom(title: context.watch<BookBloc>().state.detailBook?.title ?? '');
        }),
        centerTitle: true,
      ),
      body: BlocBuilder<BookBloc, BookState>(
        bloc: context.read<BookBloc>(),
        builder: (context, state) {
          if (state is GetDetailBookLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetDetailBookSuccessedState) {
            return SingleChildScrollView(
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.detailBook!.description,
                      textAlign: TextAlign.justify,
                      maxLines: 10,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        },
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
            ButtonCustom(
              title: "BORROW",
              width: 165,
              height: 35,
              onTap: () {},
            ),
            const SizedBox(width: 12),
            ButtonCustom(
              title: "+",
              width: 35,
              height: 35,
              onTap: () {},
            ),
          ],
        ),
      ),
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

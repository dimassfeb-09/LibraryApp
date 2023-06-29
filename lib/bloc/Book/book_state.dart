part of 'book_bloc.dart';

class BookState {
  final List<Books> recommendationBooks;
  final List<Books> trendBooks;
  final List<Books> newBooks;
  Books? detailBook;

  BookState({
    this.recommendationBooks = const [],
    this.trendBooks = const [],
    this.newBooks = const [],
    this.detailBook,
  });
}

class GetBooksLoadingState extends BookState {}

class GetBooksSuccessedState extends BookState {
  GetBooksSuccessedState({super.recommendationBooks, super.trendBooks, super.newBooks});

  GetBooksSuccessedState copyWith({List<Books>? recommendationBooks, List<Books>? trendBooks, List<Books>? newBooks}) {
    return GetBooksSuccessedState(
      recommendationBooks: recommendationBooks ?? super.recommendationBooks,
      trendBooks: trendBooks ?? super.trendBooks,
      newBooks: newBooks ?? super.newBooks,
    );
  }
}

class GetDetailBookLoadingState extends BookState {}

class GetDetailBookSuccessedState extends BookState {
  final Books? detailBook;

  GetDetailBookSuccessedState({this.detailBook}) : super(detailBook: detailBook);
}

part of 'book_bloc.dart';

class BookState {
  final List<Books> recommendationBooks;
  final List<Books> trendBooks;
  Books? detailBook;

  BookState({
    this.recommendationBooks = const <Books>[],
    this.trendBooks = const <Books>[],
    this.detailBook,
  });
}

class GetBooksRecommendationLoadingState extends BookState {}

class GetBooksRecommendationSuccessedState extends BookState {
  final List<Books> recommendationBooks;
  GetBooksRecommendationSuccessedState({this.recommendationBooks = const []})
      : super(recommendationBooks: recommendationBooks);
}

class GetBooksTrendLoadingState extends BookState {}

class GetBooksTrendSuccessedState extends BookState {
  final List<Books> trendBooks;
  GetBooksTrendSuccessedState({this.trendBooks = const []}) : super(trendBooks: trendBooks);
}

class GetDetailBookLoadingState extends BookState {}

class GetDetailBookSuccessedState extends BookState {
  final Books? detailBook;
  GetDetailBookSuccessedState({this.detailBook}) : super(detailBook: detailBook);
}

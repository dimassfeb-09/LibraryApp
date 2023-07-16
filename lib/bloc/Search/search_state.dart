part of 'search_bloc.dart';

class SearchState {
  final String keyword;
  final List<Books>? books;

  SearchState({this.keyword = "", this.books});
}

class SearchBookLoadingState extends SearchState {}

class SearchBookSuccessedState extends SearchState {
  final List<Books>? books;

  SearchBookSuccessedState(this.books) : super(books: books);
}

class SearchBookFailedState extends SearchState {}

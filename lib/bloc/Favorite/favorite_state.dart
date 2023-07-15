part of 'favorite_bloc.dart';

class FavoriteState {
  final String? bookID;
  final DateTime? createdAt;
  final String? errorMsg;
  final List<Books>? books;
  final bool isFavorite;

  FavoriteState({this.bookID, this.createdAt, this.errorMsg, this.isFavorite = false, this.books});

  FavoriteState copyWith(
      {String? bookID, DateTime? createdAt, String? errorMsg, bool? isFavorite, List<Books>? books}) {
    return FavoriteState(
      bookID: bookID ?? this.bookID,
      errorMsg: errorMsg ?? this.errorMsg,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      books: books ?? this.books,
    );
  }
}

class GetFavoriteLoadingState extends FavoriteState {}

class GetFavoriteSuccessedState extends FavoriteState {
  final bool isFavorite;

  GetFavoriteSuccessedState({required this.isFavorite}) : super(isFavorite: isFavorite);
}

class GetFavoriteFailedState extends FavoriteState {
  final String errorMsg;

  GetFavoriteFailedState(this.errorMsg);
}

class GetAllFavoriteLoadingState extends FavoriteState {}

class GetAllFavoriteSuccessedState extends FavoriteState {
  final List<Books>? books;
  GetAllFavoriteSuccessedState({this.books}) : super(books: books);

  GetAllFavoriteSuccessedState copyWith(
      {String? bookID, DateTime? createdAt, String? errorMsg, bool? isFavorite, List<Books>? books}) {
    return GetAllFavoriteSuccessedState(
      books: super.books ?? books,
    );
  }
}

class GetAllFavoriteFailedState extends FavoriteState {
  final String errorMsg;
  GetAllFavoriteFailedState(this.errorMsg);
}

class AddFavoriteLoadingState extends FavoriteState {}

class AddFavoriteSuccessedState extends FavoriteState {
  final bool isFavorite;
  AddFavoriteSuccessedState({this.isFavorite = true}) : super(isFavorite: isFavorite);
}

class AddFavoriteFailedState extends FavoriteState {
  final String errorMsg;
  AddFavoriteFailedState(this.errorMsg);
}

class DeleteFavoriteLoadingState extends FavoriteState {}

class DeleteFavoriteSuccessedState extends FavoriteState {
  final bool isFavorite;
  DeleteFavoriteSuccessedState({this.isFavorite = false}) : super(isFavorite: isFavorite);
}

class DeleteFavoriteFailedState extends FavoriteState {
  final String errorMsg;
  DeleteFavoriteFailedState(this.errorMsg);
}

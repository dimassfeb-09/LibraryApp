part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}

class GetFavoriteByBookIDEvent extends FavoriteEvent {
  final String bookID;
  GetFavoriteByBookIDEvent(this.bookID);
}

class AddFavoriteEvent extends FavoriteEvent {
  final String bookID;
  AddFavoriteEvent(this.bookID);
}

class DeleteFavoriteEvent extends FavoriteEvent {
  final String bookID;
  DeleteFavoriteEvent(this.bookID);
}

part of 'book_bloc.dart';

@immutable
abstract class BookEvent {}

class GetBooksHomeEvent extends BookEvent {}

class GetDetailBookEvent extends BookEvent {
  final String id;
  GetDetailBookEvent({required this.id});
}

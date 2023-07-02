part of 'order_bloc.dart';

class OrderEvent {}

class AddOrderEvent extends OrderEvent {
  Books? book = Books();
  AddOrderEvent({this.book});
}

class AddOrderCheckoutEvent extends OrderEvent {
  final List<Checkouts> checkouts;
  AddOrderCheckoutEvent({this.checkouts = const []});
}

class AddOrderSubmittedEvent extends OrderEvent {
  final List<Books> books;
  final String userID;
  AddOrderSubmittedEvent({required this.books, required this.userID});
}

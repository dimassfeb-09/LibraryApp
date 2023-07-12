part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutEvent {}

class GetCheckoutUserEvent extends CheckoutEvent {
  final String? userID;
  GetCheckoutUserEvent({this.userID = ''});
}

class GetCheckoutBookByUserIDEvent extends CheckoutEvent {
  final String bookID;
  GetCheckoutBookByUserIDEvent({required this.bookID});
}

class AddCheckoutEvent extends CheckoutEvent {
  final String userID;
  final String bookID;
  AddCheckoutEvent({required this.userID, required this.bookID});
}

class DeleteCheckoutEvent extends CheckoutEvent {
  final String checkoutID;
  final String bookID;
  DeleteCheckoutEvent({required this.checkoutID, required this.bookID});
}

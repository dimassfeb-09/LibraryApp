part of 'order_bloc.dart';

class OrderState {
  final List<Books> books;
  final String? errorMsg;

  OrderState({this.books = const [], this.errorMsg});

  OrderState copyWith({List<Books>? books, String? errorMsg}) {
    return OrderState(books: books ?? this.books, errorMsg: errorMsg ?? this.errorMsg);
  }
}

class AddOrderState extends OrderState {}

class AddOrderLoadingState extends OrderState {}

class AddOrderSuccessedState extends OrderState {}

class AddOrderCheckoutsState extends OrderState {}

class AddOrderCheckoutsLoadingState extends OrderState {}

class AddOrderCheckoutsSuccessedState extends OrderState {
  AddOrderCheckoutsSuccessedState({super.books, super.errorMsg});
}

class AddOrderCheckoutsFailedState extends OrderState {
  final List<Books> books;
  final String errorMsg;
  AddOrderCheckoutsFailedState({this.books = const [], this.errorMsg = ''}) : super(books: books, errorMsg: errorMsg);
}

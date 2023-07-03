part of 'order_bloc.dart';

class OrderState {
  final List<Books> books;
  final String? errorMsg;
  final Orders? orders;

  OrderState({this.books = const [], this.errorMsg, this.orders});

  OrderState copyWith({List<Books>? books, String? errorMsg, Orders? orders}) {
    return OrderState(
      books: books ?? this.books,
      errorMsg: errorMsg ?? this.errorMsg,
      orders: orders ?? this.orders,
    );
  }
}

class AddOrderState extends OrderState {}

class AddOrderLoadingState extends OrderState {}

class AddOrderSuccessedState extends OrderState {}

class AddOrderCheckoutsState extends OrderState {}

class AddOrderCheckoutsLoadingState extends OrderState {}

class AddOrderCheckoutsSuccessedState extends OrderState {
  AddOrderCheckoutsSuccessedState({super.books, super.errorMsg, super.orders});

  AddOrderCheckoutsSuccessedState copyWith({List<Books>? books, String? errorMsg, Orders? orders}) {
    return AddOrderCheckoutsSuccessedState(
      errorMsg: errorMsg ?? super.errorMsg,
      books: books ?? super.books,
      orders: orders ?? super.orders,
    );
  }
}

class AddOrderCheckoutsFailedState extends OrderState {
  final List<Books> books;
  final String errorMsg;
  AddOrderCheckoutsFailedState({this.books = const [], this.errorMsg = ''}) : super(books: books, errorMsg: errorMsg);
}

class GetOrderUserLoadingState extends OrderState {}

class GetOrderUserSuccessedState extends OrderState {
  GetOrderUserSuccessedState({super.books, super.errorMsg, super.orders});

  GetOrderUserSuccessedState copyWith({List<Books>? books, String? errorMsg, Orders? orders}) {
    return GetOrderUserSuccessedState(
      errorMsg: errorMsg ?? super.errorMsg,
      books: books ?? super.books,
      orders: orders ?? super.orders,
    );
  }
}

class GetOrderUserFailedState extends OrderState {}

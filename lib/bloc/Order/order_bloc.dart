import 'package:bloc/bloc.dart';
import 'package:library_app/repository/OrderRepository.dart';

import '../../models/Books.dart';
import '../../models/Checkouts.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState()) {
    on<AddOrderEvent>(_addOrderState);
    on<AddOrderCheckoutEvent>(_addOrderCheckoutEvent);
    on<AddOrderSubmittedEvent>(_addOrderSubmittedEvent);
  }

  void _addOrderState(AddOrderEvent event, Emitter emit) {
    List<Books> books = [];
    books.add(event.book!);
    emit(state.copyWith(books: books));
  }

  void _addOrderCheckoutEvent(AddOrderCheckoutEvent event, Emitter emit) {
    List<Books> books = [];
    event.checkouts.forEach((v) {
      if (v.book!.stock > 0) {
        books.add(v.book!);
      }
    });
    emit(state.copyWith(books: books));
  }

  void _addOrderSubmittedEvent(AddOrderSubmittedEvent event, Emitter emit) async {
    emit(AddOrderCheckoutsLoadingState());
    try {
      OrderRepository orderRepository = OrderRepository();

      event.books.forEach((book) {
        if (book.stock <= 0) {
          throw "Stock ${book.title} kosong. Harap hapus dari keranjang.";
        }
      });

      await orderRepository.orderBooks(books: event.books, userID: event.userID);

      emit(AddOrderCheckoutsSuccessedState(books: event.books, errorMsg: ''));
    } catch (e) {
      emit(AddOrderCheckoutsFailedState(books: event.books, errorMsg: e.toString()));
    }
  }
}

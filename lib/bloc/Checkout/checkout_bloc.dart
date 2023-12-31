import 'package:bloc/bloc.dart';
import 'package:library_app/models/Checkouts.dart';
import 'package:meta/meta.dart';

import '../../helpers/users.dart';
import '../../models/Books.dart';
import '../../repository/CheckoutRepository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  UsersHelper usersHelper = UsersHelper();

  CheckoutBloc() : super(CheckoutState()) {
    on<GetCheckoutUserEvent>((event, emit) async {
      emit(GetCheckoutUserLoadingState());
      String? userID = event.userID;
      List<Books>? books = [];

      CheckoutRepository checkoutRepository = CheckoutRepository();
      var checkouts = await checkoutRepository.getCheckoutUser();

      checkouts.sort((a, b) => b.book!.stock);

      emit(GetCheckoutUserSuccessedState().copyWith(checkouts: checkouts));
    });

    on<GetCheckoutBookByUserIDEvent>((event, emit) async {
      try {
        var currentUser = usersHelper.getCurrentUser();
        emit(GetCheckoutBookByUserIDLoadingState());

        CheckoutRepository checkoutRepository = CheckoutRepository();
        bool isCheckout =
            await checkoutRepository.getCheckoutBookByIDUser(bookID: event.bookID, userID: currentUser!.uid);
        emit(GetCheckoutBookByUserIDSucessedState(isCheckout: isCheckout));
      } catch (e) {
        print("error");
      }
    });

    on<AddCheckoutEvent>((event, emit) async {
      emit(AddCheckoutLoadingState());

      CheckoutRepository checkoutRepository = CheckoutRepository();
      await checkoutRepository.addCheckoutBooks(userID: event.userID, bookID: event.bookID);

      emit(AddCheckoutSuccessedState().copyWith(isCheckout: true));
    });

    on<DeleteCheckoutEvent>((event, emit) async {
      var isExists = state.checkouts.where((element) => element.book!.id == event.bookID);
      if (isExists.isNotEmpty) {
        List<Checkouts> newCheckouts = List.from(state.checkouts);

        emit(DeleteCheckoutLoadingState());
        CheckoutRepository checkoutRepository = CheckoutRepository();
        await checkoutRepository.deleteCheckoutBooks(checkoutID: event.checkoutID, bookID: event.bookID);

        newCheckouts.removeWhere((element) => element.book!.id == event.bookID);

        emit(DeleteCheckoutSuccessedState(checkouts: newCheckouts));
      }
    });
  }
}

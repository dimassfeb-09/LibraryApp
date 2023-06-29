part of 'checkout_bloc.dart';

@immutable
class CheckoutState {
  final List<Checkouts> checkouts;
  final bool isCheckout;

  CheckoutState({this.checkouts = const [], this.isCheckout = false});
}

class GetCheckoutUserLoadingState extends CheckoutState {}

class GetCheckoutUserSuccessedState extends CheckoutState {
  GetCheckoutUserSuccessedState({super.checkouts});

  GetCheckoutUserSuccessedState copyWith({List<Checkouts>? checkouts}) {
    return GetCheckoutUserSuccessedState(checkouts: checkouts ?? super.checkouts);
  }
}

class GetCheckoutBookByUserIDLoadingState extends CheckoutState {}

class GetCheckoutBookByUserIDSucessedState extends CheckoutState {
  GetCheckoutBookByUserIDSucessedState({super.isCheckout});
}

class AddCheckoutLoadingState extends CheckoutState {}

class AddCheckoutSuccessedState extends CheckoutState {
  AddCheckoutSuccessedState({super.isCheckout});

  AddCheckoutSuccessedState copyWith({bool? isCheckout}) {
    return AddCheckoutSuccessedState(isCheckout: isCheckout ?? super.isCheckout);
  }
}

class DeleteCheckoutLoadingState extends CheckoutState {}

class DeleteCheckoutSuccessedState extends CheckoutState {
  DeleteCheckoutSuccessedState({super.checkouts});

  DeleteCheckoutSuccessedState copyWith({List<Checkouts>? checkouts}) {
    return DeleteCheckoutSuccessedState(checkouts: checkouts ?? super.checkouts);
  }
}

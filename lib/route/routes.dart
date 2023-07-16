import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/ui/Favorite.dart';
import 'package:library_app/ui/OrderHistoryDetail.dart';

import '../bloc/Book/book_bloc.dart';
import '../bloc/Checkout/checkout_bloc.dart';
import '../bloc/Favorite/favorite_bloc.dart';
import '../bloc/Home/home_bloc.dart';
import '../bloc/Login/login_bloc.dart';
import '../bloc/Order/order_bloc.dart';
import '../bloc/Search/search_bloc.dart';
import '../bloc/User/users_bloc.dart';
import '../ui/Checkout.dart';
import '../ui/DetailBook.dart';
import '../ui/ForgotPassword.dart';
import '../ui/Home.dart';
import '../ui/Login.dart';
import '../ui/Menu.dart';
import '../ui/OrderHistory.dart';
import '../ui/Profile.dart';
import '../ui/Register.dart';
import '../ui/Search.dart';
import '../ui/UpdateEmail.dart';
import '../ui/UpdatePassword.dart';

Map<String, Widget Function(BuildContext)> routes(BuildContext context) {
  return {
    '/login': (context) => BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginPage(),
        ),
    '/register': (context) => const RegisterPage(),
    '/menu': (context) => BlocProvider(
          create: (context) => UsersBloc()..add(GetDetailUserEvent()),
          child: const MenuPage(),
        ),
    '/profile': (context) => ProfilePage(),
    '/edit_email': (context) => BlocProvider(
          create: (context) => UsersBloc(),
          child: UpdateEmailPage(),
        ),
    '/edit_password': (context) => BlocProvider(
          create: (context) => UsersBloc(),
          child: UpdatePasswordPage(),
        ),
    '/home': (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeBloc()),
            BlocProvider(
                create: (context) => BookBloc()..add(GetBooksHomeEvent())),
            BlocProvider(
                create: (context) =>
                    CheckoutBloc()..add(GetCheckoutUserEvent())),
          ],
          child: HomePage(),
        ),
    '/search': (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => BookBloc()..add(GetBooksHomeEvent()),
            ),
            BlocProvider(
              create: (context) => SearchBloc(),
            )
          ],
          child: const SearchPage(),
        ),
    '/detail_book': (context) => DetailBookPage(),
    '/favorite': (context) => BlocProvider(
          create: (context) =>
              FavoriteBloc()..add(GetAllFavoriteByUserIDEvent()),
          child: FavoritePage(),
        ),
    '/forgotpassword': (context) => const ForgotPasswordPage(),
    '/checkouts': (context) => BlocProvider(
          create: (context) => CheckoutBloc()..add(GetCheckoutUserEvent()),
          child: CheckoutPage(),
        ),
    '/history_orders': (context) => BlocProvider(
          create: (context) => OrderBloc()..add(GetOrderUserEvent()),
          child: const HistoryOrderPage(),
        ),
    '/history_orders_detail': (context) => const OrderHistoryDetailPage(),
  };
}

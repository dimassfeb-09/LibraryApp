import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/bloc/Checkout/checkout_bloc.dart';
import 'package:library_app/bloc/Order/order_bloc.dart';
import 'package:library_app/ui/Checkout.dart';
import 'package:library_app/ui/Menu.dart';
import 'package:library_app/ui/OrderHistory.dart';

import 'bloc/Book/book_bloc.dart';
import 'bloc/Home/home_bloc.dart';
import 'bloc/Login/login_bloc.dart';
import 'bloc/User/users_bloc.dart';
import 'firebase_options.dart';
import 'ui/DetailBook.dart';
import 'ui/ForgotPassword.dart';
import 'ui/Home.dart';
import 'ui/Login.dart';
import 'ui/Register.dart';
import 'ui/Search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return MaterialApp(
      title: 'Library App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: const Color(0xFF27374D),
          seedColor: const Color(0xFF27374D),
        ),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => BlocProvider(
              create: (context) => LoginBloc(),
              child: const LoginPage(),
            ),
        '/register': (context) => const RegisterPage(),
        '/menu': (context) => BlocProvider(
              create: (context) => UsersBloc()..add(GetDetailUserEvent()),
              child: const MenuPage(),
            ),
        '/home': (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => HomeBloc()),
                BlocProvider(create: (context) => BookBloc()..add(GetBooksHomeEvent())),
              ],
              child: HomePage(),
            ),
        '/search': (context) => const SearchPage(),
        '/detail_book': (context) => DetailBookPage(),
        '/forgotpassword': (context) => const ForgotPasswordPage(),
        '/checkouts': (context) => BlocProvider(
              create: (context) => CheckoutBloc()..add(GetCheckoutUserEvent()),
              child: CheckoutPage(),
            ),
        '/history_orders': (context) => BlocProvider(
              create: (context) => OrderBloc()..add(GetOrderUserEvent()),
              child: const HistoryOrderPage(),
            ),
      },
      initialRoute: firebaseAuth.currentUser != null ? '/home' : '/login',
      // initialRoute: '/home',
    );
  }
}

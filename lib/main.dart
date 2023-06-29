import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/Book/book_bloc.dart';
import 'bloc/Home/home_bloc.dart';
import 'bloc/Login/login_bloc.dart';
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
              child: LoginPage(),
            ),
        '/register': (context) => const RegisterPage(),
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
      },
      initialRoute: firebaseAuth.currentUser != null ? '/home' : '/login',
      // initialRoute: '/home',
    );
  }
}

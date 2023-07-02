import 'package:firebase_auth/firebase_auth.dart';

class UsersHelper {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}

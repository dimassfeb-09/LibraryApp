import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/helpers/users.dart';
import 'package:library_app/models/Users.dart';

class UserRepository {
  UsersHelper usersHelper = UsersHelper();

  Future<Users> getDetailInfoUser() async {
    try {
      var currentUser = usersHelper.getCurrentUser();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = await firebaseFirestore
          .collection("users")
          .doc(currentUser?.uid)
          .get();
      return Users.fromJson(user.data()!);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> changeEmailUser(String email) async {
    try {
      var currentUser = usersHelper.getCurrentUser();
      await currentUser?.updateEmail(email);

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore
          .collection("users")
          .doc(currentUser?.uid)
          .update({"email": email});
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> changePasswordUser(String password) async {
    try {
      var currentUser = usersHelper.getCurrentUser();
      await currentUser?.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }
}

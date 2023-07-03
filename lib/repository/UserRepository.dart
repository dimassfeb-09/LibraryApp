import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/helpers/users.dart';
import 'package:library_app/models/Users.dart';

class UserRepository {
  Future<Users> getDetailInfoUser() async {
    UsersHelper usersHelper = UsersHelper();
    try {
      var currentUser = usersHelper.getCurrentUser();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = await firebaseFirestore.collection("users").doc(currentUser?.uid).get();
      return Users.fromJson(user.data()!);
    } catch (e) {
      throw e.toString();
    }
  }
}

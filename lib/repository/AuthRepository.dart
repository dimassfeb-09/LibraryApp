import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/helpers/users.dart';

class AuthRepository {
  UsersHelper usersHelper = UsersHelper();

  Future<void> LoginAuth({required String email, required String password}) async {
    try {
      var firebaseAuthInstance = usersHelper.firebaseAuthInstance();
      await firebaseAuthInstance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> RegisterAuth({required String name, required String email, required String password}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      var firebaseAuthInstance = usersHelper.firebaseAuthInstance();

      final userCredential =
          await firebaseAuthInstance.createUserWithEmailAndPassword(email: email, password: password);
      String? uuid = userCredential.user!.uid;
      String? photoURL = userCredential.user!.photoURL;

      if (uuid.isNotEmpty) {
        firebaseFirestore
            .collection("users")
            .doc(uuid)
            .set(
              {
                "name": name,
                "email": email.toLowerCase(),
                "uuid": uuid,
                "photo_url": photoURL,
              },
            )
            .then((value) {})
            .catchError((e) {
              throw e.toString();
            });
      }
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> logoutAuth() async {
    try {
      var firebaseAuthInstance = usersHelper.firebaseAuthInstance();
      firebaseAuthInstance.signOut();
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }
}

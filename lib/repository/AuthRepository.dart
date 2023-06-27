import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> LoginAuth({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> RegisterAuth({required String name, required String email, required String password}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      String? uuid;
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      uuid = userCredential.user!.uid;

      if (uuid.isNotEmpty) {
        firebaseFirestore
            .collection("users")
            .doc(uuid)
            .set(
              {
                "name": name,
                "email": email.toLowerCase(),
                "uuid": uuid,
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
}

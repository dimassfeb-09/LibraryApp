import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:library_app/repository/BookRepository.dart';

import '../models/Books.dart';

class OrderRepository {
  Future<void> orderBooks(
      {required List<Books> books, required String userID}) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      DocumentReference docColUser =
          firebaseFirestore.collection("users").doc(userID);

      final docs = await firebaseFirestore
          .collection("orders")
          .where(
            "user_id",
            isEqualTo: firebaseFirestore.collection("users").doc(userID),
          )
          .get()
          .then((value) => value.docs);

      String orderID = '';
      if (docs.first.exists) {
        orderID = docs.first.id;
      }

      DateTime dateTime = DateTime.now();

      var path = await firebaseFirestore
          .collection("orders")
          .doc(orderID)
          .collection("invoices")
          .add({
        "created_at": dateTime,
        "user_id": docColUser,
      }).then((value) => value.path);

      for (var book in books) {
        firebaseFirestore.doc(path).collection('books').add({
          "book_id": firebaseFirestore.collection("books").doc(book.id),
          "created_at": dateTime,
          "user_id": docColUser,
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}

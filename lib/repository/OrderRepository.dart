import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/repository/CheckoutRepository.dart';

import '../models/Books.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class OrderRepository {
  DateTime dateTimeNow = DateTime.now();
  CollectionReference collectionReferenceOrders = _firebaseFirestore.collection("orders");
  CollectionReference collectionReferenceUsers = _firebaseFirestore.collection("users");
  CollectionReference collectionReferenceBooks = _firebaseFirestore.collection("books");

  Future<void> orderBooks({required List<Books> books, required String userID}) async {
    try {
      String orderID = '';

      var isOrderAlready = await searchOrderByUserID(userID);
      if (isOrderAlready.docs.isNotEmpty) {
        orderID = isOrderAlready.docs.first.id;
      } else {
        orderID = await _createNewOrderID(
          collectionReferenceOrder: collectionReferenceOrders,
          collectionReferenceUser: collectionReferenceUsers,
          userID: userID,
        );
      }

      DocumentReference invoice = await _createNewInvoiceID(
        collectionReferenceOrder: collectionReferenceOrders,
        orderID: orderID,
        userID: userID,
      );

      for (Books book in books) {
        await _firebaseFirestore.doc(invoice.path).collection("books").add({
          "book_id": book.id,
          "created_at": dateTimeNow,
        });
      }

      for (Books book in books) {
        await _updateStockBook(collectionReferenceBooks.doc(book.id));
      }

      CheckoutRepository checkoutRepository = CheckoutRepository();
      await checkoutRepository.deleteAllCheckouts(userID, books);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _createNewOrderID(
      {required CollectionReference collectionReferenceOrder,
      required CollectionReference collectionReferenceUser,
      required String userID}) async {
    try {
      DocumentReference documentReferenceOrder = await collectionReferenceOrder.add({
        "user_id": collectionReferenceUser.doc(userID),
        "created_at": dateTimeNow,
      });

      return documentReferenceOrder.id;
    } catch (e) {
      throw e;
    }
  }

  Future<DocumentReference> _createNewInvoiceID(
      {required CollectionReference collectionReferenceOrder, required String orderID, required String userID}) async {
    try {
      return await collectionReferenceOrder.doc(orderID).collection("invoices").add({
        "created_at": dateTimeNow,
        "user_id": collectionReferenceUsers.doc(userID),
      });
    } catch (e) {
      throw e;
    }
  }

  Future<QuerySnapshot> searchOrderByUserID(String userID) async {
    try {
      return await collectionReferenceOrders.where("user_id", isEqualTo: collectionReferenceUsers.doc(userID)).get();
    } catch (e) {
      throw e;
    }
  }

  Future<void> _updateStockBook(DocumentReference docRefBook) async {
    try {
      var documentSnapshot = await docRefBook.get();
      int stock = documentSnapshot.get("stock");
      stock -= 1;

      await collectionReferenceBooks.doc(documentSnapshot.id).update({"stock": stock});
    } catch (e) {
      throw e;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/helpers/generate_transaction_id.dart';
import 'package:library_app/models/Orders.dart';
import 'package:library_app/repository/BookRepository.dart';
import 'package:library_app/repository/CheckoutRepository.dart';
import 'package:library_app/repository/UserRepository.dart';

import '../models/Books.dart';
import '../models/Invoices.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class OrderRepository {
  DateTime dateTimeNow = DateTime.now();
  CollectionReference collectionReferenceOrders = _firebaseFirestore.collection("orders");
  CollectionReference collectionReferenceUsers = _firebaseFirestore.collection("users");
  CollectionReference collectionReferenceBooks = _firebaseFirestore.collection("books");

  Future<Orders?> getUserOrders() async {
    try {
      List<Invoices> listInvoice = [];
      List<Books> listBooks = [];

      UserRepository userRepository = UserRepository();
      var userInfo = await userRepository.getDetailInfoUser();
      var orders =
          await collectionReferenceOrders.where("user_id", isEqualTo: collectionReferenceUsers.doc(userInfo.uid)).get();

      if (orders.docs.isEmpty) {
        await _createNewOrderID(userID: userInfo.uid);
        return null;
      }

      var querySnapshot = await orders.docs.first.reference.collection("invoices").get();

      for (var snapshot in querySnapshot.docs) {
        var docInvoices = await snapshot.reference.get();

        var books = await docInvoices.reference.collection("books").get();

        List<Books> listBookPerInvoice = [];
        for (var book in books.docs) {
          BookRepository bookRepository = BookRepository();
          var detailBook = await bookRepository.getDetailBook(id: book.get("book_id").id);
          listBookPerInvoice.add(detailBook);
        }

        listBooks = listBookPerInvoice;
        listInvoice.add(Invoices(
          trxID: docInvoices.get("trx_id"),
          invoiceID: docInvoices.id,
          created_at: (docInvoices.get("created_at") as Timestamp).toDate(),
          status: docInvoices.get("status"),
          books: listBooks,
        ));
      }

      Orders userOrder = Orders.fromJson({
        "user_id": userInfo.uid,
        "invoices": listInvoice,
      });

      return userOrder;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> orderBooks({required List<Books> books, required String userID}) async {
    try {
      String orderID = '';

      var isOrderAlready = await searchOrderByUserID(userID);
      if (isOrderAlready.docs.isNotEmpty) {
        orderID = isOrderAlready.docs.first.id;
      } else {
        orderID = await _createNewOrderID(userID: userID);
      }

      DocumentReference invoice = await _createNewInvoiceID(
        collectionReferenceOrder: collectionReferenceOrders,
        orderID: orderID,
        userID: userID,
      );

      for (Books book in books) {
        await _firebaseFirestore.doc(invoice.path).collection("books").add({
          "book_id": collectionReferenceBooks.doc(book.id),
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

  Future<String> _createNewOrderID({required String userID}) async {
    try {
      DocumentReference documentReferenceOrder = await collectionReferenceOrders.add({
        "user_id": collectionReferenceUsers.doc(userID),
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
      String trxID = generateTransactionId(userID, orderID);
      return await collectionReferenceOrder.doc(orderID).collection("invoices").add({
        "trx_id": trxID,
        "status": "pending",
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/repository/BookRepository.dart';

import '../models/Books.dart';
import '../models/Checkouts.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class CheckoutRepository {
  final collectionUserRef = firebaseFirestore.collection("users");
  final collectionCheckoutRef = firebaseFirestore.collection("checkouts");
  final collectionBookRef = firebaseFirestore.collection("books");
  BookRepository bookRepository = BookRepository();

  Future<List<Checkouts>> getCheckoutUser({required String userID}) async {
    try {
      List<String>? booksID = [];
      List<Books> books;
      String checkoutID;
      List<Checkouts>? checkouts = [];

      var checkoutsCol = await collectionCheckoutRef.where("user_id", isEqualTo: collectionUserRef.doc(userID)).get();
      checkoutID = checkoutsCol.docs.first.id;

      var booksCol = await collectionCheckoutRef.doc(checkoutID).collection("books").get().then((value) => value.docs);
      booksCol.forEach((value) {
        DocumentReference book = value.data()["book_id"];
        booksID.add(book.id);
      });

      List<Future<Books>> fetchBooksFutures = [];
      booksID.forEach((ID) {
        fetchBooksFutures.add(bookRepository.getDetailBook(id: ID));
      });
      books = await Future.wait(fetchBooksFutures);

      books.forEach((book) {
        Checkouts checkout = Checkouts(id: checkoutID, book: book);
        checkouts.add(checkout);
      });

      return checkouts;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> getCheckoutBookByIDUser({required String bookID, required String userID}) async {
    try {
      String checkoutID;
      var checkoutsCol = await collectionCheckoutRef.where("user_id", isEqualTo: collectionUserRef.doc(userID)).get();
      checkoutID = checkoutsCol.docs.first.id;

      QuerySnapshot querySnapshot = await collectionCheckoutRef.doc(checkoutID).collection("books").get();
      Iterable<QueryDocumentSnapshot<Object?>> where =
          querySnapshot.docs.where((element) => element.get("book_id") == collectionBookRef.doc(bookID));
      if (where.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> addCheckoutBooks({required String userID, required String bookID}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> where =
          await collectionCheckoutRef.where("user_id", isEqualTo: collectionUserRef.doc(userID)).get();
      final docCheckout = where.docs.first;

      if (docCheckout.exists) {
        var isCheckoutExists = await collectionCheckoutRef
            .doc(docCheckout.id)
            .collection("books")
            .where("book_id", isEqualTo: collectionBookRef.doc(bookID))
            .get()
            .then((value) {
          return value.docs.first.exists;
        }).catchError((e) {
          return false;
        });

        if (!isCheckoutExists) {
          await collectionCheckoutRef
              .doc(docCheckout.id)
              .collection("books")
              .add({"book_id": collectionBookRef.doc(bookID)});
          return;
        }
        return;
      }

      print("failed");
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteCheckoutBooks({required String checkoutID, required String bookID}) async {
    try {
      print(checkoutID);
      print(bookID);
      var querySnapshot = await collectionCheckoutRef
          .doc(checkoutID)
          .collection("books")
          .where("book_id", isEqualTo: collectionBookRef.doc(bookID))
          .get();
      if (querySnapshot.docs.first.exists) {
        await collectionCheckoutRef
            .doc(checkoutID)
            .collection("books")
            .doc(querySnapshot.docs.first.id)
            .delete()
            .catchError((e) {
          throw e;
        });
        return;
      }

      print("gak ada");
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteRepository {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> getAllFavoriteBooksByUserID({required String userID}) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection("favorites")
          .where("user_id", isEqualTo: firebaseFirestore.collection("users").doc(userID))
          .get();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getFavoriteBookByUserID({required String userID, required String bookID}) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection("favorites")
          .where("user_id", isEqualTo: firebaseFirestore.collection("users").doc(userID))
          .get();

      var getDocumentByBookID = await firebaseFirestore
          .doc(querySnapshot.docs.first.reference.path)
          .collection("books")
          .where("book_id", isEqualTo: firebaseFirestore.doc("books/$bookID"))
          .get();

      if (getDocumentByBookID.docs.isNotEmpty) {
        if (getDocumentByBookID.docs.first.exists) {
          return true;
        }
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteFavoriteBook({required String userID, required String bookID}) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection("favorites")
          .where("user_id", isEqualTo: firebaseFirestore.collection("users").doc(userID))
          .get();
      var getDocumentByBookID = await firebaseFirestore
          .doc(querySnapshot.docs.first.reference.path)
          .collection("books")
          .where("book_id", isEqualTo: firebaseFirestore.doc("books/$bookID"))
          .get();

      if (getDocumentByBookID.docs.isNotEmpty) {
        await getDocumentByBookID.docs.first.reference.delete();
        return true;
      }

      return false;
    } catch (e) {
      throw false;
    }
  }

  Future<bool> addFavoriteBook({required String userID, required String bookID}) async {
    try {
      var gettingUserColAtFavorite = await firebaseFirestore
          .collection("favorites")
          .where("user_id", isEqualTo: firebaseFirestore.collection("users").doc(userID))
          .get();

      Map<String, dynamic> detailFavorite = {
        "book_id": firebaseFirestore.doc("books/$bookID"),
        "created_at": DateTime.now(),
      };

      // creating documents favorites with field reference user_id and document books in collectionn favorite/books
      if (gettingUserColAtFavorite.docs.isEmpty) {
        await firebaseFirestore.collection("favorites").add({"user_id": firebaseFirestore.doc("users/$userID")}).then(
            (value) => value.collection("books").add(detailFavorite));
        return true;
      }

      if (gettingUserColAtFavorite.docs.isNotEmpty) {
        await gettingUserColAtFavorite.docs.first.reference.collection("books").add(detailFavorite);
        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }
}

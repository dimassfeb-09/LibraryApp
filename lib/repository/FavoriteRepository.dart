import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/models/Books.dart';

class FavoriteRepository {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Books>?> getAllFavoriteBooksByUserID({required String userID}) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection("favorites")
          .where("user_id", isEqualTo: firebaseFirestore.collection("users").doc(userID))
          .get();

      List<Books> books = [];
      if (querySnapshot.docs.isNotEmpty) {
        var favoriteBooks = await querySnapshot.docs.first.reference.collection("books").get();

        for (var doc in favoriteBooks.docs) {
          DocumentReference bookRef = doc.get("book_id");
          var fieldBook = await bookRef.get();
          var book = Books(
            id: fieldBook.id,
            title: fieldBook.get("title"),
            writer: fieldBook.get("writer"),
            imagePath: fieldBook.get("image"),
            description: fieldBook.get("description"),
            language: fieldBook.get("lang"),
            publish: fieldBook.get("publish"),
            page: fieldBook.get("total_page"),
            stock: fieldBook.get("stock"),
          );
          books.add(book);
        }
      }

      return books;
    } catch (e) {
      print(e);
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

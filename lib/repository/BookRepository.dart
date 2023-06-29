import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/models/Books.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class BookRepository {
  final collectionReference = firebaseFirestore.collection("books");

  Future<List<Books>?> getRecommendations() async {
    final documentReference = collectionReference.doc("recommendations");
    try {
      List<Books>? books = [];

      final result =
          await documentReference.get().then((value) => value.data()?["path_books"]).catchError((e) => throw e);

      for (DocumentReference<Map<String, dynamic>> value in result) {
        DocumentSnapshot<Map<String, dynamic>> book = await value.get();
        Map<String, dynamic> detailBook = {"id": book.id}..addAll(book.data()!);
        books.add(Books.fromJson(detailBook));
      }

      return books;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Books>?> getTrends() async {
    final documentReference = collectionReference.doc("trends");
    try {
      List<Books>? books = [];

      final result =
          await documentReference.get().then((value) => value.data()?["path_books"]).catchError((e) => throw e);
      for (DocumentReference<Map<String, dynamic>> value in result) {
        DocumentSnapshot<Map<String, dynamic>> book = await value.get();
        Map<String, dynamic> detailBook = {"id": book.id}..addAll(book.data()!);
        books.add(Books.fromJson(detailBook));
      }

      return books;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Books>?> getNewBooks() async {
    final documentReference = collectionReference.doc("news");
    try {
      List<Books>? books = [];

      final result =
          await documentReference.get().then((value) => value.data()?["path_books"]).catchError((e) => throw e);
      for (DocumentReference<Map<String, dynamic>> value in result) {
        DocumentSnapshot<Map<String, dynamic>> book = await value.get();
        Map<String, dynamic> detailBook = {"id": book.id}..addAll(book.data()!);
        books.add(Books.fromJson(detailBook));
      }

      return books;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Books> getDetailBook({required String id}) async {
    try {
      Books books = Books();
      final data = await collectionReference.doc(id).get().then((value) => value.data());
      if (data != null) {
        Map<String, dynamic> detailBook = {"id": id}..addAll(data);
        books = Books.fromJson(detailBook);
      }

      return books;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

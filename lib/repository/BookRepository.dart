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
      print(e);
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

  Future<Books> getDetailBook({required String id}) async {
    try {
      Books books = Books();
      books = Books.fromJson(await collectionReference.doc(id).get().then((value) => value.data()!));

      return books;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

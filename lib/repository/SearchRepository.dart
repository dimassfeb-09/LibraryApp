import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_splash/cli_commands.dart';

import '../models/Books.dart';

class SearchRepository {
  Future<List<Books>?> searchBooks({required String keyword}) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var querySnapshot = await firebaseFirestore
          .collection("books")
          .where("title", isGreaterThanOrEqualTo: keyword.capitalize())
          .where("title", isLessThanOrEqualTo: '${keyword.capitalize()}\uf8ff')
          .get();

      List<Books>? books = [];
      if (querySnapshot.docs.isNotEmpty) {
        for (var book in querySnapshot.docs) {
          Map<String, dynamic> detailBook = {"id": book.id}
            ..addAll(book.data()!);
          books.add(Books.fromJson(detailBook));
        }

        return books;
      }

      return null;
    } catch (e) {
      print(e);
      print("error");
    }
  }
}

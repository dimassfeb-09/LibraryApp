import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/repository/BookRepository.dart';

import '../models/Books.dart';

class OrderRepository {
  Future<void> orderBooks({required List<Books> books}) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      BookRepository bookRepository = BookRepository();
    } catch (e) {
      rethrow;
    }
  }
}

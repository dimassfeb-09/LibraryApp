import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/models/Books.dart';

class Invoices {
  final String? invoiceID;
  final String? trxID;
  final DateTime? created_at;
  final String? status;
  final List<Books>? books;

  Invoices({this.invoiceID, this.trxID, this.created_at, this.status, this.books = const []});

  factory Invoices.fromJson(Map<String, dynamic> json) {
    return Invoices(
      invoiceID: json['invoice_id'],
      trxID: json['trx_id'],
      created_at: (json['created_at'] as Timestamp).toDate(),
      status: json['status'] ?? '',
      books: json['books'],
    );
  }
}

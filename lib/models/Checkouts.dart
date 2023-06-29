import 'package:library_app/models/Books.dart';

class Checkouts {
  final String id;
  final Books? book;

  Checkouts({this.book, this.id = ''});

  factory Checkouts.fromJson(Map<String, dynamic> json) {
    return Checkouts(
      id: json["id"],
      book: Books.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'book': book?.toJson(),
      };
}

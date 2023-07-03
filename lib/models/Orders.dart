import 'Invoices.dart';

class Orders {
  final String? userID;
  final List<Invoices>? invoices;

  Orders({this.userID = '', this.invoices});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      userID: json['user_id'],
      invoices: json['invoices'],
    );
  }
}

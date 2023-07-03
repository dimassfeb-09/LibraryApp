import 'dart:math';

String generateTransactionId(String userID, String invoiceID) {
  DateTime now = DateTime.now();
  String datetime = now.toIso8601String();
  String randomString = generateRandomString(6); // Change the length of the random string as needed
  String transactionID = datetime + '_' + userID + '_' + invoiceID + '_' + randomString;
  return transactionID;
}

String generateRandomString(int length) {
  const chars = 'tQEGSDGjAGDHajshdasdy23HASHD781623HASDBasdbasdhY2JHSDJFLJJDFYUQTWEasetr12basdbxcfjwertg23y';
  Random random = Random();
  String randomString = '';
  for (int i = 0; i < length; i++) {
    randomString += chars[random.nextInt(chars.length)];
  }
  return randomString;
}

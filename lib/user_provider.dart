import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String accountName = "Mustafa";
  String accountEmail = "Mu575@mail.com";

  void updateUserAttributes(Map<String, String?> userAttributes) {
    accountName = userAttributes['accountUsername'] ?? accountName;
    accountEmail = userAttributes['accountEmail'] ?? accountEmail;
    notifyListeners();
  }
}

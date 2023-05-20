import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String accountEmail = "...";

  void updateAccountEmail(String email) {
    accountEmail = email;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:instagram_clone1/model/user.dart';
import 'package:instagram_clone1/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
   late User _user;
  final AuthMedthod _authMedthod = AuthMedthod();

  User get getUser => _user;

  Future<void> refereshUser() async {
    User user = await _authMedthod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

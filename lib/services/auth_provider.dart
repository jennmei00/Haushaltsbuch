import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/user.dart';
import 'package:haushaltsbuch/services/DBHelper_user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  DBHelperUser? _dbHelperUser;

  AuthProvider() {
    _dbHelperUser = DBHelperUserImpl();
  }

  User? get currentUser => _currentUser;

  Future<void> registerUser(String username, String password,
      int securityQuestionIndex, String securityAnswer) async {
    //register user and safe in database
    User newUser = User(
        name: username,
        password: password,
        securityQuestionIndex: securityQuestionIndex,
        securityAnswer: securityAnswer,
        bioAuth: false);
    await _dbHelperUser!.addUser(newUser.toMap());

    _currentUser = newUser;
    notifyListeners();
  }

  Future<String> getUserName() async {
    User user = User.fromMap(await _dbHelperUser!.getUser());
    return user.name;
  }

  Future<bool> loginUser(String password) async {
    User user = User.fromMap(await _dbHelperUser!.getUser());
    if (user.password == password) {
      _currentUser = user;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> logoutUser() async {
    _currentUser = null;
    notifyListeners();
  }
}

import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';


class UserProvider with ChangeNotifier{
  UserModel? user;
  UserModel get getUser=>user!;
  final AuthMethods _authMethods=AuthMethods();

  Future<void> refreshUser() async{
    UserModel _user=await _authMethods.getUserDetails();
    user=_user;
    notifyListeners();
  }


}
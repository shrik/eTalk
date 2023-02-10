import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../features/my/utility/shared_preference.dart';
import '../classes/classes.dart';
import 'api_req.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  User? _user;
  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  Future<AuthProvider> initialize() async {
    bool userExists = await UserPreferences().userExists();
    if(!userExists){
      this._loggedInStatus = Status.NotLoggedIn;
    }else{
      this._loggedInStatus = Status.LoggedIn;
      _user = await UserPreferences().getUser();
    }
    return this;
  }

  User getUser(){
    return _user!;
  }

  Future<Map<String, dynamic>> register({required String username,
    required String password, required String sms_code}) async {
    final Map<String, String> apiBodyData = {
      'mobile': username,
      'password': password,
      'sms_code': sms_code
    };

    return await ApiReq.register(apiBodyData);
  }


  notify(){
    notifyListeners();
  }

  static Map<String, dynamic> onValue (Response response) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData;
  }

  void logout() {
    UserPreferences().removeUser();
    _loggedInStatus = Status.NotLoggedIn;
    _user = null;
    notify();
  }

  Future<Map<String, dynamic>> login(String phone, String password) async {

    var result;

    final Map<String, dynamic> loginData = {
      'mobile': phone,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      ApiReq.loginUri(),
      body: loginData,
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if(responseData["status"] as String == "FAIL"){
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'status': false,
          'message': responseData["msg"]
        };
      }else{
        var userData = responseData['result']['user'];
        User authUser = User.fromJson(userData);
        UserPreferences().saveUser(authUser);
        _user = authUser;
        _loggedInStatus = Status.LoggedIn;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'user': authUser};
      }

    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': "Server Error!"
      };
    }

    return result;

  }


  static Map<String, dynamic> onError(error){
    print('the error is ${error.detail}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }


}
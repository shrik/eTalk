
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/classes/classes.dart';

class UserPreferences {

  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId',user.userId);
    prefs.setString('name',user.name);
    prefs.setString('phone',user.phone);
    prefs.setString('type',user.type);
    prefs.setString('token',user.token);

    return prefs.commit();

  }

  // Please check auth status before using
  // auth.loggedinStatus should be Loggedin
  Future<User> getUser ()  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId")!;
    String name = prefs.getString("name")!;
    String phone = prefs.getString("phone")!;
    String type = prefs.getString("type")!;
    String token = prefs.getString("token")!;
      return User(
          userId: userId,
          name: name,
          phone: phone,
          type: type,
          token: token,
          renewalToken: "");
  }

  Future<bool> userExists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("userId");
  }

  void removeUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('userId');
    prefs.remove('name');
    prefs.remove('phone');
    prefs.remove('type');
    prefs.remove('token');

  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    return token;
  }

}
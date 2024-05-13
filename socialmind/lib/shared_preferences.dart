import 'package:shared_preferences/shared_preferences.dart';

class SP {
  static String LogInStatus = 'userLogInStatus';
  static String userName = "userName";
  static String email = "email";

  static Future<bool> setLogInStatus(isLoggedIn) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setBool(LogInStatus, isLoggedIn);
  }

  static Future<bool> setEmail(email) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(email, email);
  }

  static Future<bool> setUserName(userName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userName, userName);
  }

  static Future getLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.getBool(LogInStatus);
  }

  static Future deleteloginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.clear();
  }
}

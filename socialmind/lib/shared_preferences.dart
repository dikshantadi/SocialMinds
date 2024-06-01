import 'package:shared_preferences/shared_preferences.dart';

class SP {
  static String LogInStatus = 'userLogInStatus';
  static String userNameKey = "userName";
  static String emailKey = "email";

  static Future<bool> setLogInStatus(isLoggedIn) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setBool(LogInStatus, isLoggedIn);
  }

  static Future<bool> setEmail(email) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(emailKey, email);
  }

  static Future<bool> setUserName(userName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final status = await sp.setString(userNameKey, userName);
      return status;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future getLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.getBool(LogInStatus);
  }

  static Future deleteloginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.clear();
  }

  static Future getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final userName1 = await sp.getString(userNameKey);
    return userName1;
  }
}

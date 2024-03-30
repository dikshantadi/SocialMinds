import 'package:shared_preferences/shared_preferences.dart';

class SP {
  String? LogInStatus;
  String? userName;
  String? email;

  Future setLogInStatus(bool isLoggedIn) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(LogInStatus!, isLoggedIn);
  }

  Future setEmail(String email) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(email, email);
  }

  Future setUserName(String userName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(userName, userName);
  }
}

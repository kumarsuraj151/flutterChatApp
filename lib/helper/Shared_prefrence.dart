import 'package:shared_preferences/shared_preferences.dart';

class HeperFunction {
  static String userLoggedInKey = "USERLOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // saving the data into sf
  static Future<bool> saveUserLoggedIn(bool userlogged) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, userlogged);
  }

  static Future<bool> saveUserName(String userlogged) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userlogged);
  }

  static Future<bool> saveUserEmail(String userlogged) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userlogged);
  }

  //getting the data from sf
  static Future<bool?> getUserLogginStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUsername() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return  sf.getString(userNameKey);
  }

  static Future<String?> getUseremail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return  sf.getString(userEmailKey);
  }
}

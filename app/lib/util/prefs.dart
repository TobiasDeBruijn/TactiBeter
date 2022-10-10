import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<String?> getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("sessionid");
  }

  static Future<void> setSessionId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sessionid", id);
  }

  static Future<void> removeSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("sessionid");
  }
}
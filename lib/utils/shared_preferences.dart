import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  getUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('auth');
    return status ?? false;
  }
}

import 'package:b2b/modal/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  static Future<void>  setSecreteKey(String key) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(secret_key, key);
     return;
  }
  static Future<String?>  getSecreteKey(String key) async{
    final SharedPreferences prefs = await _prefs;
    String? secrete_key =   await prefs.getString(secret_key);
    return secrete_key;
  }
}
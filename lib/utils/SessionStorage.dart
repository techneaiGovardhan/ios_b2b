import 'package:b2b/database/db_helper.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  //late Future<int> _counter;


  static Future<void> setLastUpdatedAt(String lastUpdatedat) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(last_updated_at, lastUpdatedat);
    return;
  }

  static Future<String?> getLastUpdatedAt() async{
    String? lastUpdatedAt;
    final SharedPreferences prefs = await _prefs;
    lastUpdatedAt = await prefs.getString(last_updated_at);
    return lastUpdatedAt;
  }

  static Future<void>  setSecreteKey(String key) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(secret_key, key);
     return;
  }

  static Future<String?>  getSecreteKey() async{
    final SharedPreferences prefs = await _prefs;
    String? secrete_key =   await prefs.getString(secret_key);
    return secrete_key;
  }

  static Future<bool> isFirstTimeSync() async{
    final SharedPreferences prefs = await _prefs;
    bool? secrete_key =   await prefs.getBool(is_first_time_sync);
    if(secrete_key != null)
    return secrete_key;
    else {
      secrete_key = true;
      return secrete_key;
    };

   }
   static setFirstTimeSync() async{
    try {
       final SharedPreferences prefs = await _prefs;
       await prefs.setBool(is_first_time_sync, false);
    }catch(ex){

    }
   }
   static setMacAddress(macAddress) async{
    try{
      final SharedPreferences prefs = await _prefs;
      await prefs.setString(mac_address,macAddress);
    }catch(ex){

    }
   }
   static Future<String?> getCustomerMobileno() async{
     try {
       final SharedPreferences prefs = await _prefs;
        return   await prefs.getString(customer_mobile_no);
     }catch(ex){
            return null;
     }
   }
  static setCustomerMobileno(String mobileno) async{
    try {
      final SharedPreferences prefs = await _prefs;
      await prefs.setString(customer_mobile_no, mobileno);
    }catch(ex){

    }
  }


  static Future<String?> getMacaddress() async {
    try{
      final SharedPreferences prefs = await _prefs;
     return  await prefs.getString(mac_address);
    }catch(ex){
      return "";
    }
  }

  static  logout() async{
    try{
      final SharedPreferences prefs = await _prefs;
      prefs.remove(employee_id);
      prefs.remove(customer_mobile_no);
    //  prefs.remove(s)
      //prefs.remove(mac_address);
      return ;
    }catch(ex){
      return "";
    }
  }
 static Future<int?> getEmployeeId() async{
   final SharedPreferences prefs = await _prefs;
   return prefs.getInt(employee_id);
 }
  static setEmployeeId(String text) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(employee_id,int.parse(text));

  }
  static Future<String?> getEmployeeName() async {
    final SharedPreferences prefs = await _prefs;
    return  await prefs.getString(employee_name);

  }

  static setEmployeeName(String text) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(employee_name,text);
  }

  static getSavedFilter() async{
    final SharedPreferences prefs = await _prefs;
    return  await prefs.getString(filter);
  }

  static saveFilter(String filterd_string) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(filter,filterd_string);
  }
}
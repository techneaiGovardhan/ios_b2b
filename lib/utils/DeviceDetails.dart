import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart' show PlatformException;
//import 'package:get_mac/get_mac.dart';
// ignore: import_of_legacy_library_into_null_safe
//import 'package:get_mac/get_mac.dart';
//import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:package_info/package_info.dart';

class DeviceDetails {


static  Future<String>  getVersion() async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return  packageInfo.version;
}
  static Future<String>  getMacAddress() async {
      //String platformVersion;
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) { // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return await iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        return "";
       // return await GetMac.macAddress;// unique ID on Android
      }



    }


}
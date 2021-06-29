import 'package:flutter/services.dart' show PlatformException;
// ignore: import_of_legacy_library_into_null_safe
import 'package:get_mac/get_mac.dart';

class DeviceDetails {

  static Future<String?>  getMacAddress() async {
      String platformVersion;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        platformVersion = await GetMac.macAddress;
      } on PlatformException {
        platformVersion = 'Failed to get Device MAC Address.';
      }

      return platformVersion;
    }


}
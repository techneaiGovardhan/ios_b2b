import 'package:b2b/modal/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class DeviceVerification{
   //VoidCallback? deviceVerificationResponse;

   void verifyMacAddress(String mac_address,String secrete_key,Function deviceVerificationResponse, BuildContext context) async{
     String url = macVerification;
     var map = new Map<String,dynamic> ();
     map['macAddress'] = mac_address;
     map['secretKey'] = secrete_key;
     // var macbody ={
     //    "macAddress":mac_address,
     //    "secreteKey":secrete_key
     // };
     http.post(Uri.parse(url),body:map,).
     then((response) => deviceVerificationResponse(response.body,context));

   }

}
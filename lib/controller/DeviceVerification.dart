import 'package:b2b/modal/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class DeviceVerification{
   //VoidCallback? deviceVerificationResponse;

   void verifyMacAddress(String mac_address,String secrete_key,Function deviceVerificationResponse, BuildContext context) async{
     String url = macVerification;
     var macbody ={
        "macAddress":mac_address,
        "secreteKey":secrete_key
     };
     http.post(Uri.parse(url),body:macbody).then((response) => deviceVerificationResponse(response.body,context));

   }

}
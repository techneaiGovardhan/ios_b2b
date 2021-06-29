
import 'dart:convert';
import 'dart:io';

import 'package:b2b/controller/DeviceVerification.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/view/SyncWidget.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/utils/DeviceDetails.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
 static const String _mac_address="00:0a:95:9d:68:16";
 static const String highlighting_message="Please wait verifying device";
 static const String powered_by="Powered by techneai";
 static const String _version="Version:1.0.0";
   Login({required Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool msecretekey=false;
  String? mSecreteKey;
  TextEditingController secrete_key_controller = TextEditingController();
  late String mMacaddress="1.1.1.1";
  DeviceVerification _deviceVerification = new DeviceVerification();
  @override
  void initState() {
    // TODO: implement initState
    getSecreteKey();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: SafeArea(
             child:Column(
               children: [
                     _logo(),
                     _deviceId(Login._mac_address),
                     _highlight_verifying(Login.highlighting_message),
                     _footer()
                ],
        ) ,
      ),
    );

  }

  _logo(){
    return(
        Expanded(
            flex: 1,
            child:
              Container(
                 child:
                    Image.asset("assets/logo.png",
                       height: 80,width: 80
              )
        )
      )
    );
  }

  _deviceId(String macAddress) {
    return Expanded(
      flex: 3,
      child: FutureBuilder<String?>(future:DeviceDetails.getMacAddress() ,builder:(context,data)
          {
            if(data.hasData) {
             mMacaddress = data.data!;
              return Center(
                  child: Text(data.data!,style: CustomStyles.mediumTextstyle())
              );
            }
            else{
              return Text(macAddress);
            }
          },
    ));
  }

  _highlight_verifying(String highlightingMessage) {
    return Expanded(
      flex: 1,
      child: Container(
        child:Text(highlightingMessage)
       ),
    );
  }

  _footer() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Login._version),
            SizedBox(
              height: 5,
            ),

            Text(Login.powered_by)
          ],
        ),
      ),
    );
  }

   getSecreteKey()  async{
   String? secreteKey =  await SessionStorage.getSecreteKey(secret_key);
   DeviceDetails.getMacAddress().then((value)
   {
      if(secreteKey == null){
           showAlertDialog(context: context, title: key, contentWidget:showSecreteKey(), cancelActionText: "Save", defaultActionText: "Cancle");
           mMacaddress = value!;
      }
     else{
     verify_mac_device(value!,secreteKey,context);
     }
   }
   );


  //  msecretekey = msecretekey;


  }

  showSecreteKey(){
    return Container(
      child: TextField(
        decoration: CustomStyles.customTextFieldStyle(enter_secrete_key, false, 0),
        onChanged: (value)=>{
          this.setState(() {
            mSecreteKey =value;
          })
        },
        controller: secrete_key_controller,
      ),
    );
  }

Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required Widget contentWidget,
    required String cancelActionText,
    required String defaultActionText,
  }) async {
    if (!Platform.isIOS) {
      return
        showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: contentWidget,
          actions: <Widget>[
            if (cancelActionText != null)
              FlatButton(
                child: Text(cancelActionText),
                onPressed: () => saveSecreteKey(),
              ),
            FlatButton(
              child: Text(defaultActionText),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
        );
    }

    // todo : showDialog for ios
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: contentWidget,
        actions: <Widget>[
          if (cancelActionText != null)
            CupertinoDialogAction(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          CupertinoDialogAction(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  saveSecreteKey() async{
    await SessionStorage.setSecreteKey(mSecreteKey!);
    Navigator.of(context).pop(false);
    verify_mac_device(mMacaddress, mSecreteKey!, context);
  }

  void verify_mac_device(String _macAddress, String secreteKey,BuildContext context) {
 _deviceVerification.verifyMacAddress(_macAddress, secreteKey, onMacVerificationResponse,context);
  }

  onMacVerificationResponse(response,BuildContext context){
  dynamic res =   jsonDecode(response);
  int status = res['status'];
  String message = res['message'];
  if(status ==  1){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>SyncWidget(key: Key("sync"))));
  }
  else{
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
   SystemNavigator.pop();
  }
}

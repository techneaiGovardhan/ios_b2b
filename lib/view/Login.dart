
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:b2b/controller/DeviceVerification.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/view/CustomerEntryWidget.dart';
import 'package:b2b/view/SyncWidget.dart';
import 'package:b2b/view/customViews/ResuableWidgets.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/utils/DeviceDetails.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:wifi_info_plugin/wifi_info_plugin.dart';

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
  //late WifiInfoWrapper _wifiObject;
  bool msecretekey=false;
  String? mSecreteKey;
  ScreenUtils? _screenUtils;
  TextEditingController mac_addres_controller = TextEditingController();
  TextEditingController secrete_key_controller = TextEditingController();
  late String? mMacaddress="1.1.1.1";

  DeviceVerification _deviceVerification = new DeviceVerification();
  final String viewType = 'collectionview';
  // Pass parameters to the platform side.
  ResuableWidgets? resuableWidgets ;
  final Map<String, dynamic> creationParams = <String, dynamic>{};
  @override
  void initState() {
    // TODO: implement initState

   init_methods();
    super.initState();
  }
  late Timer _timer;
  int _start = 10;

  List<Widget>? syncMasters = [];

  void startTimer()  async{
     const oneSec = const Duration(seconds: 2);
     _timer = new Timer(oneSec,(){
         verify_mac_device(mMacaddress, mSecreteKey!, context);
     });


  }

  init_methods() async{

    _screenUtils = ScreenUtils(context: context);
    resuableWidgets = ResuableWidgets();
    await  getSecreteKey();

    if(!await SessionStorage.isFirstTimeSync()){
       mMacaddress = await SessionStorage.getMacaddress();
       startTimer();
    }


  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: SafeArea(
             child:Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
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
            // mMacaddress = data.data!;
              return
                !Platform.isIOS ?
                Center(
                  child: Text(data.data!,style: CustomStyles.mediumTextstyle(context),textAlign: TextAlign.center,)
              ): Center(
                    child:
                    Form(
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         FutureBuilder<String?>(builder: (context,data){
                         //  if(data.hasData){
                             if(data.data != null){
                              return Text(data.data!,style: CustomStyles.mediumTextstyle(context),);
                           }
                           else{
                             return   Container(
                                 margin: EdgeInsets.only(left: 15,right: 15),
                                 child: Column(
                                   children: [
                                     TextFormField(
                                       controller: mac_addres_controller,
                                       decoration: CustomStyles.customTextFieldStyle(enter_mac_address, true, 15),
                                       style: CustomStyles.mediumTextstyle(context),textAlign: TextAlign.center,)
                                     , _size20(),
                                     _save()
                                   ],
                                 )
                                   );

                           }
                             //}
                           //}
                         },future: getMacAddress(),)


                      ],
                    )
                )
          );
            }
            else{
              return Text(macAddress);
            }
          },
    ));
  }
  _size20() {
    return SizedBox(
        height: 20
    );
  }

  _save() {
    return (
        Container(
          child:
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                width: _screenUtils!.getWidthPercent(30),
                height: _screenUtils!.getHeightPercent(6)),

            child: ElevatedButton(onPressed: () {
            //  verify_mac_device(mac_addres_controller.text,   mSecreteKey!, context);
            saveMacAddress(mac_addres_controller.text,mSecreteKey!,context);
            },
              style: CustomStyles.customButtonStyle(),
              child: Text("Save", style: CustomStyles.buttonText(context),),

            ),
          ),
        )
    );
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
        margin: EdgeInsets.only(bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: DeviceDetails.getVersion(),
              builder: (context,data){
                if(data.hasData) {
                  return Text(version_string+data.data!,style: CustomStyles.smallTextStyle(context),);
                }
                else{
                  return Text("");
                }
              },
            ),
            SizedBox(
              height: 5,
            ),

            Text(Login.powered_by),

            // Platform.isIOS ?
            // SizedBox(
            //   height:MediaQuery.of(context).size.height-20,
            //   child: UiKitView(viewType: viewType,
            //     ),
            // )
            // :AndroidView(viewType: viewType)

          ],
        ),
      ),
    );
  }
  saveMacAddress(String mac_address,String? secreteKey,BuildContext context) async{

    verify_mac_device(mac_address,secreteKey!, context);

  }

   getSecreteKey()  async{
   mSecreteKey =  await SessionStorage.getSecreteKey();
   if(mSecreteKey == null){
          resuableWidgets!.showAlertDialog(context: context, title: key, contentWidget:showSecreteKey(), cancelActionText: "Save",
          okCallBack: saveSecreteKey);
    }
   // DeviceDetails.getMacAddress().then((value)
   // {
   //    if(mSecreteKey == null){
   //      resuableWidgets!.showAlertDialog(context: context, title: key, contentWidget:showSecreteKey(), cancelActionText: "Save", defaultActionText: "Cancle",
   //      okCallBack: saveSecreteKey);
   //         mMacaddress = value!;
   //    }
   //   else{
   //       verify_mac_device(value!,mSecreteKey!,context);
   //   }
   // }
   //);


  //  msecretekey = msecretekey;


  }

  showSecreteKey(){
    return Center(
      child:
      Platform.isIOS ?ios_body():android_body()
    );
  }

  ios_body(){
   return Container(
     margin: EdgeInsets.only(top: marging_top),
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child:Stack (
         children:[
            Container(
              height: _screenUtils!.getHeightPercent(20),
            child: Material(
              color: Colors.transparent,
              child: TextField(
                decoration: CustomStyles.customTextFieldStyle(enter_secrete_key, true, radius_10),
                onChanged: (value)=>{
                  this.setState(() {
                    mSecreteKey = value;
                  })
                },
                controller: secrete_key_controller,
              ),
            ),
          ),
           Positioned(
             left: 0,
             right: 0,
             bottom: 0,
             child: Row(
               children: [
                 Expanded(
                     flex: 1,
                     child: ElevatedButton(
                   style: CustomStyles.customButtonStyle(),
                   onPressed: () {
                     saveSecreteKey();
                   },
                   child: Text("Submit"),
                 ))
               ],
             ),
           )
         ],
       ),
     ),
   );
  }
  android_body(){
  return  Container(
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



void saveSecreteKey() async{
  Navigator.of(context).pop(false);
     // mSecreteKey =
    //await SessionStorage.setSecreteKey(mSecreteKey!);
  //  Navigator.of(context).pop(false);
    //verify_mac_device(mMacaddress, mSecreteKey!, context);
  }

  void verify_mac_device(String? _macAddress, String secreteKey,BuildContext context) {
    _deviceVerification.verifyMacAddress(_macAddress!, secreteKey, onMacVerificationResponse,context);
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>CustomerEntryWidget(key: Key("Entrywidget"))));

  }

  onMacVerificationResponse(response,BuildContext context) async{
     dynamic res =   jsonDecode(response);
     int status =     res['status'];
     String message = res['message'];
     if(status ==  1){
       if(await SessionStorage.isFirstTimeSync()) {
         await SessionStorage.setMacAddress(mac_addres_controller.text);
         await SessionStorage.setSecreteKey(mSecreteKey!);
        // Navigator.of(context).pop();
         Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (_) => SyncWidget(key: Key("sync"))));
       }
       else{
         //Navigator.of(context).pop();
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>CustomerEntryWidget(key: Key("Entrywidget"))));
       }
     }
     else{
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>SyncWidget(key: Key("sync"))));
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
      // SystemNavigator.pop;
  }

 Future<String?> getMacAddress() async {
    return await SessionStorage.getMacaddress();
  }
}

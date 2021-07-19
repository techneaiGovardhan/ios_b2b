import 'dart:io';

import 'package:b2b/controller/common_methods.dart';
import 'package:b2b/modal/ProductDetails.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/view/customViews/search_body_widget.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/ScreenUtils.dart';
import '../OrderViewWidget.dart';

class ResuableWidgets{

  VoidCallback? okCallback;
  VoidCallback? cancleCallback;


 static Widget AppLogo(String path,String url,BuildContext context){
  ScreenUtils? screenUtils = new ScreenUtils(context:context );

    return(
        InkWell(
          child:
              url == empty_string ?
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Image.asset(
                    path,
                 width:screenUtils!.getWidthPercent(30) ,
                 height: screenUtils!.getHeightPercent(30),
            ),
             ):Padding(
               padding: const EdgeInsets.all(8.0),
               child: Image.network(url,
                  width:screenUtils!.getWidthPercent(30) ,
                height: screenUtils!.getHeightPercent(40),),
             )
        )
    );
  }

 static  Widget BottomView(ScreenUtils? _screenUtils,BuildContext context,int? product_id){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height:_screenUtils!.getHeightPercent(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: OutlineButton(
                onPressed:(){
                  Navigator.of(context).pop();
                },
                child:Text("Back",
                  style: CustomStyles.headingText(context),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: CustomStyles.customButtonStyle(),
                  onPressed:() {
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder:(_)=>
                            OrderViewWidget(product_id)
                        )
                    );
                  },
                  child: Text("Order",
                    style: CustomStyles.title_with_white_text(context),)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showAlertDialog({
   required BuildContext context,
   required String title,
   required Widget contentWidget,
   String? cancelActionText,
    String? defaultActionText,
    required VoidCallback okCallBack
 }) async {
   if (!Platform.isIOS) {
     return
       showDialog(
         context: context,
         builder: (context) => AlertDialog(
           title: Text(title,style: CustomStyles.headingText(context),),
           content: contentWidget,
           actions: <Widget>[
             cancelActionText != null ?
               FlatButton(
                 textColor: color1,
                 color: color1,
                 child: Text(cancelActionText,style: CustomStyles.headingText(context),),
                 onPressed: () => okCallBack,
               ):Container(),
             defaultActionText != null ?
             FlatButton(
               color: color1,
               textColor: color1,
               child: Text(defaultActionText,textAlign: TextAlign.center,style: CustomStyles.headingText(context),),
               onPressed: () => Navigator.of(context).pop(true),
             ):Container(),
           ],
         ),
       );
   }

   // todo : showDialog for ios
   return showCupertinoDialog(
     context: context,
     builder: (context) => CupertinoAlertDialog(
       title: Text(title,style: CustomStyles.headingText(context),),
       content: contentWidget,
       // actions: <Widget>[
       //   cancelActionText != null ?
       //     Row(
       //       children: [
       //         Expanded(
       //           flex: 1,
       //           child: CupertinoDialogAction(
       //             child: Text(cancelActionText,style: CustomStyles.headingText(context),),
       //             onPressed: () => okCallBack() ,
       //           ),
       //         ),
       //       ],
       //     ):Container(),
       //    defaultActionText != null ?
       //    Expanded(
       //      flex: 1,
       //      child: CupertinoDialogAction(
       //       child: Text(defaultActionText!,style: CustomStyles.headingText(context),),
       //       onPressed: () => Navigator.of(context).pop(true),
       //      ),
       //    ):
       //  Container(),
       // ],
     ),
   );
 }
  showSimpleModalDialog(BuildContext context,List<Map<String,dynamic>> employeeList,Function selectedEmployee){
   ScreenUtils _screenUtils = ScreenUtils(context: context);
   CommonMethods commonMethods = CommonMethods();
   TextEditingController search_text_controller = TextEditingController();
      return showDialog(context: context, builder:(BuildContext context) {
        List<Map<String,dynamic>> memployeeList = employeeList;
        return StatefulBuilder(builder: (context,setState){
             return(
               Dialog(
                  shape:ContinuousRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(radius_10))
                  ),
                 child:SearchBodyWidget(
                   context,memployeeList,_screenUtils,commonMethods,selectedEmployee,search_text_controller
                 )

                 // search_widget_body(
                 //                   context, memployeeList, _screenUtils,
                 //                   setState,search_text_controller, commonMethods),
              )
        );

      }

      );
  });
}
  search_widget_body(context, List<Map<String,dynamic>> employeeList,ScreenUtils screenUtils,
      StateSetter setState,TextEditingController search_text_controller, CommonMethods commonMethods,
      ) {
    return
      SingleChildScrollView(

        child: Column(
          children: [
            Platform.isIOS ? _IOSheading(context,screenUtils) : _Androidheading(),
            Platform.isIOS ? _IOSBody(context, employeeList,screenUtils,setState,
                search_text_controller,commonMethods,employeeList) : _AndroidBody()
          ],
        ),
      );

  }
  _IOSheading(context,ScreenUtils _screenUtils) {
    return Column(
      children: [

        Container(
          width: MediaQuery.of(context).size.width,
          height: _screenUtils.getHeightPercent(8),
          decoration: BoxDecoration(
              color: color1
          ),
          child: Center(
            child: Text("Search Employee",style: CustomStyles.title_with_white_text(context)),
          ),
        ),



      ],
    );
  }
  _Androidheading() {

  }

  _AndroidBody() {

  }

  _IOSBody(context, List<Map<String,dynamic>> employeeList,ScreenUtils screenUtils,
      StateSetter setState,TextEditingController search_text_controller,
      CommonMethods commonMethods,List<Map<String,dynamic>> memployeeList) {
    return (
        _employeeListWidget(employeeList,screenUtils,context,setState,search_text_controller,commonMethods,employeeList)
    );
  }

  _employeeListWidget(List<Map<String,dynamic>> employeeList,ScreenUtils _screenUtils,BuildContext context, StateSetter setState,TextEditingController search_text_controller,CommonMethods commonMethods,List<Map<String,dynamic>> memployeeList) {

   return
      Container(
          width: double.maxFinite,
          height: _screenUtils!.getHeightPercent(80),
          child:
          Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                      Expanded(
                          flex: 1,
                          child:
                          Material(
                            color: Colors.transparent,
                            child: TextFormField(
                              decoration: CustomStyles.customTextFieldStyle(
                                  "Type name to search", true, 0),
                              style: CustomStyles.headingText(context),
                              controller: search_text_controller,
                              onChanged: (value)=>filterList(value,setState,commonMethods,memployeeList),
                            ),

                          )
                      ),
                      // Expanded(
                      //     flex:4,
                      //     child:
                      //     Material(
                      //       color: Colors.transparent,
                      //       child:TextField(
                      //         decoration: CustomStyles.customTextFieldStyle("Search here", false, 0),
                      //         style: CustomStyles.mediumTextstyle(context),
                      //
                      //       ) ,
                      //     )
                      // )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        custom_employee_widget(employeeList[index], index,context),
                    itemCount: employeeList.length,
                  ),
                )
              ]
          )
      );
  }
  filterList(String value,StateSetter setState, CommonMethods commonMethods,List<Map<String,dynamic>> memployeeList) async {
    List<Map<String,dynamic>> list=  await commonMethods!.searchEmpByName(value);
    setState(() {
      memployeeList = list;
    });
  }

// resuable employee widget for each list item
  custom_employee_widget(Map<String,dynamic> employeeList, int index,BuildContext context) {
    return GestureDetector(
      onTap: () =>
      {
        //selected_employee(index)
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (
            Container(
                child:
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text((index+1).toString(),style: CustomStyles.smallTextStyle(context),)
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                            employeeList['employee_id'].toString(),style: CustomStyles.smallTextStyle(context)
                        )),
                    Expanded(
                        flex: 4,
                        child: Text(
                            employeeList['employee_nm'],style: CustomStyles.smallTextStyle(context)
                        )

                    )
                  ],
                )
            )
        ),
      ),
    );
  }
}
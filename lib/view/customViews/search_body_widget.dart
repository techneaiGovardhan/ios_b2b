import 'dart:collection';
import 'dart:io';

import 'package:b2b/controller/common_methods.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/material.dart';

class SearchBodyWidget  extends StatefulWidget {
  //const ({Key? key}) : super(key: key);

  BuildContext? _context;
  List<Map<String,dynamic>> ? memployeeList;
  ScreenUtils? screenUtils ;
  CommonMethods commonMethods;
  Function selectedEmployee;
  TextEditingController search_text_controller;

  SearchBodyWidget(
      this._context,
      this.memployeeList,
      this.screenUtils,
      this.commonMethods,
      this.selectedEmployee,
      this.search_text_controller); // context, memployeeList, _screenUtils,
  // setState,search_text_controller, commonMethods


  @override
  _State createState() => _State(memployeeList,selectedEmployee);
}

class _State extends State<SearchBodyWidget> {

  List<Map<String,dynamic>> ? memployeeList;
  Function selectedEmployee;
  _State(this.memployeeList,this.selectedEmployee);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Column(
        children: [
          Platform.isIOS ? _IOSheading(context,widget.screenUtils!) : _Androidheading(),
          Platform.isIOS ? _IOSBody(widget._context, memployeeList!,widget.screenUtils!,
              widget.search_text_controller,widget.commonMethods) : _AndroidBody()
        ],
      ),
    );;
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
      TextEditingController search_text_controller,
      CommonMethods commonMethods) {
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
                              onChanged: (value)=>filterList(value,commonMethods),
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
  filterList(String value,CommonMethods commonMethods) async {
    List<Map<String,dynamic>> list=  await commonMethods!.searchEmpByName(value);
    setState(() {
      memployeeList = list;
    });
  }

// resuable employee widget for each list item
  custom_employee_widget(Map<String,dynamic> employeeList, int index,BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        selectedEmployee(employeeList);
        Navigator.of(context).pop();

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


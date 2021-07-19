
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:b2b/controller/common_methods.dart';
import 'package:b2b/database/database.dart';
import 'package:b2b/database/db_helper.dart';
import 'package:b2b/modal/client_master.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/modal/constants/dummy_data.dart';
import 'package:b2b/utils/DeviceDetails.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/Dashboard.dart';
import 'package:b2b/view/customViews/ResuableWidgets.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/ScreenUtils.dart';
import 'Login.dart';
class CustomerEntryWidget extends StatefulWidget {
  const CustomerEntryWidget({required Key key}) : super(key: key);

  @override
  _CustomerEntryWidgetState createState() => _CustomerEntryWidgetState();
}

class _CustomerEntryWidgetState extends State<CustomerEntryWidget> {
  ScreenUtils? _screenUtils;
  ResuableWidgets? resuableWidgets;
  Map<String, String>? _selectedEmployee;
  mDatabase? mDatababase;
  DummyData? dummyData;
  String? employee_name;
  List<Map<String,dynamic>>? memployeeList;
  CommonMethods? commonMethods;
  File? logo = null;
  TextEditingController search_text_controller=TextEditingController();
  TextEditingController employee_id_controller = TextEditingController();
  TextEditingController employeename_controller = TextEditingController();
  TextEditingController customer_mobile_controller = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  _init_methods();
    //memployeeList = DummyData.getDummyEmployee();
  }

  getEmployeeList(){
   mDatababase!.getRecordsAll(DbHelper.tbl_employee_master)
                .then(
                (value)=>{
                       memployeeList = value
                  }
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.zero,
              width: _screenUtils!.getWidthPercent(80),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: logo != null ? Image.asset("assets/logo1.png",width:_screenUtils!.getWidthPercent(30) ,
                    height: _screenUtils!.getHeightPercent(30)):Image.asset("assets/logo1.png",width:_screenUtils!.getWidthPercent(30) ,
                    height: _screenUtils!.getHeightPercent(30))),
                    _customerNo(),
                    _size20(),
                    _empNameContainer(context),
                    _size20(),
                    _size20(),
                    _save(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _footer(),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
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
              saveCustomer();
            },
              style: CustomStyles.customButtonStyle(),
              child: Text("Submit", style: CustomStyles.buttonText(context),),

            ),
          ),
        )
    );
  }

  _customerNo() {
    return (
        Container(
          decoration: CustomStyles.boxDecoration(),
            padding: EdgeInsets.all(5),
            width: _screenUtils!.getWidthPercent(80),
            child:
            TextFormField(
              maxLength: 10,
              textAlign: TextAlign.center,
              validator: (value){
                RegExp regex = new RegExp(mobileRegex);
                if(value!.isEmpty){
                  return "Enter customer mobile no";
                  }
                  else if(!regex.hasMatch(value)){
                   return "Enter valid mobile no";
                  }
              },
              keyboardType: TextInputType.number  ,
              controller: customer_mobile_controller,
              decoration: CustomStyles.customTextFieldStyle(
                  "Customer number", false, 0),
            )
        )
    );
  }
  // employee view container
  _empNameContainer(BuildContext context) {
    return Container(
      width: _screenUtils!.getWidthPercent(90),
      padding: const EdgeInsets.all(2),
      decoration: CustomStyles.boxDecoration(),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child:
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          validator: (value){
                          if(value!.isEmpty){
                            return "Enter valid Emp Id";
                          }
                          },
                          keyboardType: TextInputType.number,
                          controller: employee_id_controller,
                          decoration: CustomStyles.customTextFieldStyle(
                              "Emp Id", false, 0),
                          onChanged: (value)=>getEmployeeName(value),
                        ),
                      ),
                      _verticalDivider(),
                    ],
                  ),
                )
            ),
            Expanded(
                flex: 2,
                child: TextFormField(
                  readOnly: true,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter valid customer name";
                    }
                  },
                  controller:employeename_controller,
                  decoration: CustomStyles.customTextFieldStyle(
                      "Employee name", false, 10),
                )),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                  child: InkWell(
                    onTap: () {
                      _showEmployeeSearch(memployeeList!,context);
                    },
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: color1,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  _verticalDivider() =>
      Container(
        margin: EdgeInsets.only(left: marging_top,right: marging_top),
        width: 1,
        height: _screenUtils!.getHeightPercent(6),
        color: color1,
      );

  void saveCustomer()  async{
     mDatabase db = mDatabase();
     int records = await db.getRecords(DbHelper.tbl_posCustomerDetails);
     Map<String,dynamic> row = Map<String,dynamic> ();
     row['id'] = records+1;
     row['client_id'] = DbHelper.client_id;
     row['pos_id']    = DbHelper.pos_id;
    // row['mac_address'] = await SessionStorage.getMacaddress();
     row['customer_mobile_no'] = customer_mobile_controller.text;
     row['employee_id'] = employeename_controller.text;
     row['created_at'] = DbHelper.pos_id;
     row['in_dt'] = DateFormat.yMd().format(DateTime.now()) + " " +DateFormat.jms().format(DateTime.now());
     row['created_by'] = int.parse(employee_id_controller.text);
     row['updated_by'] = int.parse(employee_id_controller.text);
     row['out_dt'] = DateFormat.yMd().format(DateTime.now()) +" " +DateFormat.jms().format(DateTime.now());
     row['is_active'] = "1";
     await   db.insertCustomerDetails(row);
     await SessionStorage.setEmployeeName(employeename_controller.text);
    await SessionStorage.setEmployeeId(employee_id_controller.text);
    await SessionStorage.setCustomerMobileno(customer_mobile_controller.text);
     final isValid = _formKey.currentState!.validate();
    if(!isValid){
      return;
    }
   // Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (_) => Dashboard(key: Key("dashboard"),)));
  }


  void _showEmployeeSearch(List<Map<String,dynamic>> employeeList,BuildContext context) {
    //resuableWidgets!.showAlertDialog(context: context, title: "Employee List", contentWidget: search_widget_body(context, employeeList), defaultActionText: "Ok", okCallBack: selected_employee(0), cancelActionText: 'Cancle');
      resuableWidgets!.showSimpleModalDialog(context,employeeList,selected_employee);
  }





 void selected_employee(Map<String,dynamic> selected_employee) {
   if(selected_employee != null){
     employee_id_controller.text = selected_employee[DbHelper.employee_id];
     employeename_controller.text = selected_employee[DbHelper.employee_nm];
   }

  }
  _footer() {
    return Container(
      margin: EdgeInsets.only(bottom: 0,top: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String>(
            future: DeviceDetails.getVersion(),
            builder: (context,data){
              if(data.hasData) {
                return Text(version_string + data.data!,style: CustomStyles.smallTextStyle(context),);
              }
              else{
                return Text("");
              }
            },
          ),
          SizedBox(
            height: 5,
          ),

          Text(Login.powered_by,style: CustomStyles.smallTextStyle(context),),

          // Platform.isIOS ?
          // SizedBox(
          //   height:MediaQuery.of(context).size.height-20,
          //   child: UiKitView(viewType: viewType,
          //     ),
          // )
          // :AndroidView(viewType: viewType)

        ],
      ),
    );
  }




  getEmployeeName(String value) async {
   Map<String,dynamic>? find_employee = await commonMethods!.searchEmpById(value);
   if(find_employee != null){
     String emp_id = employee_id_controller.text;
     if(emp_id != null ? emp_id.isEmpty?false:true:false)
      employeename_controller.text = find_employee['employee_nm'];
    }
   else{
     employeename_controller.text = "";
   }

  }
  void _init_methods() {
    commonMethods = CommonMethods();
    resuableWidgets = ResuableWidgets();
    mDatababase = mDatabase();
    _screenUtils = ScreenUtils(context: context);
    dummyData = DummyData();
    getClientDetails();
    getEmployeeList();
  }

  void getClientDetails()  async{
    mDatabase datatabse = mDatabase();
    Client_master? client_master = await datatabse.getClientMaster();
    //print(client_master!.isActive);
    decode_logo(client_master!.logo);
  }

  void decode_logo(String? flogo)  {
    try{
      final encodedStr = flogo;
      Uint8List bytes = base64.decode(encodedStr!);

      
      setState(() {
        logo = File.fromRawPath(bytes);
      });
     
    }catch(ex){

    }
  }
}





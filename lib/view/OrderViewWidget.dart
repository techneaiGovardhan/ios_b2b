import 'package:b2b/controller/get_available_product_location.dart';
import 'package:b2b/database/database.dart';
import 'package:b2b/database/db_helper.dart';
import 'package:b2b/modal/ProductDetails.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/customViews/CustomAppBar.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

class OrderViewWidget extends StatefulWidget {
int? product_id;
  OrderViewWidget(this.product_id, {Key? key}) : super(key: key);

  @override
  _OrderViewWidgetState createState() => _OrderViewWidgetState();
}
class _OrderViewWidgetState extends State<OrderViewWidget> {
  ScreenUtils?screenUtils ;
  int step=0;
  TextEditingController et_contact_no = TextEditingController();
  TextEditingController et_expected_date = TextEditingController();
  TextEditingController et_sales_person = TextEditingController();
  TextEditingController et_bar_code = TextEditingController();
  TextEditingController et_remark = TextEditingController();
  TextEditingController et_visit_date = TextEditingController();
  TextEditingController et_visit_time = TextEditingController();
  TextEditingController et_toBranch  = TextEditingController();
  TextEditingController et_counterName = TextEditingController();
  TextEditingController et_occation = TextEditingController();
  TextEditingController et_fromBranch = TextEditingController();

  String? button_text = "Next";
  GlobalKey<FormState> _globalKey = new GlobalKey<FormState> ();
  @override
  void initState() {
    // TODO: implement initState

    inti_methods();
    super.initState();
  }
  DateTime? _dateTime;
  ProductDetails? current_proudct;
  late mDatabase mdatabase;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
                            key: Key("OrderViewWidget"),
                            wtitle: Text("Order",style: CustomStyles.title_with_white_text(context),),
                            mpreferredSize: Size(
                                screenUtils!.getWidthPercent(100),
                                screenUtils!.getHeightPercent(8)
                            ),
                          ),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: screenUtils!.getHeightPercent(100),
                child: Form(
                  key:_globalKey ,
                  child: Column(
                    children: [
                      Container(
                        height: screenUtils!.getHeightPercent(5),
                        child:NumberStepper(
                          activeStepColor: color1,
                          numbers:[
                            1,
                            2
                          ],
                          onStepReached: (step){
                            setState(() {
                              this.step = step;
                            });
                          },
                          activeStep: step,
                        ),
                      ),
                      step == 0 ?
                      Expanded(child:  _wStep1(),
                        flex: 4,)
                          :
                      step == 1 ?
                      Expanded(
                          flex: 4,
                          child: _wStep2()
                      )
                          :
                      Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
           bottom: 0,
            left: 0,
            right: 0,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Expanded(
                 child: Container(
                   margin:EdgeInsets.only(left: 10,right: 10),
                   child: ElevatedButton(onPressed: (){
                        moveBackword();
                   },
                     child: Text("Prev",style: CustomStyles.title_with_white_text(context),),
                     style: CustomStyles.customButtonStyle(),

                   ),
                 ),
               ) ,

                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: ElevatedButton(onPressed: (){
                      moveStepForward();
                    },
                      child: Text(button_text!,style: CustomStyles.title_with_white_text(context),),
                      style: CustomStyles.customButtonStyle(),

                    ),
                  ),
                ) ,

              ],
            ) ,
          ),

        ]
      )
    );
  }

 Widget _wStep1() {
    return Stack(

      children: [
        // Figma Flutter Generator Rectangle21Widget - RECTANGLE
        // Figma Flutter Generator ContactnumberWidget - TEXT
        Column(
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text('Contact Number',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),
                ),
              ),
            ),
            Container(
              width: screenUtils!.getWidthPercent(90),
              height: screenUtils!.getHeightPercent(5),
              decoration: BoxDecoration(
                borderRadius : BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow : [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0,4),
                    blurRadius: 4
                )],
                color : Color.fromRGBO(255, 255, 255, 1),
              ),
              child: FutureBuilder<String?>(future: SessionStorage.getCustomerMobileno(),builder: (context,value){
                if(value.hasData){
                  et_contact_no.text = value.data!;
                  return TextFormField(
                    controller: et_contact_no,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter Contact No";
                      }
                    },

                  );
                }
                else{
                  return Container();
                }
           },)  ,

            ),

            SizedBox(
              height: 50,
              child: Center(
                child: Text('Expected Date', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
                width: screenUtils!.getWidthPercent(90),
                height: screenUtils!.getHeightPercent(5),
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  boxShadow : [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0,4),
                      blurRadius: 4
                  )],
                  color : Color.fromRGBO(255, 255, 255, 1),
                ),
              child: TextFormField(
                readOnly: true,
                controller: et_expected_date,
                validator: (value){
                  if(value!.isEmpty) {
                    return "Expected Date";
                  }
                },

             decoration: InputDecoration(
               labelText: 'Date Format',
               hintText: 'yyyy-MM-dd',
                hintStyle: TextStyle(color: Colors.black26),
   ),
                onTap: (){
                  _showDatePicker();
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) {
                  // //  return DatePickerBottomSheet();
                  // }));
                },
              ),
            ),

            SizedBox(
              height: 50,
              child: Center(
                child: Text('Sales Person', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
                width: screenUtils!.getWidthPercent(90),
                height: screenUtils!.getHeightPercent(5),
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  boxShadow : [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0,4),
                      blurRadius: 4
                  )],
                  color : Color.fromRGBO(255, 255, 255, 1),
                ),
              child:
              FutureBuilder<String?>(future:SessionStorage.getEmployeeName(),builder: (context,data){
                if(data.hasData){
                  et_sales_person.text = data.data!;
                  return TextFormField(
                    readOnly: true,
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Sales Person";
                      }
                    },
                    controller: et_sales_person,
                  );
                }
                else{
                  return Text("");
                }
         })

            ),

            SizedBox(
              height: 50,
              child: Center(
                child: Text('Barcode', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
                width: screenUtils!.getWidthPercent(90),
                height: screenUtils!.getHeightPercent(5),
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  boxShadow : [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0,4),
                      blurRadius: 4
                  )],
                  color : Color.fromRGBO(255, 255, 255, 1),
                ),
              child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Barcode";
                      }
                    },
                controller: et_bar_code,
              ),
            ),

            SizedBox(
              height: 50,
              child: Center(
                child: Text("Function / Occasion Details", textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
                width: screenUtils!.getWidthPercent(90),
                height: screenUtils!.getHeightPercent(5),
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  boxShadow : [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0,4),
                      blurRadius: 4
                  )],
                  color : Color.fromRGBO(255, 255, 255, 1),
                ),
              child: TextFormField(
                 validator: (value){
                   if(value!.isEmpty){
                     return "Enter valid Occasion";
                   }
                 },
                controller: et_occation,
              ),
            ),

            SizedBox(
              height: 50,
              child: Center(
                child: Text("Remark", textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
                width: screenUtils!.getWidthPercent(90),
                height: screenUtils!.getHeightPercent(5),
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  boxShadow : [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0,4),
                      blurRadius: 4
                  )],
                  color : Color.fromRGBO(255, 255, 255, 1),
                ),
              child: TextFormField(
                 validator: (value){
                   if(value!.isEmpty){
                     return "Enter valid Remark";
                   }
                 },
                controller: et_remark,

              ),
            )
            ,
          ],
        ),
      ],
    );
 }
  void _showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),

    theme: DatePickerTheme(
    headerColor: Colors.orange,
    backgroundColor: color1,
    itemStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18),
    doneStyle:
    TextStyle(color: Colors.white, fontSize: 16)),
    onChanged: (date) {
      setState(() {
        _dateTime = date;

      });
      et_expected_date.text = DateFormat.yMd().format(_dateTime!);
    print('change $date in time zone ' +
    date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
    print('confirm $date');
    });
  }

  _wStep2() {
    return Stack(

      children: [
        // Figma Flutter Generator Rectangle21Widget - RECTANGLE
        // Figma Flutter Generator ContactnumberWidget - TEXT
        Column(
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text('Visit Date',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1
                  ),
                ),
              ),
            ),
            Container(
              width: screenUtils!.getWidthPercent(90),
              height: screenUtils!.getHeightPercent(5),
              decoration: BoxDecoration(
                borderRadius : BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow : [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0,4),
                    blurRadius: 4
                )],
                color : Color.fromRGBO(255, 255, 255, 1),
              ),
              child:FutureBuilder<String?> (future: mdatabase.getVisitDateTime(),builder: (context,data){
                 if(data.hasData){
                   et_visit_date.text = data.data!;
                   return TextFormField(
                     readOnly: true,
                     controller: et_visit_date,
                     validator: (value){
                    if(value!.isEmpty){
                      return "Enter valid visit time";
                    }
    },
    );
    }
                 else{
                   return Text("");
                 }
    }
                )

            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text('To Branch', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
              width: screenUtils!.getWidthPercent(90),
              height: screenUtils!.getHeightPercent(5),
              decoration: BoxDecoration(
                borderRadius : BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow : [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0,4),
                    blurRadius: 4
                )],
                color : Color.fromRGBO(255, 255, 255, 1),
              ),
              child: TextFormField(
                readOnly: true,
                controller: et_toBranch,
                validator: (value){
                  if(value!.isEmpty) {
                    return "Enter valid To Branch";
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text('From Branch', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
              width: screenUtils!.getWidthPercent(90),
              height: screenUtils!.getHeightPercent(5),
              decoration: BoxDecoration(
                borderRadius : BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow : [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0,4),
                    blurRadius: 4
                )],
                color : Color.fromRGBO(255, 255, 255, 1),
              ),
              child: TextFormField(
                readOnly: true,
                controller: et_fromBranch,
                validator: (value){
                  if(value!.isEmpty) {
                    return "Enter valid From Branch";
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text('Counter name', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),),
              ),
            ),
            Container(
              width: screenUtils!.getWidthPercent(90),
              height: screenUtils!.getHeightPercent(5),
              decoration: BoxDecoration(
                borderRadius : BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow : [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0,4),
                    blurRadius: 4
                )],
                color : Color.fromRGBO(255, 255, 255, 1),
              ),
              child: TextFormField(
                readOnly: true,
                controller: et_counterName,
                validator: (value){
                  if(value!.isEmpty) {
                    return "Enter valid To Counter name";
                  }
                },
              ),
            )
          ],
        ),
      ],
    );;
  }

  void moveStepForward() {
    if(button_text != "Submit") {
   final valid =   _globalKey.currentState!.validate();
      if(!valid) return;

      setState(() {
        step = step + 1;
        button_text = "Submit";
      });

    }
    else{
        save_order();
    }
  }
  void moveBackword() {
    if(step > 0) {
      setState(() {
        step = step - 1;
      });
    }
  }

  void inti_methods() async {
    try {
       mdatabase = mDatabase();
       screenUtils = ScreenUtils(context: context);
       current_proudct = (await mdatabase!.productDetails(widget.product_id!));
       et_bar_code.text  = current_proudct!.barcodeNo!;
       List<Map<String,dynamic>>? locations  =   await mdatabase.getLocationMaster();
       int site_id = locations![0]['site_id'];
       List<Map<String,dynamic>>?  siteMaster = await mdatabase.getSiteMaster(site_id);
       et_fromBranch.text = siteMaster![0]['site_nm'];
      et_counterName.text =  locations![0]['location_nm'];
       getProductLocation();


    }catch(ex){

    }
  }

  void save_order() async {
    final valid =   _globalKey.currentState!.validate();
    mDatabase mdatabase = mDatabase();
    if(!valid) return;

    int records = await mdatabase.getRecords(DbHelper.tbl_posOrderDetails);

    Map<String,dynamic> map = Map();

    map['id'] = records+1;
    map['pos_id']  = 1;
    map['mac_address'] = await SessionStorage.getMacaddress();
    map['customer_mobile_no'] = et_contact_no.text;
    map['customer_id'] = et_contact_no.text;
    map['expected_delivery_dt'] = et_expected_date.text;
    map['sales_person_id'] = await SessionStorage.getEmployeeId();
    map['sales_person_nm'] = await SessionStorage.getEmployeeName();
    map['product_code'] = widget.product_id;
    map['occasions_details'] = et_occation.text;
    map['custome_visit_date'] = et_visit_date.text;
    map['custome_visit_time'] = et_visit_time.text;
    map['from_site'] = et_fromBranch.text;
    map['to_site'] = et_toBranch.text;
    map['from_location'] = et_fromBranch.text;
    map['order_status'] = "";
    map['remark'] = et_remark.text;
    map['is_active'] = "1";
    map['created_at'] = DateFormat.yMd().format(DateTime.now());
    map['updated_at'] = DateFormat.yMd().format(DateTime.now());
    map['created_by'] = await SessionStorage.getEmployeeId();
    map['updated_by'] = await SessionStorage.getEmployeeId();
    mdatabase.insert_customer_order(map);
    Fluttertoast.showToast(
        msg: "Successfully added in order",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.of(context).pop();



  }

  getProductLocation() {
    GetAvailableProductLocation location = GetAvailableProductLocation(onResponse);
    location.getLocation(current_proudct!.barcodeNo);
  }

  void onResponse(Response<dynamic> response){
    if(response.data["status"] == 1)
      et_toBranch.text = response.data["data"];
    else
      et_toBranch.text = "No branch found";
     // et_toBranch
  }

  //  DatePickerBottomSheet(context) {
  //   DatePicker.showDatePicker(
  //       context,
  //   );
  // }

}




import 'package:b2b/controller/common_methods.dart';
import 'package:b2b/database/database.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/customViews/CustomAppBar.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomerOrderedList extends StatefulWidget {
  const CustomerOrderedList({Key? key}) : super(key: key);

  @override
  _CustomerOrderedListState createState() => _CustomerOrderedListState();
}

class _CustomerOrderedListState extends State<CustomerOrderedList> {
  late mDatabase mdatabase;
  ScreenUtils? _screenUtils;
  TextEditingController _search_controller = TextEditingController();
  late List<Map<String,dynamic>> _orderedList=[];
  late CommonMethods _commonMethods;
  @override
  void initState() {
    // TODO: implement initState
    init_methods();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        wtitle: Text("Placed Order",style: CustomStyles.title_with_white_text(context),),
        mpreferredSize: Size( _screenUtils!.getWidthPercent(100),
            _screenUtils!.getHeightPercent(8)
        ),
        key: Key("customer_order"),
      ),
      body: _CustomerOrderedListBody(),
    );
  }

  void init_methods(){
    _screenUtils =  ScreenUtils(context: context);
    mdatabase = mDatabase();
    _commonMethods = CommonMethods();
    getCustomer_orderDetails(mdatabase);
  }

  void getCustomer_orderDetails(mDatabase mdatabase,{search_text}) async {
    try {
      String? customer_mobile_no = await SessionStorage.getCustomerMobileno();
      List<Map<String, dynamic>>? orderDetails = await  mdatabase.getOrderDetails(customer_mobile_no!,search_text);
      setState(() {
        _orderedList = orderDetails!;
      });

    }catch(ex){

    }
  }

  _CustomerOrderedListBody() {
    return Container(
      height: _screenUtils!.getHeightPercent(100),
      width: _screenUtils!.getWidthPercent(100),
      child: Column(
        children: [
          Container(

              child: _SearchWidget()
          ),
          Expanded(
              flex:1,
              child:
              _orderedList.length > 0 ?
              _OrderedListWidget():
              Container()
          )
        ],
      ),
    );
  }

  _SearchWidget() {
    return(
        Container(
            margin: EdgeInsets.all(10),
            width: _screenUtils!.getWidthPercent(100),

            decoration:CustomStyles.boxDecoration() ,
            child: Padding(
              padding: const EdgeInsets.only(left: 25,right: 15),
              child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          decoration: CustomStyles.customTextFieldStyle("Search", false, 0),
                          controller: _search_controller,
                          onChanged: (value){
                            getCustomer_orderDetails(mdatabase,search_text:value);
                          }
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Align(
                        child: Icon(
                          Icons.search_outlined,
                          size: 24,
                          color: color1,
                        ),
                        alignment: Alignment.topRight,
                      ),
                      flex: 1,
                    ),
                  ]
              ),
            ))
    );
  }

  _OrderedListWidget() {
    return ListView.builder(
      itemBuilder: (context,index)=>_CustomWidgetOrderDetails(_orderedList[index],index),
      shrinkWrap: true,
      itemCount: _orderedList.length,
    );
  }

  _CustomWidgetOrderDetails(Map<String, dynamic> orderedList,int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: color1,width: 0.5)),
      child: Column(children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _CustomerMobileNo(orderedList),
                  _ExpectedDate(orderedList),
                  _Sales_Person(orderedList),
                  _Product(orderedList),
                  _VisitDateCounter(orderedList),
                  _ToBranchFromBranch(orderedList),
                  _FunctionAndRemark(orderedList)
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child:ElevatedButton(
                  //         onPressed: (){
                  //
                  //         },
                  //         style: CustomStyles.customButtonStyle(),
                  //         child: Text("View Function"),
                  //       ) ,
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child:ElevatedButton(
                  //         onPressed: (){
                  //
                  //         },
                  //         style: CustomStyles.customButtonStyle(),
                  //         child: Text("View Remark"),
                  //       ) ,
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
            Visibility(
              visible: false,
              child: Positioned(
                bottom: 0,
                right: 0,
                left: 0,

                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child:ElevatedButton(
                        onPressed: (){

                        },
                        style: CustomStyles.customButtonStyle(),
                        child: Text("View Function"),
                      ) ,
                    ),
                    Expanded(
                      flex: 1,
                      child:ElevatedButton(
                        onPressed: (){

                        },
                        style: CustomStyles.customButtonStyle(),
                        child: Text("View Remark"),
                      ) ,
                    )
                  ],
                ),

              ),
            )
          ],
        )

      ]),
    );
  }

  _CustomerMobileNo(Map<String,dynamic> details) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: (
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child:Text("Contact No",
                      style:CustomStyles.smallTextBoldStyle(context))
              ),
              Expanded(
                  flex: 1,
                  child:Text(details['customer_mobile_no'],
                      style:CustomStyles.smallTextStyle(context))
              )
            ],
          )
      ),
    );
  }

  _ExpectedDate(Map<String,dynamic> details) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [  Expanded(
            flex: 1,
            child:Text("Exp Date",
                style:CustomStyles.smallTextBoldStyle(context))
        ),
          Expanded(
              flex: 1,
              child:Text(details['expected_delivery_dt'],
                  style:CustomStyles.smallTextStyle(context))
          )
        ],
      ),
    );
  }

  _Sales_Person(Map<String, dynamic> details) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [  Expanded(
            flex: 1,
            child:Text("Sales Person",
                style:CustomStyles.smallTextBoldStyle(context))
        ),
          Expanded(
              flex: 1,
              child:Text(details['sales_person_nm'],
                  style:CustomStyles.smallTextStyle(context))
          )
        ],
      ),
    );
  }
  _Product(Map<String, dynamic> details) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child:Text("Product",
                  style:CustomStyles.smallTextBoldStyle(context))
          ),
          Expanded(
              flex: 1,
              child:
              FutureBuilder<String?>(
                  future:mdatabase.getProductName(details['product_code']) ,
                  builder:(context,data){
                    if(data.hasData){
                      return Text(data.data!,
                          style:CustomStyles.smallTextStyle(context));
                    }
                    else{
                      return Text("");
                    }
                  }
              )
          )

        ],
      ),
    );
  }
  _VisitDateCounter(Map<String,dynamic> details){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child:Text("Visit Date",
                  style:CustomStyles.smallTextBoldStyle(context))
          ),
          Expanded(
              flex: 1,
              child:Text(details["custome_visit_date"],
                  style:CustomStyles.smallTextStyle(context))
          ),
          Expanded(
              flex: 1,
              child:Text("Counter",
                  style:CustomStyles.smallTextBoldStyle(context))
          ),
          Expanded(
              flex: 1,
              child:

              FutureBuilder<String>(
                future: _commonMethods.getCounterName(),
                builder: (context,data){
                  if(data.hasData) {
                    return Text(data.data!,
                        style: CustomStyles.smallTextStyle(context));
                  }
                  else{
                    return Text("");
                  }
                },
              )

          )
        ],
      ),
    );
  }

  _ToBranchFromBranch(Map<String, dynamic> details) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          children:[
            Expanded(
                flex: 1,
                child:Text("To Branch",
                    style:CustomStyles.smallTextBoldStyle(context))
            ),
            Expanded(
                flex: 1,
                child:Text(details["to_site"],
                    style:CustomStyles.smallTextStyle(context))
            ),
            Expanded(
                flex: 1,
                child:Text("From Branch",
                    style:CustomStyles.smallTextBoldStyle(context))
            ),
            Expanded(
                flex: 1,
                child:Text(details["from_site"],
                    style:CustomStyles.smallTextStyle(context))
            )
          ]
      ),
    );
  }

  _FunctionAndRemark(Map<String, dynamic> orderedList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          children:[
            Expanded(
                flex: 1,
                child:Text("Function",
                    style:CustomStyles.smallTextBoldStyle(context))
            ),
            Expanded(
                flex: 1,
                child:Text(orderedList["occasions_details"],
                    style:CustomStyles.smallTextStyle(context))
            ),
            Expanded(
                flex: 1,
                child:Text("From Branch",
                    style:CustomStyles.smallTextBoldStyle(context))
            ),
            Expanded(
                flex: 1,
                child:Text(orderedList["remark"],
                    style:CustomStyles.smallTextStyle(context))
            )
          ]
      ),
    );
  }
}



//
// import 'package:b2b/controller/common_methods.dart';
// import 'package:b2b/database/database.dart';
// import 'package:b2b/modal/constants/constants.dart';
// import 'package:b2b/utils/ScreenUtils.dart';
// import 'package:b2b/utils/SessionStorage.dart';
// import 'package:b2b/view/customViews/CustomAppBar.dart';
// import 'package:b2b/view/styles/CustomStyles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//
// class CustomerOrderedList extends StatefulWidget {
//   const CustomerOrderedList({Key? key}) : super(key: key);
//
//   @override
//   _CustomerOrderedListState createState() => _CustomerOrderedListState();
// }
//
// class _CustomerOrderedListState extends State<CustomerOrderedList> {
//  late mDatabase mdatabase;
//  ScreenUtils? _screenUtils;
//  TextEditingController _search_controller = TextEditingController();
//  late List<Map<String,dynamic>> _orderedList=[];
//  late CommonMethods _commonMethods;
//   @override
//   void initState() {
//     // TODO: implement initState
//     init_methods();
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//           wtitle: Text("Placed Order",style: CustomStyles.title_with_white_text(context),),
//           mpreferredSize: Size( _screenUtils!.getWidthPercent(100),
//                                 _screenUtils!.getHeightPercent(8)
//                               ),
//           key: Key("customer_order"),
//       ),
//        body: _CustomerOrderedListBody(),
//     );
//   }
//
//   void init_methods(){
//     _screenUtils =  ScreenUtils(context: context);
//      mdatabase = mDatabase();
//      _commonMethods = CommonMethods();
//      getCustomer_orderDetails(mdatabase);
//   }
//
//   void getCustomer_orderDetails(mDatabase mdatabase,{search_text}) async {
//    try {
//      String? customer_mobile_no = await SessionStorage.getCustomerMobileno();
//      List<Map<String, dynamic>>? orderDetails = await  mdatabase.getOrderDetails(customer_mobile_no!,search_text);
//      setState(() {
//        _orderedList = orderDetails!;
//      });
//
//    }catch(ex){
//
//    }
//   }
//
//   _CustomerOrderedListBody() {
//      return Container(
//        height: _screenUtils!.getHeightPercent(100),
//        width: _screenUtils!.getWidthPercent(100),
//        child: Column(
//          children: [
//            Container(
//
//            child: _SearchWidget()
//            ),
//            Expanded(
//             flex:1,
//             child:
//             _orderedList.length > 0 ?
//             _OrderedListWidget():
//             Container()
//            )
//          ],
//        ),
//      );
//   }
//
//   _SearchWidget() {
//     return(
//       Container(
//         margin: EdgeInsets.all(10),
//         width: _screenUtils!.getWidthPercent(100),
//
//         decoration:CustomStyles.boxDecoration() ,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 25,right: 15),
//           child: Row(
//             children: [
//                Expanded(
//                  child: TextField(
//                    decoration: CustomStyles.customTextFieldStyle("Search", false, 0),
//                    controller: _search_controller,
//                    onChanged: (value){
//                      getCustomer_orderDetails(mdatabase,search_text:value);
//                    }
//                  ),
//                  flex: 3,
//                ),
//               Expanded(
//                 child: Align(
//                   child: Icon(
//                          Icons.search_outlined,
//                          size: 24,
//                          color: color1,
//                      ),
//                   alignment: Alignment.topRight,
//                 ),
//                 flex: 1,
//                 ),
//                 ]
//                 ),
//         ))
//             );
//   }
//
//   _OrderedListWidget() {
//     return ListView.builder(
//       itemBuilder: (context,index)=>_CustomWidgetOrderDetails(_orderedList[index],index),
//     shrinkWrap: true,
//     itemCount: _orderedList.length,
//     );
//   }
//
//   _CustomWidgetOrderDetails(Map<String, dynamic> orderedList,int index) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
//       side: BorderSide(color: color1,width: 0.5)),
//       child: Column(children: [
//         Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   _CustomerMobileNo(orderedList),
//                   _ExpectedDate(orderedList),
//                   _Sales_Person(orderedList),
//                   _Product(orderedList),
//                   _VisitDateCounter(orderedList),
//                   _ToBranchFromBranch(orderedList),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child:ElevatedButton(
//                           onPressed: (){
//
//                           },
//                           style: CustomStyles.customButtonStyle(),
//                           child: Text("View Function"),
//                         ) ,
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child:ElevatedButton(
//                           onPressed: (){
//
//                           },
//                           style: CustomStyles.customButtonStyle(),
//                           child: Text("View Remark"),
//                         ) ,
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Visibility(
//               visible: false,
//               child: Positioned(
//                 bottom: 0,
//                 right: 0,
//                 left: 0,
//
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child:ElevatedButton(
//                           onPressed: (){
//
//                           },
//                         style: CustomStyles.customButtonStyle(),
//                         child: Text("View Function"),
//                       ) ,
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child:ElevatedButton(
//                         onPressed: (){
//
//                         },
//                         style: CustomStyles.customButtonStyle(),
//                         child: Text("View Remark"),
//                       ) ,
//                     )
//                   ],
//                 ),
//
//               ),
//             )
//           ],
//         )
//
//       ]),
//     );
//   }
//
//   _CustomerMobileNo(Map<String,dynamic> details) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: (
//       Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child:Text("Contact No",
//                 style:CustomStyles.smallTextBoldStyle(context))
//         ),
//           Expanded(
//                     flex: 1,
//                     child:Text(details['customer_mobile_no'],
//                     style:CustomStyles.smallTextStyle(context))
//              )
//         ],
//       )
//       ),
//     );
//   }
//
//   _ExpectedDate(Map<String,dynamic> details) {
//     return  Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [  Expanded(
//             flex: 1,
//             child:Text("Exp Date",
//                 style:CustomStyles.smallTextBoldStyle(context))
//         ),
//           Expanded(
//               flex: 1,
//               child:Text(details['expected_delivery_dt'],
//                   style:CustomStyles.smallTextStyle(context))
//           )
//         ],
//       ),
//     );
//   }
//
//    _Sales_Person(Map<String, dynamic> details) {
//      return  Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Row(
//          children: [  Expanded(
//              flex: 1,
//              child:Text("Sales Person",
//                  style:CustomStyles.smallTextBoldStyle(context))
//          ),
//            Expanded(
//                flex: 1,
//                child:Text(details['sales_person_nm'],
//                    style:CustomStyles.smallTextStyle(context))
//            )
//          ],
//        ),
//      );
//    }
//    _Product(Map<String, dynamic> details) {
//      return  Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Row(
//          children: [
//            Expanded(
//              flex: 1,
//              child:Text("Product",
//                  style:CustomStyles.smallTextBoldStyle(context))
//          ),
//            Expanded(
//                flex: 1,
//                child:
//                FutureBuilder<String?>(
//                    future:mdatabase.getProductName(details['product_code']) ,
//                    builder:(context,data){
//                  if(data.hasData){
//                   return Text(data.data!,
//                   style:CustomStyles.smallTextStyle(context));
//                  }
//                  else{
//                    return Text("");
//                  }
//                  }
//                  )
//            )
//
//          ],
//        ),
//      );
//    }
//    _VisitDateCounter(Map<String,dynamic> details){
//      return  Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Row(
//          children: [
//            Expanded(
//              flex: 1,
//              child:Text("Visit Date",
//                  style:CustomStyles.smallTextBoldStyle(context))
//          ),
//            Expanded(
//                flex: 1,
//                child:Text(details["custome_visit_date"],
//                    style:CustomStyles.smallTextStyle(context))
//            ),
//            Expanded(
//                flex: 1,
//                child:Text("Counter",
//                    style:CustomStyles.smallTextBoldStyle(context))
//            ),
//            Expanded(
//                flex: 1,
//                child:
//
//                FutureBuilder<String>(
//                  future: _commonMethods.getCounterName(),
//                  builder: (context,data){
//                    if(data.hasData) {
//                      return Text(data.data!,
//                          style: CustomStyles.smallTextStyle(context));
//                    }
//                else{
//                            return Text("");
//                    }
//                  },
//                )
//
//            )
//          ],
//        ),
//      );
//      }
//
//   _ToBranchFromBranch(Map<String, dynamic> details) {
//      return Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Row(
//          children:[
//            Expanded(
//                flex: 1,
//                child:Text("To Branch",
//                    style:CustomStyles.smallTextBoldStyle(context))
//            ),
//            Expanded(
//                flex: 1,
//                child:Text(details["to_site"],
//                    style:CustomStyles.smallTextStyle(context))
//            ),
//            Expanded(
//                flex: 1,
//                child:Text("From Branch",
//                    style:CustomStyles.smallTextBoldStyle(context))
//            ),
//            Expanded(
//                flex: 1,
//                child:Text(details["from_site"],
//                    style:CustomStyles.smallTextStyle(context))
//            )
//        ]
//        ),
//      );
//   }
// }

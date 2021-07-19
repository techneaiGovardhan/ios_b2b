
import 'dart:math';

import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/view/customViews/CustomAppBar.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/material.dart';

class SubFilterList extends StatefulWidget {
  List<Map<String,dynamic>>? filterlist;
  String? filter_name;
  int? filter_id;
  SubFilterList({Key? key,this.filterlist,this.filter_name,this.filter_id}) : super(key: key);

  @override
  _SubFilterListState createState() => _SubFilterListState(this.filterlist!,this.filter_name!);
}

class _SubFilterListState extends State<SubFilterList> {
  List<Map<String,dynamic>> subfilters;
  late ScreenUtils _screenUtils;
  String filter_name;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState> ();
  _SubFilterListState(this.subfilters,this.filter_name);
  List<int> filters = [1,2,3,5];
  late String minRange="0",maxRange;
late double minMax,maxMax;
  var selectedRange = RangeValues(0.2,0.8);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init_methods();
  }
TextEditingController min_controller = TextEditingController();
TextEditingController max_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async{
      final valid = _globalKey.currentState!.validate();
      if(!valid)
      return false;
      else return true;
    },
    child: Scaffold(
      appBar: CustomAppBar(
        key: Key("sub_filters_appbar"),
        wtitle: Text(filter_name,style: CustomStyles.title_with_white_text(context),),
        mpreferredSize:Size(_screenUtils.getWidthPercent(100),_screenUtils.getHeightPercent(8)) ,
      ),
      body:
      Stack(
      children:[
        _SubFilterListBody(),
        Positioned(
         bottom: 0,
          right: 0,
          left: 0,
          child: ElevatedButton(
            style: CustomStyles.customButtonStyle(),
            onPressed: (){
              check_filterCategory();
             //  Navigator.of(context).pop();
            },
            child: Text("Done",style: CustomStyles.title_with_white_text(context)),
          ),

        )
      ]
      )
    )
    );
  }

  void init_methods() {
    _screenUtils = ScreenUtils(context: context);
    try {
      if (filters.contains(widget.filter_id)) {
        maxMax = double.parse(subfilters[0]["range"].toString().split("-")[1]);
        minMax = double.parse(subfilters[0]["range"].toString().split("-")[0]);
      }
    }catch(ex){
      throw(ex);
    }
  }

  _SubFilterListBody() {
    if(filters.contains(widget.filter_id)){
     min_controller.text  = subfilters[0]['name'].toString().split("-")[0];
     max_controller.text  = subfilters[0]['name'].toString().split("-")[1];
       return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter Min and Max Range",style: CustomStyles.mediumTextstyle(context),),
             Visibility(
               visible: false,
               child: RangeSlider(values: selectedRange, onChanged: (value){
                 setState(() {
                   selectedRange = value;
                 });
               },

               ),
             ),
              Form(
                key: _globalKey,
                child: Container(
                  margin: EdgeInsets.only(top: _screenUtils.getHeightPercent(5)),
                  width: _screenUtils.getWidthPercent(50),
                  child: Row(
                    children: [
                       Expanded(
                         flex: 1,
                         child: TextFormField(
                           controller: min_controller,
                           onTap: (){
                             min_controller.selection = TextSelection.collapsed(offset: min_controller.text.length);
                           },
                           keyboardType: TextInputType.numberWithOptions(decimal: true
                           ),
                           onChanged: (value){
                             min_controller.selection = TextSelection.collapsed(offset: min_controller.text.length);
                             if(!value.isEmpty && double.parse(value.toString()) > minMax) {
                               minRange = value;

                             }else{
                               minRange = "0";
                             }

                            // min_controller.text = minRange;
                           },
                           validator: (value){
                             if(double.parse(value.toString()) < minMax || double.parse(value.toString()) > maxMax || value!.isEmpty  ){
                               return "";
                             }
                           },

                           textAlign: TextAlign.center,
                           decoration: CustomStyles.customTextFieldStyle("Min", true, 0),
                         ),
                       ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
 keyboardType:TextInputType.numberWithOptions(decimal: true),
                          controller: max_controller,
                          onChanged: (value){
                            max_controller.selection = TextSelection.collapsed(offset: max_controller.text.length);
                            if(!value.isEmpty &&  double.parse(value.toString()) <= maxMax && double.parse(value.toString()) > minMax) {
                               maxRange = value;
                            }
                            else{
                              maxRange = "0";
                            }
                           // max_controller.text = maxRange;
                          },
                          validator: (value){
                            if(double.parse(value.toString()) > maxMax || double.parse(value.toString()) < minMax || (value!.isEmpty)){
                              return "";
                            }
                          },
                          textAlign: TextAlign.center,
                          decoration: CustomStyles.customTextFieldStyle("Max", true, 0),
                        ),
                      )
                    ],
                  ),
                ),
              )

            ],
          ),
        );
    }
    else {
      return Container(
        margin: EdgeInsets.only(bottom:_screenUtils.getHeightPercent(3)),

        height: _screenUtils!.getHeightPercent(90),
        child: ListView.builder(itemBuilder: (context, index) =>
            _custom_subFilter_widget(subfilters[index], index),
          itemCount: subfilters.length,),
      );
    }
  }

  _custom_subFilter_widget(Map<String,dynamic> filterMap, int index) {
     return Padding(
       padding: EdgeInsets.all(15),
       child: GestureDetector(
         onTap: (){
           setState(() {
             //filterMap["isSelected"] = value;
             subfilters.elementAt(index).update("isSelected", (value) => filterMap['isSelected']);
           });
         },
         child: Row(
           children: [
             Expanded(
                 flex: 1,
                 child: Text(filterMap['name'],style: CustomStyles.smallTextStyle(context),)),
             Expanded(
                 flex: 1,
                 child: Align(
                   alignment: Alignment.centerRight,
                 child: Checkbox(
                   value: filterMap["isSelected"],
                   onChanged: (bool? value) {
                     setState(() {
                       filterMap["isSelected"] = value;
                       subfilters.elementAt(index).update("isSelected", (value) => value);
                     });
                   },
                 ),
                 )
             )
           ],
         ),
       ),
     );

  }

  void check_filterCategory() {
    if(filters.contains(widget.filter_id)){
      final valid = _globalKey.currentState!.validate();
       if(!valid){
         return ;
      }

       subfilters.elementAt(0).update("name", (value) => min_controller.text+"-"+max_controller.text);
       subfilters.elementAt(0).update("isSelected", (value) => true);
    }
    Navigator.pop(context);
  }

  double getRange() {
    double range= 0.0;
    range = double.parse(subfilters[0]['name'].toString().split("-")[1]) - double.parse(subfilters[0]['name'].toString().split("-")[0]);
    return range;
  }
}

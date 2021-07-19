import 'dart:convert';

import 'package:b2b/database/database.dart';
import 'package:b2b/modal/FilterModal.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/SubFilterList.dart';
import 'package:b2b/view/customViews/CustomAppBar.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sqflite/sqflite.dart';

class FilterViewWidget extends StatefulWidget {
List<FilterModal> filterList;

FilterViewWidget(this.filterList);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createStatefilterList
    return _FilterViewWidget(this.filterList);
  }


}
class _FilterViewWidget extends State<FilterViewWidget>{
  ScreenUtils? _screenUtils;
  late mDatabase mdatabase;
  List<FilterModal> filterList;

  _FilterViewWidget(this.filterList);
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
               key:Key("flutter_widget_app_bar"),
               wtitle: Text("Filters",style: CustomStyles.title_with_white_text(context)),
                mpreferredSize: Size(_screenUtils!.getWidthPercent(100),_screenUtils!.getHeightPercent(8)) ,),

   body: Stack(
     children: [
       _fliterWidget(),
       Positioned(
           bottom: 0,
           left: 0,
           right: 0,
           child: _filterButton()
       )

     ],
   )

    );
  }

  _fliterWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: _screenUtils!.getHeightPercent(10)),
      height: _screenUtils!.getHeightPercent(90),
      child:
      filterList.length > 0 ?
      ListView.builder(itemBuilder:
          (context,index) {
         if(index != 6)
         return _CustomerFilterWidget(filterList![index], index);
         else
           return _CustomerFilterWidget(filterList![index+1], index+1);
      }
            ,
        itemCount: filterList.length-1

      ):
      Center(
      child: CircularProgressIndicator(),),
    );
  }

  _CustomerFilterWidget(FilterModal filter,int index) {
     return Padding(
         padding: EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(_)=>
              SubFilterList(filterlist: filterList[index].filters,filter_name:filterList[index].filter_name,filter_id:filterList[index].filterId))).whenComplete(() => {
            refreshLfist()
          });
        },
        child: Column(
          children: [
            Row(
               children: [
                 Expanded(
                     flex: 4,
                     child:Text(filter.filter_name!,style: CustomStyles.headingBlackText(context),)
                 ),
                 filter.filters!.length > 0 ? Expanded(child: Text(getSelectedcount(filter.filters),style: CustomStyles.smallTextStyle(context),) ):Text(""),
                 Expanded(
                     flex: 1,
                     child:
                     InkWell(
                       onTap: ()=>{
                         Navigator.of(context).push(MaterialPageRoute(builder:(_)=>
                             SubFilterList(filterlist: filter.filters,filter_name: filter.filter_name,filter_id:filter.filterId ,))).whenComplete(() => {
                               refreshLfist()
                         })
                       },
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Align(
                           alignment: Alignment.bottomRight,
                           child: Icon(Icons.arrow_forward_ios,
                                      size: 24,
                                        color: color1,
                                  ),
                         ),
                       ),
                     )
                 )
             ],
     ),
          Container(
            margin: EdgeInsets.only(top: 5,bottom: 5),
            height: 0.5,
            color: color1,
          )
          ],
        ),
      ),
     );
  }
  void refreshLfist(){
    setState(() {
      filterList = filterList;
    });
  }

  void init_methods() async{
    List<FilterModal> modals=[];
    _screenUtils = new ScreenUtils(context: context);
     mdatabase = mDatabase();
    await getFilters(mdatabase)!;
  }

   getFilters(mDatabase mdatabase) async{
     await mdatabase.getFilters(completedCallback);

  }

  String getSelectedcount(List<Map<String, dynamic>>? filters) {
    int count=0;
    filters!.forEach((element) {
      if(element['isSelected']){
        count = count+1;
      }
    });
    if(count > 0)
    return count.toString();
    else return "";
  }

  void completedCallback(List<FilterModal> modals){
    if(filterList.length == 0) {
      setState(() {
        filterList = modals;
      });
    }

  }

  _filterButton() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child:
            ElevatedButton(
                style: CustomStyles.customButtonStyle(),
                onPressed:(){
                  clear_all();

            }, child: Text("Clear"))
        ),
        Expanded(
    flex: 1,
          child: ElevatedButton(onPressed: () {
            Navigator.pop(context,filterList);

      }, child: Text("Done",style: CustomStyles.title_with_white_text(context),),
          style: CustomStyles.customButtonStyle(),

      )
        ),
    ],
    );
  }

  void clear_all()  async{

    for(int i=0;i<filterList.length;i++){
     FilterModal obj = filterList![i];
     obj.filters!.forEach((element) {
       element['isSelected'] = false;
     });
    }
    setState(() {
      filterList = filterList;
    });
   clear_filter_session();
  }

  void clear_filter_session() async {
    try {
      String filterd_string = json.encode(filterList);
      await SessionStorage.saveFilter(filterd_string);
    }catch(ex){

    }
  }

}
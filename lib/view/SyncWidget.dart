import 'dart:async';

import 'package:b2b/controller/SyncDatabase.dart';
import 'package:b2b/database/database.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/modal/sync_tables_modal.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/CustomerEntryWidget.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';
class SyncWidget extends StatefulWidget {
  const SyncWidget({required Key key}) : super(key: key);

  @override
  _SyncWidgetState createState() => _SyncWidgetState();
}

class _SyncWidgetState extends State<SyncWidget> {


  late Timer _timer;
  int _start = 10;

  List<Widget>? syncMasters = [];
  List<double> progressList = [];
   List<SyncTable> tables =[];

  int table_index=0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (_) => CustomerEntryWidget(key: Key("customer_widget"))));
      },
    );
  }

  @override
  void initState() {
    // startTimer();
    checkIsfirtTimeSync();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child:
          syncMasters!.length > 0 ?
          Stack(
            children:[
              GridView.count(crossAxisCount: 2, children: syncMasters!
              ,),
              Visibility(
                visible: false,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child:TextButton(onPressed:(){
                    SessionStorage.setFirstTimeSync();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>CustomerEntryWidget(key: Key("customerEntryWidget"),)));
                  },
                      child: Text("Next",style: CustomStyles.headingText(context),)
                  ) ,
                ),
              )

            ]
          ) :
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                ),
               SizedBox(
                 height: 20,
               ),
                Text("Please wait loading...",style: CustomStyles.mediumTextstyle(context))

              ],
            ),
          )
          ,
        ),
      ),
    );
  }

  void getSyncWidgets(List<SyncTable> syncTables) {
    List<Widget> syncWidgets = [];

    for (var i = 0; i < syncTables.length; i++) {

try {
  syncWidgets.add(
      Column(
          children: [
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 10.0,
              percent: progressList[i] > 1.0 ? 0.0: progressList[i],
              header:
              Container(
                  margin: EdgeInsets.all(10),
                  child:
                  new Text(syncTables[i].apiName!,
                    style: CustomStyles.headingText(context),)
              ),
              backgroundColor: Colors.grey,
              progressColor: color1,
            ),
            // TextButton(onPressed: () =>
            // {
            // },
            //     child: Text(syncTables[i].type!,
            //       style: CustomStyles.mediumTextstyle(context),))
          ]
      ));
}catch(ex){

}
    }
    setState(() {
      syncMasters = syncWidgets;
    });
  }

  void checkIsfirtTimeSync() async {
    try {
      if (await SessionStorage.isFirstTimeSync()) {
          syncTableStructure();
       }
      else {
        selectSynTable();
        // Navigator.of(context).pushReplacement(new MaterialPageRoute(
        //     builder: (_) => CustomerEntryWidget(key: Key("customer_widget"))));
       }
    } catch (ex) {
      print(ex);
    }
  }


  void syncTableStructure() async {
   await SyncDatabase.getTableStructure(syncTableStructureCallback);
  }

  void syncTableStructureCallback(SyncTablesModal tablesModal) async {
    await createDb(tablesModal.data!.structure);
    await insertSyncMaster(tablesModal.data!.syncTable);
    await selectSynTable();
  }

  Future<void> insertSyncMaster(List<SyncTable>? syncMaster) async {
    mDatabase database = new mDatabase();
    await database.insertsyncMaster(syncMaster!);
    return;
  }


  Future<void> selectSynTable() async {
    try {
      tables = await getSyncTables();
      mDatabase database = new mDatabase();
      SyncTable syncTable = tables[table_index];
      database.getLastUpdated(tables[table_index].tableToAffect!)
      .then(
          (value) async{
          await startSync(
          syncTable.api, syncTable.tableToAffect, syncTable.apiName,
          syncTable.apiToGetLastRecord, tables[table_index], value);
          }
      );

    }
    catch(ex){
       onComplete("");
    }
    }


    Future<List<SyncTable>> getSyncTables() async{
      mDatabase database = new mDatabase();
      List<SyncTable> tables = await database.getSyncTable();
      for(var i=0;i<tables.length;i++){
        progressList.add(0.0);
      }
      getSyncWidgets(tables);
      return tables;
    }

 Future<void> startSync(String? api,String? table_name ,String? apiName, String? apiToGetLastRecord,SyncTable table,String lastUpdatedAt) async {
    String url = BaseUrl + api!;

    SyncDatabase.startSync(url: url,table_name: table_name,type:table.type,var1: table.var1,var2: table.var2,
        var3: table.var3,var4: table.var4,var5: table.var5,lastUpdatedAt:lastUpdatedAt,dataFormat: table.dataformat,callback:progressUpdate,onCompleted:onComplete);

  }

  Future<void> createDb(List<Structure>? syntable) async {
    mDatabase database = new mDatabase(tables: syntable);
    await database.openAppDatabase();
    return;
  }

  progressUpdate(int total_records,String table_name,int current_recoards){
    double percent = (current_recoards/total_records) ;
     if(progressList.elementAt(table_index).isNaN){
        progressList.add(percent);
      }
     else{
       progressList[table_index] = percent;
     }
     getSyncWidgets(tables);
      
  }
  onComplete(String table_name){
    if(table_index <  tables.length) {
      table_index = table_index + 1;
      selectSynTable();
      progressList[table_index] = 1;
      getSyncWidgets(tables);
    }
    else{
      Fluttertoast.showToast(
          msg:sync_successfully,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      SessionStorage.setFirstTimeSync();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>CustomerEntryWidget(key: Key("customer_entry"))));;
    }
  }
  
}
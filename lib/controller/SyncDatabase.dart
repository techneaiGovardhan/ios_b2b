//import 'dart:collection';
import 'dart:convert';
import 'package:b2b/database/database.dart';
import 'package:b2b/database/db_helper.dart';
import 'package:b2b/modal/cat_item_category_master.dart';
import 'package:b2b/modal/cat_item_master.dart';
import 'package:b2b/modal/cat_product_detail_dao.dart';
import 'package:b2b/modal/cat_product_images.dart';
import 'package:b2b/modal/client_master.dart';

import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/modal/employee_dao.dart';
import 'package:b2b/modal/location_master.dart';
import 'package:b2b/modal/site_master.dart';
import 'package:b2b/modal/sync_tables_modal.dart';
import 'package:b2b/modal/wastage_master.dart';
import 'package:b2b/utils/DeviceDetails.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sqflite/sqflite.dart';

class SyncDatabase {
  VoidCallback? updateProgressCallback;
  SyncDatabase({this.updateProgressCallback});

  static getTableStructure(Function tableStructurecallback) async{
      String url = syncMaster;
      Response response;
      try {
        dynamic decoded;
         String? macAddress = await DeviceDetails.getMacAddress();
         String? secretKey = await SessionStorage.getSecreteKey();
         Map<String, dynamic> body = new Map();
         body['macAddress'] = macAddress;
         body['secretKey'] = secretKey;
         var dio = Dio();
         response = await dio.post(url, data: body);
        // if(response.data['status'] == 1) {
            List<Structure> structureLIst = List.from(response.data["structure"]).map((value) => Structure.fromJson(value)).toList();
            List<SyncTable> synctable = List.from(response.data['syncTable']).map((value) => SyncTable.fromJson(value)).toList();
            Data data = Data(structure: structureLIst,syncTable: synctable);
            //}
         SyncTablesModal syncTablesModal = SyncTablesModal(status: response.data['status'] ,message: response.data['message'],data: data);
         tableStructurecallback(syncTablesModal);
      }catch(ex){
         return null;
      }
   }
   static startSync({String? table_name, String? url,String? type,String? var1,String? var2,
                      String? var3,String? var4,String? var5,String? dataFormat,
                       Function? callback,String? lastUpdatedAt,Function? onCompleted
                     }) async{
     try {

        var dio = Dio();
         mDatabase mdatabase =  mDatabase();
        String? secretkey = await SessionStorage.getSecreteKey();
        String? deviceId = await SessionStorage.getMacaddress();
        if(type == "pull") {
          dataFormat = dataFormat!.replaceAll("<mac>", '"' + deviceId! + '"');
          dataFormat = dataFormat!.replaceAll("<auth>", '"' + secretkey! + '"');
          mdatabase.getRecords(table_name).then((value)  async{
            Response response;
            if (value == 0)  {
              dataFormat = dataFormat!.replaceAll("<var1>", '"' + "" + '"');
              dataFormat = dataFormat!.replaceAll("<var2>", '"' + "" + '"');
            }
            else {
              dataFormat = dataFormat!.replaceAll("<var2>", value.toString());
              dataFormat = dataFormat!.replaceAll("<var1>", '"'+lastUpdatedAt!+'"');

            }
            try{

            response = await dio.post(url!, data: json.decode(dataFormat!));

            insert_into_table(
                mdatabase, table_name!, response, callback, onCompleted);
            }  on DioError catch (ex) {
              if(ex.type == DioErrorType.connectTimeout){
                throw Exception("Connection Timeout Exception");
              }
              else if(ex.type == DioErrorType.other){
                 print("other");
              }
              onCompleted!(table_name);
              throw Exception(ex.message);

            } on FormatException catch(ex){
              onCompleted!(table_name);
              throw Exception(ex.message);
            };

            }
            );


        }
        else{
          Response response;
          dataFormat = dataFormat!.replaceAll("<mac>", '"' + deviceId! + '"');
          dataFormat = dataFormat!.replaceAll("<auth>", '"' + secretkey! + '"');
          List<Map<String, dynamic>>? all_records = await mdatabase.getRecordsAll(table_name);
           var decoded = json.encode(all_records);
           dataFormat = dataFormat!.replaceAll("<var1>",decoded );
           dio.post(url!, data: json.decode(dataFormat!)).
           then((value) {
             onCompleted!(table_name);
           },
              onError: (error){
               print(error);
                onCompleted!(table_name);

              });


        }
   }catch(ex){

     onCompleted!(table_name);
     }

     //  dio.post(path);

   }

  static void insert_into_table(mDatabase mdatabase,String table_name,Response response, Function? callback, Function? onCompleted) async {
   try {
     List<dynamic> dynamiclist=[];
     if(table_name != DbHelper.tbl_glo_client_master) {
       dynamiclist = response.data["data"];
     }


     List<Map<String, dynamic>> data=[];
     switch (table_name) {
       case DbHelper.tbl_employee_master:
         {
           data = List.from(dynamiclist)
               .map((value) =>
               EmployeeDao.fromJson(value).toJson()).toList();
         }
         break;
       case DbHelper.tbl_cat_product_detail:
         {
           data = List.from(dynamiclist).map((value) =>
               Cat_product_detail_dao.fromJson(value).toJson()).toList();
         }
         break;
       case DbHelper.tbl_cat_item_master:
         {
           data = List.from(dynamiclist).map((value) =>
                 Cat_item_master.fromJson(value).toJson()).toList();
         }
         break;
       case DbHelper.tbl_cat_product_images:
         {
           data = List.from(dynamiclist).map((value) =>
               Cat_product_images.fromJson(value).toJson()).toList();
         }
         break;
       case DbHelper.tbl_cat_item_master:
         {
           data = List.from(dynamiclist).map((value)=>Cat_item_master.fromJson(value).toJson()).toList();
         }
         break;
       case DbHelper.tbl_cat_item_category_master:
         {
          // data = [];
           data = List.from(dynamiclist).map((value)=>Cat_item_category_master.fromJson(value).toJson()).toList();
         }
         break;
       case DbHelper.tbl_wastageMaster:{
        data= List.from(dynamiclist).map((value) => WastageMaster.fromJson(value).toJson()).toList();
       }
         break;
       case DbHelper.tbl_siteMaster:
         {
           data=List.from(dynamiclist).map((value) => Site_master.fromJson(value).toJson()).toList();
          // data = List.from(dynamiclist).map((value)=>Cat_item_category_master.fromJson(value).toJson()).toList();
         }
         break;
       case DbHelper.tbl_posCustomerDetails:{
         data = [];
       }
         break;
       case DbHelper.tbl_glo_client_master:{
         dynamic rdata = response.data["data"];
         Map<String,dynamic> obj = Client_master.fromJson(rdata).toJson();
         data.add(obj);
         // data = List.from(dynamiclist).map((value)=>Client_master.fromJson(value).toJson()).toList();
       }
       break;
       case DbHelper.tbl_location_master:{
        //dynamic rdata = response.data["data"];
         data = List.from(dynamiclist).map((value) => Location_master.fromJson(value).toJson()).toList();
        // data.add(obj);
         // data = List.from(dynamiclist).map((value)=>Client_master.fromJson(value).toJson()).toList();
       }
       break;
     }
     if (data.length > 0) {
         mdatabase.insertAll(table_name!, data!,callback,onCompleted);
     }
     else {
         mdatabase.insert(
           table_name!, data.first, await mdatabase.openAppDatabase(),onCompleted!,1);
     }
   }catch(ex){
     onCompleted!(table_name!);
   }
  }

 // static Map<String,dynamic> toMap(dynamic value){
 //    Map<String,dynamic>? map;
 //    map= Map();
 //    return map!;
 // }
}
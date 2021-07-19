// import 'dart:async';
// import 'package:b2b/database/cat_item_category_master.dart';
// import 'package:b2b/database/cat_item_master.dart';
// import 'package:b2b/database/cat_product_detail_dao.dart';
// import 'package:b2b/database/glo_employee_master.dart';
// import 'package:b2b/database/glo_location_master.dart';
// import 'package:b2b/database/glo_site_master.dart';
// import 'package:floor/floor.dart';
// import 'package:sqflite/sqflite.dart' as sqflite;
//
//
//
// //part "database.g.dart"; // the generated code will be there
//
// @Database(version: 1, entities: [GloSiteMaster,GloLocationMaster,GloEmployeeMaster,CatProductDetail,CatItemMaster,CatItemCategoryMaster])
// abstract class AppDatabase extends FloorDatabase {
//   GloSiteMaster get gloSiteMasterDao;
// }
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:b2b/database/db_helper.dart';
import 'package:b2b/modal/FilterModal.dart';
import 'package:b2b/modal/ProductDetails.dart';
import 'package:b2b/modal/cat_product_detail_dao.dart';
import 'package:b2b/modal/client_master.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/modal/location_master.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:b2b/modal/sync_tables_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class mDatabase {
  String db = "b2b_catlog.db";
  List<Structure>? tables;
  List<FilterModal> modals = [];
 late Function callbackCategoryFetch;
 // Database mdatabase;
  //Database database;
  mDatabase({this.tables});

   Future<Database?> openAppDatabase() async {
     try {
   final   database =  await  openDatabase(
        p.join(await getDbPath() , db),
         onCreate: (db, version) {
           for (int i = 0; i < tables!.length; i++) {
             db.execute(
                 tables![i].query
             );
           }
         },
      version: 1,
       );
       return database;
     }catch(ex){
       return null;
     }
     }


  getDbPath() async {
    String path;
    path = await getDatabasesPath();
    return path;
  }

  Future<List<SyncTable>> getSyncTable() async{
     try {
       List<SyncTable> syncTables;
       final db = await openAppDatabase();
       List<Map> listSynctables = await db!.rawQuery(
           "select * from glo_sync_master");
       List<SyncTable> tables = List.from(listSynctables).map((value) =>
           SyncTable.fromJson(value)).toList();
       return tables;
     }catch(ex){
       return [];
     }
      
  }

  // Define a function that inserts dogs into the database
  Future<void> insertsyncMaster(List<SyncTable> syncMasterList) async {
     try {
       // Get a reference to the database.
       final db = await openAppDatabase();
       for (var i = 0; i < syncMasterList.length; i++) {
         await db!.insert(
           'glo_sync_master',
           syncMasterList[i].toJson(),
           conflictAlgorithm: ConflictAlgorithm.replace,
         );
       }
     }catch(ex){
       return;
     }
  }
  Future<void> insertAll(String table_name, List<Map<String,dynamic>> syncMasterList, Function? callback, Function? onCompleted) async {
     try {
       // Get a reference to the database.

       final db = await openAppDatabase();

       for (var i = 0; i < syncMasterList.length; i++) {
         List<Map<String,dynamic>> records  =    await  getRow(table_name, whereCond(table_name,0), getArgs(table_name,syncMasterList[i]), db!);
         Map<String,dynamic> row = syncMasterList[i];
         if(table_name == DbHelper.tbl_cat_product_images){
           _createFileFromString(row);
         }
         else if(table_name == DbHelper.tbl_glo_client_master){
           _createLogoFromString(row['logo']);
         }
          if(records.length == 0) {
            insert(table_name, syncMasterList[i], db,onCompleted!,0);
          }
          else{
            update(  table_name, syncMasterList[i], db,
                     whereCond(table_name,1),
                     getArgs(table_name, syncMasterList[i])
                  );
          }
           callback!(syncMasterList.length,table_name,i+1);

       }
       onCompleted!(table_name);

     }catch(ex){
       onCompleted!(table_name);
     }
  }

  List<dynamic> getArgs(String table_name,Map<String,dynamic> columns){
    try {
      List<dynamic> args = [];
      switch (table_name) {
        case DbHelper.tbl_employee_master:
          args.add(columns['employee_id']);
          break;
        case DbHelper.tbl_cat_product_detail:
          args.add(columns["product_id"]);
          break;
        case DbHelper.tbl_cat_product_images:
          args.add(columns["product_id"]);
          args.add(columns["image_name"]);
          break;
        case DbHelper.tbl_cat_item_master:
          args.add(columns["id"]);
          break;
        case DbHelper.tbl_cat_item_category_master:
          args.add(columns["id"]);
          break;
        case DbHelper.tbl_wastageMaster:
          args.add(columns["id"]);
          break;
        case DbHelper.tbl_posCustomerDetails:
          args.add(columns["id"]);
          break;
        case DbHelper.tbl_posOrderDetails:
          args.add(columns["id"]);
          break;
        case DbHelper.tbl_siteMaster:
          args.add(columns["id"]);
          break;
        case DbHelper.tbl_glo_client_master:
          args.add(columns["id"]);
          break;
        case DbHelper.tbl_location_master:
          args.add(columns["id"]);
          break;
      }

      return args;
    }catch(ex){
      return [];
    }
  }

 _createLogoFromString(String imageString) async{
     try {
       Uint8List bytes = base64.decode(imageString);
       Directory directoy = await getApplicationDocumentsDirectory();
       String dir = directoy.path;
       File file = File(dir + "/logo.png");
       if (!await file.exists()) {
         file.create(recursive: false);
       }
       await file.writeAsBytes(bytes);
     }catch(ex){
   print(ex);
     }
 }
   _createFileFromString(Map<String,dynamic> image_obj) async {
     try {
       final encodedStr = image_obj["image"];
       Uint8List bytes = base64.decode(encodedStr);
       Directory directoy =  await getApplicationDocumentsDirectory();
       String dir = directoy.path;
       print("dir={$dir}");
       final path= Directory(dir+image_obj["image_path"]);
       if(!await path.exists()){
         path.create(recursive: false);
       }
     File file = File(dir + image_obj['image_path'] +"/" + image_obj["image_name"]);

       if(! await file.exists()){
         file.create(recursive: false);
       }
       File file1 = File(dir + image_obj['image_path'] +"/" + image_obj["image_name"]);
       print("file_path=${file1.path}");
       await file.writeAsBytes(bytes);
      // return file.path;
     }catch(ex){
       throw(ex);
      // return "";
     }
  }


  String whereCond(String table_name,int options){
     try {
       String? whereCond;
       switch (table_name) {
         case DbHelper.tbl_employee_master:
           if (options == 0)
             whereCond = "where " + DbHelper.employee_id + "= ?";
           else
             whereCond = DbHelper.employee_id + "= ?";
           break;
         case DbHelper.tbl_cat_product_detail:
           if (options == 0)
             whereCond = "where " + DbHelper.id + "= ?";
           else
             whereCond = DbHelper.id + "= ?";
           break;
         case DbHelper.tbl_cat_product_images:
           if (options == 0) {
             whereCond = "where " + DbHelper.product_id + " = ? and " +
                 DbHelper.image_name + " = ?";
           }
           else {
             whereCond =
                 DbHelper.product_id + " = ? and " + DbHelper.image_name +
                     " = ?";
           }
           break;
         case DbHelper.tbl_cat_item_master:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
         case DbHelper.tbl_cat_item_category_master:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
         case DbHelper.tbl_wastageMaster:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
         case DbHelper.tbl_posCustomerDetails:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
         case DbHelper.tbl_posOrderDetails:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
         case DbHelper.tbl_siteMaster:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
         case DbHelper.tbl_glo_client_master:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
         case DbHelper.tbl_location_master:
           if (options == 0) {
             whereCond = "where " + DbHelper.id + " = ?";
           }
           else {
             whereCond =
                 DbHelper.id + " = ?";
           }
           break;
       }
       return whereCond!;
     }catch(ex){
       return "";
     }

  }

  Future<List<Map<String, dynamic>>> getRow( String table_name,String whereCond,
                                             List<dynamic> args,Database db ) async
  {
    try {
      return await db.rawQuery(
          "select * from " + table_name + " " + whereCond, args);
    }catch(ex){
      return [];
    }
    }

  Future<void> insert(String table_name,Map<String,dynamic> record,Database? db,Function onComplete,int type) async{
    try {
    if(table_name == DbHelper.tbl_cat_product_images){
        record.remove("image");
      }
      await db!.insert(
        table_name,
        record,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    if(type == 1){
      onComplete(table_name);
    }
    }catch(ex){
      onComplete(table_name);
    }
  }

  Future<void> update(String table_name,Map<String,dynamic> record,Database? db,
                       String whereCond,List<dynamic> args) async {
    if(table_name == DbHelper.tbl_cat_product_images){
      record.remove("image");
    }
     await db!.update(table_name, record,where:whereCond,whereArgs: args);
  }


  Future<int> getRecords(String? table_name) async{
     try {
       final db = await openAppDatabase();
       List<Map<String,dynamic>> listSynctables = await db!.rawQuery(
           "select * from " + table_name!);
       return listSynctables.length;
     }catch(ex){
       return 0;
     }
  }
  Future<List<Map<String,dynamic>>?> getRecordsAll(String? table_name) async{
    final db = await openAppDatabase();

    if(table_name == DbHelper.tbl_employee_master){
      table_name = table_name! + " where is_active=1";
    }

    List<Map<String,dynamic>> listSynctables =  await db!.rawQuery("select * from "+table_name!);
    return listSynctables;
  }

  Future<String> getLastUpdated(String? table_name) async{
     try {
       final db = await openAppDatabase();
       List<Map<String, dynamic>> listSynctables = await db!.rawQuery(
           "select max(updated_at) as maxDate from " + table_name!);
       return listSynctables[0]['maxDate'] != null
           ? listSynctables[0]['maxDate']
           : "";
     }catch(ex){
       return "";
     }
     }

 Future<List<Map<String,dynamic>>> getFilteredProductImages(List<FilterModal> filtermodals) async{
    String where;
    List<Map<String,dynamic>>? list;
    String group_by = " group by "+DbHelper.product_id;
     List<dynamic> args =      getArguments(filtermodals);
     where = getWhere(filtermodals).join(" and ");
   list = await buildQuery(args,where,group_by);
   return list!;
  }

  insertCustomerDetails (Map<String,dynamic> row) async{
     try {
       final db = await openAppDatabase();
       db!.insert(DbHelper.tbl_posCustomerDetails, row);
     }catch(ex){

     }
     }
  insertCustomerActivity(Map<String,dynamic> row) async{
    try {
      final db = await openAppDatabase();
      db!.insert(DbHelper.tbl_posCustomerDetails, row);
    }catch(ex){

    }
  }
  Future<List<Map<String, dynamic>>> getProductImages({product_id,filter_id}) async{
     try{
      List<Map<String,dynamic>> products=[];
       final db= await openAppDatabase();
       String query = "select a.* from "+ DbHelper.tbl_cat_product_images + " as a join "+
            DbHelper.tbl_cat_product_detail+ " as b on "
         +  DbHelper.product_id+"="+ DbHelper.item_id;

           if(product_id is int){
             query = query + " where ${DbHelper.product_id} = "+ product_id.toString();
             products = await db!.rawQuery(query);
             // products = new List.from(products.reversed).map((e){
             // //   Map<String,dynamic> map = Map();
             // //   map['product_id'] = e['product_id'];
             // //   map['image_name'] = e['image_name'];
             // //   map['image_path']  = e['image_path'];
             // //   map['created_at']  = e['created_at'];
             // //   map['created_by']  = e['created_at'];
             // //   map['updated_at']  = e['updated_at'];
             // //   map['updated_by']  = e['updated_by'];
             // //   return map;
             // // }).toList();
           }
           else {
             query = query + " group by " + DbHelper.product_id + " limit 100";
             products = await db!.rawQuery(query);
           }



     return products;
     }catch(ex){
       print(ex);
       return [];
     }
  }



  Future<List<Map<String,dynamic>>> getRelatedProductImages(product_id) async{
    List<Map<String, dynamic>> images = [];
    try {
      final db = await openAppDatabase();
      List<Map<String, dynamic>> lists = await db!.rawQuery(
          "select category_id from " + DbHelper.tbl_cat_product_detail +
              " where item_id=" + product_id.toString());
      int categoryId = lists[0]['category_id'];
      String query = "select a.* from " + DbHelper.tbl_cat_product_images +
          " as a join " +
          DbHelper.tbl_cat_product_detail + " as b on "
          + DbHelper.product_id + "=" + DbHelper.item_id;
      query = query + " where ${DbHelper.cat_id} = " + categoryId.toString()+" and product_id != "+product_id.toString();
      List<Map<String, dynamic>> productImageList = await db.rawQuery(query);

      for (int i = 0; i < 10; i++) {
        if(!images.contains(productImageList[i])) {
          images.add(getRandomElement(productImageList));
        }
      }
    }catch(ex){
      print(ex);
    }
      return images;


  }

  getFilters(Function completedCallback) async{
     try {
       int filter_id = 0;
       callbackCategoryFetch = completedCallback;
         filters.forEach((element) async {
           await getFiltersList(filter_id++);
       });

     }catch(ex){
       print(ex);
       return null;
     }
   }


  T   getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }
  
  
 Future<ProductDetails?> productDetails(int product_id) async{
     try{
       final db= await openAppDatabase();
      List<Map<String,dynamic>> rows = await db!.query(DbHelper.tbl_cat_product_detail,where: DbHelper.item_id+" = ?",whereArgs: [product_id]);
      Cat_product_detail_dao duo =  Cat_product_detail_dao.fromJson(rows[0]);
      List<Map<String, dynamic>> map = await db!.rawQuery("select "+DbHelper.item_name+" from "+DbHelper.tbl_cat_item_master
          +" where "+DbHelper.id+"= ?",[duo.itemId]);
      ProductDetails details = ProductDetails(duo.id, map[0]['item_nm'], duo.productPrice,duo.barcodeNo, duo.purity, duo.size, duo.netWt, duo.wastage, duo.pieces, duo.currentLocation, duo.clientId, duo.categoryId, duo.itemId, duo.grossWt, duo.isStuded, duo.currentRate, duo.currentStatus, duo.remark, duo.isActive, duo.createdAt, duo.updatedAt);
     return details;
     }catch(ex){
       print(ex);
       return null ;
       //return ProductDetails(_id, product_name, _productPrice, _barcodeNo, _purity, _size, _netWt, _wastage, _pieces, _currentLocation, _clientId, _categoryId, _itemId, _grossWt, _isStuded, _currentRate, _currentStatus, _remark, _isActive, _createdAt, _updatedAt)
     }
 }
  Future<void> customer_logout(Map<String,dynamic> row) async {
    try{
    final db = await openAppDatabase();
    await db!.update(
        DbHelper.tbl_posCustomerDetails, row, where: DbHelper.is_active + " = ?",
        whereArgs: ["1"]);
    }catch(ex){

    }
   }
   void insert_customer_order(Map<String,dynamic> order) async{
     try{
        final db = await openAppDatabase();
        await db!.insert(DbHelper.tbl_posOrderDetails, order);
     }catch(ex){

     }
   }

   Future<List<Map<String,dynamic>>?> getOrderDetails(String customer_mobile_no, String search_text) async {
   try {
     List<Map<String, dynamic>> orders;
     final db = await openAppDatabase();
     // orders = await db!.query(DbHelper.tbl_posOrderDetails,
     //     where: DbHelper.customer_mobile_no + " = ? and "+DbHelper.customer_mobile_no,
     //     whereArgs: [customer_mobile_no]
     // );
     String query;
     if(search_text == null){
       query = "select * from "+DbHelper.tbl_posOrderDetails
           + " where "+DbHelper.customer_mobile_no+" = ?";
       orders = await db!.rawQuery(query,[customer_mobile_no]);
     }
     else{
       query = "select a.*,b.item_nm from "+DbHelper.tbl_posOrderDetails+" as a join "+
           DbHelper.tbl_cat_item_master+" as b on a.product_code = b."+DbHelper.id+
           " where a." + DbHelper.customer_mobile_no+" LIKE '%$customer_mobile_no%' and "+DbHelper.item_name+" LIKE '%$search_text%'";
       //and b."+DbHelper.item_name+" LIKE '%?%'";
       orders = await db!.rawQuery(query);
     }
     return orders;
   }catch(ex){
     print(ex);
      return null;
   }
   }

   Future<String?> getVisitDateTime() async{
     try{
       String dateTime;
       final db  = await openAppDatabase();
        List<Map<String,dynamic>> mapList =   await  db!.rawQuery("select * from "+DbHelper.tbl_posCustomerDetails+" where "+DbHelper.is_active+ " = 1" );
        Map<String,dynamic> obj = mapList[0];
        dateTime = obj['in_dt'];
        return dateTime;
     }catch(ex){
       return null;
     }

   }

   Future<List<Map<String,dynamic>>?> getSiteMaster(int site_id) async{
     try{
       List<Map<String,dynamic>> location_master;
       final db = await openAppDatabase();
       String query = "SELECT * FROM "+DbHelper.tbl_siteMaster+" where id=?";
       location_master =  await db!.rawQuery(query,[site_id]);
       return location_master;
     }catch(ex){
       return null;
     }
   }

  Future<List<Map<String,dynamic>>?> getLocationMaster() async {
     try{
       List<Map<String,dynamic>> location_master;
       final db = await openAppDatabase();
       String query = "SELECT * FROM "+DbHelper.tbl_location_master;
       location_master =  await db!.rawQuery(query);
       return location_master;
     }catch(ex){
         return null;
     }
   }

  getCategoryName(item_id)  async{
     try{
       final db = await openAppDatabase();
       List<Map<String,dynamic>> category_name = await db!.rawQuery("select "+
           DbHelper.category_name+" from "+DbHelper.tbl_cat_item_category_master+ " where "+DbHelper.id+" = "+item_id.toString());
       return category_name[0][DbHelper.category_name];
     }catch(ex){
       return "";
     }
  }

  Future<Client_master?> getClientMaster() async {
     try {
       Client_master client_master;
       final db = await openAppDatabase();
       List<Map<String, dynamic>> list = await db!.rawQuery(
           "select * from " + DbHelper.tbl_glo_client_master);
       client_master = Client_master.fromJson(list[0]);
       return client_master;
     }catch(ex){
       return null;
     }
  }

  Future<String?> getProductName(String barCode) async {
    try {
      String product_name;
      final db = await openAppDatabase();
      List<Map<String,dynamic>> mapList =   await db!.rawQuery("select b.item_nm from "+DbHelper.tbl_cat_product_detail+" as a join "+DbHelper.tbl_cat_item_master+
          " as b on a."  + DbHelper.item_id + "= b." + DbHelper.id + " where "+DbHelper.item_id+" = "+barCode);
        product_name = mapList[0]["item_nm"];
      return product_name;
    }catch(ex){
        return null;
    }
  }

  Future<List<Map<String, dynamic>>> getFiltersList(int filter_id) async {

     List<Map<String,dynamic>> filters =[];
     switch(filter_id){
       case 0:{
        filters= (await get_category_list(filter_id))!;
       }
       break;
       case 1:{
       filters =  (await get_purity(filter_id))! ;
       }
       break;
       case 2:{
         filters =  (await get_size(filter_id))! ;
       }
       break;
       case 3:{
         filters =  (await get_Gram(filter_id))! ;
       }
       break;
       case 4:{
         filters =  (await get_Location(filter_id))! ;
       }
       break;
       case 5:{
         filters = (await get_prices(filter_id))!;
       }
       break;
       case 6:{
         filters =  (await get_DiscountScheme(filter_id))! ;
       }
       break;

       case 7:{
         filters =  (await get_ProductName(filter_id))! ;
       }
       break;
     }

     return filters;
  }

  Future<List<Map<String, dynamic>>?> get_category_list(int filter_Id) async {
     List<Map<String,dynamic>> filters=[];
     try{
       final db = await openAppDatabase();
       List<Map<String,dynamic>> list = await db!.query(DbHelper.tbl_cat_item_category_master);
      for(int i=0;i<list.length;i++){
        Map<String,dynamic> recoard = Map();
        recoard["name"] = list[i][DbHelper.category_name];
        recoard['isSelected'] = false;
        recoard['filter_id'] = filter_Id;
        recoard['unit'] = "";
        filters.add(recoard);
      }
       FilterModal filterModal = FilterModal(filter_Id, "Category", filters);
       // filter_id = filter_id + 1;
       modals.add(filterModal);

       return filters;
     }catch(ex){
       print(ex);
     }
  }



  Future<List<Map<String, dynamic>>?> get_purity(int filter_id) async {
     try{
       final db = await openAppDatabase();
       Map<String,dynamic> purity_Map;
       List<Map<String,dynamic>> filters =[];
       List<Map<String,dynamic>> list = await db!.rawQuery("select distinct max(purity) as maxPurity,min(purity) as minPurity from " + DbHelper.tbl_cat_product_detail);
       purity_Map = list[0];
     //   for(int i=0;i<list.length;i++){
          Map<String,dynamic> recoard = Map<String,dynamic>();
          recoard['range']=purity_Map['minPurity'].toString()+"-"+purity_Map['maxPurity'].toString();
          recoard["name"] = purity_Map['minPurity'].toString()+"-"+purity_Map['maxPurity'].toString();
          recoard['isSelected'] = false;
          recoard['filter_id'] = filter_id;
          recoard['unit'] = "Karat";
          filters.add(recoard);
        //}
       FilterModal filterModal = FilterModal(filter_id, "Purity", filters);
       // filter_id = filter_id + 1;
       modals.add(filterModal);
      return filters;
     }catch(ex){
    print(ex);
     }
  }
  Future<List<Map<String, dynamic>>?> get_size(int filter_id) async {
    try{
      final db = await openAppDatabase();
      Map<String,dynamic> size_Map;
      List<Map<String,dynamic>> filters =[];
      List<Map<String,dynamic>> list = await db!.rawQuery("select distinct min(size) as minSize,max(size) as maxSize from " + DbHelper.tbl_cat_product_detail);
      size_Map = list[0];
     // for(int i=0;i<list.length;i++){
        Map<String,dynamic> recoard = Map<String,dynamic>();
        recoard["range"] = size_Map["minSize"].toString()+"-"+size_Map["maxSize"].toString();
        recoard["name"] = size_Map["minSize"].toString()+"-"+size_Map["maxSize"].toString();
        recoard['isSelected'] = false;
        recoard['filter_id'] = filter_id;
        recoard['unit'] = "" ;
        filters.add(recoard);
      //}
      FilterModal filterModal = FilterModal(filter_id, "Size", filters);
      // filter_id = filter_id + 1;
      modals.add(filterModal);

      return filters;
    }catch(ex){
      print(ex);
    }
  }
  Future<List<Map<String, dynamic>>?> get_Netwt(int filter_id) async {
    try{
      final db = await openAppDatabase();
      Map<String,dynamic> purity_Map;
      List<Map<String,dynamic>> filters =[];
      List<Map<String,dynamic>> list = await db!.rawQuery("select distinct net_wt as name from " + DbHelper.tbl_cat_product_detail);
      purity_Map = list[0];
      for(int i=0;i<list.length;i++){
        Map<String,dynamic> recoard = Map<String,dynamic>();
        recoard["name"] = list[i]["name"].toString()+" gram";
        recoard['isSelected'] = false;
        recoard['filter_id'] = filter_id;
        recoard['unit'] = "gram";
        filters.add(recoard);
      }
      FilterModal filterModal = FilterModal(filter_id, "Net Wt", filters);
      // filter_id = filter_id + 1;
      modals.add(filterModal);

      return filters;
    }catch(ex){
      print(ex);
    }
  }

  Future<List<Map<String, dynamic>>?> get_Gram(int filter_id) async {
    try{
      final db = await openAppDatabase();
      Map<String,dynamic> netWet_Map;
      List<Map<String,dynamic>> filters =[];
      List<Map<String,dynamic>> list = await db!.rawQuery("select distinct max(net_wt)  as maxPrice ,min(net_wt) as minPrice  from " + DbHelper.tbl_cat_product_detail);
      netWet_Map = list[0];
      //for(int i=0;i<list.length;i++){
        Map<String,dynamic> recoard = Map<String,dynamic>();
        recoard["range"]=netWet_Map['minPrice'].toString()+"-"+netWet_Map['maxPrice'].toString();
        recoard["name"] = netWet_Map['minPrice'].toString()+"-"+netWet_Map['maxPrice'].toString();
        recoard['isSelected'] = false;
        recoard['filter_id'] = filter_id;
        recoard['unit'] = "gram";
        filters.add(recoard);
      FilterModal filterModal = FilterModal(filter_id, "Net Wt", filters);
      // filter_id = filter_id + 1;
      modals.add(filterModal);
      //}

      return filters;
    }catch(ex){
      print(ex);
    }
  }

  Future<List<Map<String, dynamic>>?> get_Location(int filter_id) async {
    try{
      final db = await openAppDatabase();
      Map<String,dynamic> purity_Map;
      List<Map<String,dynamic>> filters =[];
      List<Map<String,dynamic>> list = await db!.rawQuery("select site_nm as name from " + DbHelper.tbl_siteMaster);
      purity_Map = list[0];
      for(int i=0;i<list.length;i++){
        Map<String,dynamic> recoard = Map<String,dynamic>();
        recoard["name"] = list[i]["name"].toString();
        recoard['isSelected'] = false;
        recoard['filter_id'] = filter_id;
        recoard['unit'] = "";
        filters.add(recoard);
      }
      FilterModal filterModal = FilterModal(filter_id, "Location", filters);
      // filter_id = filter_id + 1;
      modals.add(filterModal);

      return filters;
    }catch(ex){
      print(ex);
    }
  }

  Future<List<Map<String, dynamic>>?> get_DiscountScheme(int filter_id) async {
    try{
      final db = await openAppDatabase();
      Map<String,dynamic> purity_Map;
      List<Map<String,dynamic>> filters =[];
      List<Map<String,dynamic>> list = await db!.rawQuery("select distinct purity as name from " + DbHelper.tbl_cat_product_detail);
      purity_Map = list[0];
      for(int i=0;i<list.length;i++){
        Map<String,dynamic> recoard = Map<String,dynamic>();
        recoard["name"] = list[i]["name"].toString()+" ";
        recoard['isSelected'] = false;
        recoard['filter_id'] = filter_id;
        recoard['unit'] = "";
        filters.add(recoard);
      }
      FilterModal filterModal = FilterModal(filter_id, "Discount Scheme", filters);
      // filter_id = filter_id + 1;
      modals.add(filterModal);
      return filters;
    }catch(ex){
      print(ex);
    }
  }
  Future<List<Map<String, dynamic>>?> get_ProductName(int filter_id) async {
    try{
      final db = await openAppDatabase();
      Map<String,dynamic> purity_Map;
      List<Map<String,dynamic>> filters =[];
      List<Map<String,dynamic>> list = await db!.rawQuery("select distinct b.item_nm,a.item_id from " + DbHelper.tbl_cat_product_detail+" as a join  "+
          DbHelper.tbl_cat_item_master+" as b on a."  + DbHelper.item_id + "= b." + DbHelper.id + " ");
      purity_Map = list[0];
      for(int i=0;i<list.length;i++){
        Map<String,dynamic> recoard = Map<String,dynamic>();
        recoard["name"] = list[i]["item_nm"].toString();
        recoard["product_id"]  = list[i]['item_id'];
        recoard['isSelected'] = false;
        recoard['filter_id'] = filter_id;
        recoard['unit'] = "Karat";
        filters.add(recoard);
      }
      FilterModal filterModal = FilterModal(filter_id, "Product Name", filters);
      // filter_id = filter_id + 1;
      modals.add(filterModal);
      callbackCategoryFetch(modals);
      return filters;
    }catch(ex){
      print(ex);
    }
  }

  Future<List<Map<String,dynamic>>?> get_prices(int filter_id) async {
     try {
       final db = await openAppDatabase();
       Map<String, dynamic> purity_Map;
       double min_price, max_price, range;
       String price_string;
       List<Map<String, dynamic>> filters = [];
       List<Map<String, dynamic>> list = await db!.rawQuery(
           "select distinct min(product_price) as min_price,max(product_price) as max_price from " +
               DbHelper.tbl_cat_product_detail);
       purity_Map = list[0];

       min_price = purity_Map['min_price'];
       max_price = purity_Map['max_price'];
       Map<String, dynamic> recoard = Map<String, dynamic>();
       recoard["range"] =  min_price.toString() + "-" + max_price.toString();
       recoard['name'] = min_price.toString() + "-" + max_price.toString();
       recoard['isSelected'] = false;
       recoard['filter_id'] = filter_id;
       recoard['unit'] = "Rs.";
       // range = 1000;
       // while(range > 0 ){
       //   Map<String,dynamic> recoard = Map<String,dynamic> ();
       //   price_string = min_price.toString() +"-" + (min_price+range).toString();
       //   recoard["name"] = "Rs "+price_string;
       //   recoard['isSelected'] = false;
       //   recoard['filter_id'] = filter_id;
       //   recoard['unit'] = "Rs.";
       ///   min_price = min_price+range+1;
       //range = max_price - min_price;
       filters.add(recoard);
       // }

       FilterModal filterModal = FilterModal(filter_id, "Price", filters);
       // filter_id = filter_id + 1;
       modals.add(filterModal);
       // for (int i = 0; i < list.length; i++) {
       //   Map<String, dynamic> recoard = Map<String, dynamic>();
       //   recoard["name"] = list[i]["purity"].toString() + " Karat";
       //   recoard['isSelected'] = false;
       //   recoard['filter_id'] = filter_id;
       //   recoard['unit'] = "Karat";
       //   filters.add(recoard);
       // }
       return filters;
     }catch(ex){
       print(ex);
     }
  }
 List<dynamic> getWhere(List<FilterModal> filtermodals){
     List<String> where=[];
     for(int i=0;i<filtermodals.length;i++){
       FilterModal filterModal = filtermodals.elementAt(i);
       where.addAll(getWhereString(filterModal.filterId,filterModal.filters!));
       //  where.addAll(getWhereString(filterModal.filterId,filterModal.filters!));
     }
     //whereQuery = where.join(",");
     return where;
 }
  List<dynamic> getArguments(List<FilterModal> filtermodals) {
     List<dynamic> args=[];

     String whereQuery;
     for(int i=0 ;i<filtermodals.length;i++){
       FilterModal filterModal = filtermodals.elementAt(i);
       args.addAll(getFilteredArgs(filterModal.filterId,filterModal.filters!));
     //  where.addAll(getWhereString(filterModal.filterId,filterModal.filters!));
     }
     //whereQuery = where.join(",");
     return args;
  }

  List<dynamic> getFilteredArgs(int? filterId, List<Map<String,dynamic>> filters) {
     List<dynamic> args = [];
     List<String> categories = [];
     int index=0;

     switch(filterId){
       case 0:
         {
           filters.forEach((element) {
            if(element['isSelected']) {
              categories.add(element['name']);
            }
           });
           // if(categories.length > 1) {
           //   args.add("( " + categories.join(",") + " )");
           // }
           // else{
             if(categories.length == 1) {
               args.add(categories.first);
             }
        //   }
         }
         break;
       case 4: filters.forEach((element) {
         if(element['isSelected']) {
           categories.add(element['name']);
         }

       });
       if(categories.length == 1) {
         args.add(categories.first);
       }
       // else{
       //   if(!categories.isEmpty) {
       //
       //   }
       // }
       break;
       case 6: filters.forEach((element) {
         if(element['isSelected']) {
           categories.add(element['name']);
         }
       });
       if(categories.length == 1) {
         args.add(categories.first);
       }
       // else{
       //   if(!categories.isEmpty) {
       //     args.add(categories.first);
       //   }
       // }
       break;
       case 7: filters.forEach((element) {
         if(element['isSelected']) {
           categories.add(element['name']);
         }
       });
       if(categories.length == 1) {
         args.add(categories.first);
       }
       // else{
       //   if(!categories.isEmpty) {
       //
       //   }
       // }
       break;
       case 1:
         var result = filters[0]['name'].toString().split("-");
          if(filters[0]['isSelected']) {
           // args.add(result[0].toString() + ' and ' + result[1].toString());

          }
       //args[filterId!] = "( "+categories.join(",") +" )";
       break;
       case 2:
         var result = filters[0]['name'].toString().split("-");
         if(filters[0]['isSelected']) {
          //args.add(  result[0].toString() + ' and ' + result[1].toString());

           //args[filterId!] = "( "+categories.join(",") +" )";
         }
         break;
       case 3:
         var result = filters[0]['name'].toString().split("-");
         if(filters[0]['isSelected']) {
           //args.add(result[0].toString() + ' and ' + result[1].toString());

         }
         //args[filterId!] = "( "+categories.join( ",") +" )";
         break;
       case 5:
         var result = filters[0]['name'].toString().split("-");
         if(filters[0]['isSelected']) {
          // args.add(
            //   result[0].toString() + ' and ' + result[1].toString());
         }
         //args[filterId!] = "( "+categories.join(",") +" )";
         break;
     }
     return args;
  }

  Future<List<Map<String,dynamic>>?>  buildQuery(List<dynamic> args, String where,String groupby) async {
      try{
        final db = await openAppDatabase();
        String query = "select a.*,d.category_nm from "+ DbHelper.tbl_cat_product_images + " as a join "+
            DbHelper.tbl_cat_product_detail+ " as b on a."
            +  DbHelper.product_id+"= b."+ DbHelper.item_id + " join "+DbHelper.tbl_cat_item_master+" as c on a."+
            DbHelper.product_id+"="+"c."+DbHelper.id +" join"
            " "+DbHelper.tbl_cat_item_category_master+" as d on b.category_id=d.id";
           if(!where.isEmpty){
             query = query+" where "+where;
           }
         query =   query+groupby;
        List<Map<String,dynamic>> list;
        if(args.length > 0)
        list   =   await  db!.rawQuery(query,args);
        else
         list = await db!.rawQuery(query);

      // print("hello");
        return list;
      }catch(ex){
       print(ex);
      }

  }

  List<String> getWhereString(int? filterId, List<Map<String, dynamic>> filters) {
     List<String> where =[];
     List<String> selected_list=[];
     switch(filterId){
       case 0:
         {
           filters.forEach((element) {
             if(element['isSelected']) {
               selected_list.add("'"+element['name']+"'");
             }
           });
         }
         if(selected_list.length > 1) {
           where.add("d."+DbHelper.category_name + " IN ("+selected_list.join(',')+")");
         }
         else {
           if(!selected_list.isEmpty) {
             selected_list.elementAt(0).replaceAll("'", '');
             where.add(DbHelper.category_name + " = ?");
           }
         }

         break;
       case 4: filters.forEach((element) {
           if(element['isSelected']) {
             selected_list.add("'"+element['name']+"'");
           }
       });
       if(selected_list.length > 1) {
         where.add(DbHelper.current_location + " IN ("+selected_list.join(',')+") ");
       }
       else{
         if(!selected_list.isEmpty) {
           where.add(DbHelper.current_location + " = ? ");
         }
       }
       break;

       case 6: filters.forEach((element) {
         if(element['isSelected']) {
           selected_list.add("'"+element['name']+"'");
         }
         if(selected_list.length > 1){

         }
       });
      // where.add(DbHelper.category_name +" IN ?");
       //args[filterId!] = "( "+selected_list.join(",") +" )";
       break;
       case 7: filters.forEach((element) {
         if(element['isSelected']) {
           selected_list.add("'"+element['name']+"'");
         }
       });
       if(selected_list.length > 1) {
         where.add(DbHelper.item_name + " IN ("+selected_list.join(',')+") ");
       }
       else{
         if(!selected_list.isEmpty) {
           where.add(DbHelper.item_name + " = ? ");
         }
       }
       //args[filterId!] = "( "+categories.join(",") +" )";
       break;
       case 1:
         var result = filters[0]['name'].toString().split("-");
         if(filters[0]['isSelected']) {
           where.add(DbHelper.purity + " between ${result[0]} and ${result[1]} ");

         }
         //args[filterId!] = "( "+categories.join(",") +" )";
         break;
       case 2:
         var result = filters[0]['name'].toString().split("-");
         if(filters[0]['isSelected']) {
           where.add(DbHelper.size + " between ${result[0]} and ${result[1]}");
           //args[filterId!] = "( "+categories.join(",") +" )";
         }
         break;
       case 3:
         var result = filters[0]['name'].toString().split("-");
         if(filters[0]['isSelected']) {
           where.add(DbHelper.netWt + " between ${result[0]} and ${result[1]}");
         }
         //args[filterId!] = "( "+categories.join(",") +" )";
         break;
       case 5:
         var result = filters[0]['name'].toString().split("-");
         if(filters[0]['isSelected']) {
           where.add(DbHelper.product_price + " between ${result[0]} and ${result[1]}");
         }
         //args[filterId!] = "( "+categories.join(",") +" )";
         break;
     }

     return where;
  }




}
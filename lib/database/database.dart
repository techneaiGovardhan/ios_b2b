import 'dart:async';
import 'package:b2b/database/cat_item_category_master.dart';
import 'package:b2b/database/cat_item_master.dart';
import 'package:b2b/database/cat_product_detail.dart';
import 'package:b2b/database/glo_employee_master.dart';
import 'package:b2b/database/glo_location_master.dart';
import 'package:b2b/database/glo_site_master.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;



part "database.g.dart"; // the generated code will be there

@Database(version: 1, entities: [GloSiteMaster,GloLocationMaster,GloEmployeeMaster,CatProductDetail,CatItemMaster,CatItemCategoryMaster])
abstract class AppDatabase extends FloorDatabase {
  GloSiteMaster get gloSiteMasterDao;
}
import 'package:b2b/database/database.dart';
import 'package:b2b/database/db_helper.dart';
import 'package:b2b/modal/constants/dummy_data.dart';
import 'package:sqflite/sqflite.dart';

class CommonMethods {

   Future<Map<String, dynamic>?> searchEmpById(String Id) async{
     try {

       List<Map<String, dynamic>>? dummy_data;
       dummy_data =  await getEmployeeList();
       Map<String, dynamic>? selected_employee=null;
       dummy_data!.forEach((element) {
         if (element['employee_id'].toString().toLowerCase().compareTo(Id.toLowerCase()) == 0) {
            selected_employee = element;
         }
       });
       return selected_employee;
     }catch(Ex){
       return Map<String,dynamic>();
     }
  }

  Future<String> getCounterName() async{
     mDatabase mdatabase = mDatabase();
    List<Map<String,dynamic>>? locations  =   await mdatabase.getLocationMaster();
    String counter = locations![0]['location_nm'];
    return counter;
  }

 Future<List<Map<String, dynamic>>> getEmployeeList() async{
   mDatabase mdatabase = mDatabase();
   List<Map<String, dynamic>>? dummy_data = await mdatabase.getRecordsAll(DbHelper.tbl_employee_master);
     return dummy_data!;
   }
   Future<List<Map<String, dynamic>>> searchEmpByName(String Id) async{
     try {
       List<Map<String, dynamic>>? dummy_data = await getEmployeeList();
       List<Map<String, dynamic>>? filtered_employee_list=[];
       dummy_data!.forEach((element) {
         var searched_text = element['employee_nm'].toString().toLowerCase();
         if (searched_text.contains(Id.toLowerCase())) {
           filtered_employee_list.add(element);
         }
       });
       return filtered_employee_list!;
     }catch(Ex){
       return [];
     }
   }

   Future<String?> getAvailableBranch() async{
     try{

     }catch(ex){

     }
   }



   CommonMethods();
}
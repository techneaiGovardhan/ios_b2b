import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:dio/dio.dart';

class GetAvailableProductLocation {
  Function responseCallback;
 // getLocation() async
  GetAvailableProductLocation(this.responseCallback);
  
  getLocation(String? product_id) async{
   var dio = Dio();  
   String url = getProductAvailableLocation;
   Map<String,dynamic> body=Map();
   body["secretKey"] = await SessionStorage.getSecreteKey();
   body["macAddress"] = await SessionStorage.getMacaddress();
   body["productCode"] = product_id;
    var response =  dio.post(url,data: body);
    response.then((value){
      responseCallback(value);
    });
  }
}
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:dio/dio.dart';

class ShareProduct {
  Function responseCallback;
  // getLocation() async
  ShareProduct(this.responseCallback);

  shareProduct(String? mobileno,int ? id) async{
    var dio = Dio();
    String url = getshareProductUrl;
    Map<String,dynamic> body=Map();
    body["secretKey"] = await SessionStorage.getSecreteKey();
    body["macAddress"] = await SessionStorage.getMacaddress();
    body["mobileNo"] =  mobileno!;
    body["productId"] = id;
    var response =  dio.post(url,data: body);
    response.then((value){
      responseCallback(value);
    });
  }
}
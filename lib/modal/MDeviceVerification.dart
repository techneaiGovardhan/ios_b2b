import 'dart:collection';

class MDeviceVerification {
  String? message;
  int? status;
  List? data;

  MDeviceVerification(this.message, this.status, this.data);

  MDeviceVerification.fromJson(HashMap<String,dynamic> json){
    message = json['message'];
    status =  json['status'];
  }
}
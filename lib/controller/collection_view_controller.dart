import 'dart:convert';

import 'package:b2b/modal/cat_product_images.dart';
import 'package:flutter/services.dart';

class CollectionViewController {
  late MethodChannel _channel;
  Function callBackClickedProduct;
  CollectionViewController({required this.callBackClickedProduct}) {
    _channel = new MethodChannel('Products');
    _channel.setMethodCallHandler(_handleMethod);
  }
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        try {
          Cat_product_images images =  Cat_product_images.fromJson(call.arguments);
             callBackClickedProduct(images);
          //        return new Future.value("Text from native: ${images.toString()}");
        }catch(ex){
          print(ex);
        }
        }
  }
  Future<void>  receiveFromFlutter(String products) async {
    try {
    //   String encode =      jsonEncode(products);
      final String result = await _channel.invokeMethod('receiveFromFlutter', {"text": products});
      print("Result from native: $result");
    } on PlatformException catch (e) {
      print("Error from native: $e.message");
    }
  }

  Future<void> counterGridCountFlutter(int grid_count) async {
    try {
      //   String encode =      jsonEncode(products);
      final String result = await _channel.invokeMethod('GridCount', {"text": grid_count});
      print("Result from native: $result");
    } on PlatformException catch (e) {
      print("Error from native: $e.message");
    }
  }
}
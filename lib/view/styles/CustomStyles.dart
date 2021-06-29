 import 'package:flutter/material.dart';

class CustomStyles{

static TextStyle  mediumTextstyle(){
  return TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800
  );
}
  static InputDecoration customTextFieldStyle(String? hint,bool? isBorder,double? radius){
    return InputDecoration(
      hintText: hint,
       focusedBorder: isBorder! ? OutlineInputBorder(
        borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
      ):InputBorder.none,
        enabledBorder: isBorder! ? OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ):InputBorder.none
    );
  }
}
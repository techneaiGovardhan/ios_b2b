 import 'package:b2b/modal/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomStyles{

static TextStyle  mediumTextstyle(context){
  return TextStyle(
    fontSize: 18 * MediaQuery.textScaleFactorOf(context),
    fontWeight: FontWeight.w800
  );
}
  static InputDecoration customTextFieldStyle(String? hint,bool? isBorder,double? radius){
    return InputDecoration(
      counterText: "",
      hintText: hint,
       focusedBorder: isBorder! ? OutlineInputBorder(
        borderSide: BorderSide(color: color1, width: 1.0),
         borderRadius: BorderRadius.circular(radius!)
      ):InputBorder.none,
        enabledBorder: isBorder ? OutlineInputBorder(
            borderSide: BorderSide(color:color1 , width: 1.0),
            borderRadius: BorderRadius.circular(radius!)
        ):InputBorder.none
    );
  }
  static headingBlackText(context){
    return TextStyle(
        fontSize: 20 * MediaQuery.of(context).textScaleFactor,
        color: Colors.black
    );
  }

  static ButtonStyle customButtonStyle(){
    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(getColor),
    );
  return buttonStyle;
  }


static Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return color1;
  }
  return color1;
}

  static Border border() {
  return Border.all(color: color1,width: 1.0,style: BorderStyle.solid);
  }

  static TextStyle buttonText(BuildContext context) {
   return TextStyle(
     fontSize: 18 * MediaQuery.of(context).textScaleFactor
   );
  }

  static TextStyle title_with_white_text(BuildContext context) {
    return TextStyle(
        fontSize: 18 * MediaQuery.of(context).textScaleFactor,
      color: Colors.white
    );
  }

  static headingText(BuildContext context) {
    return TextStyle(
        fontSize: 20 * MediaQuery.of(context).textScaleFactor,
        color: color1
    );
  }

  static smallTextStyle(context) {
    return TextStyle(
        fontSize: 14 * MediaQuery.of(context).textScaleFactor,
        color: Colors.black
    );
  }
static smallTextBoldStyle(context) {
  return TextStyle(
      fontSize: 14 * MediaQuery.of(context).textScaleFactor,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );
}

  static boxDecoration() {
  return BoxDecoration(
      border: CustomStyles.border(),
      borderRadius: BorderRadius.circular(50)
  );
  }

  static customBoarderdButtonStyle() {
   return ButtonStyle(

   );
  }

}
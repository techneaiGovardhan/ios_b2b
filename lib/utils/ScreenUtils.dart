import 'package:flutter/cupertino.dart';

class ScreenUtils {
  BuildContext? context ;
  ScreenUtils({this.context});

 double getWidthPercent(percent) {
    return MediaQuery.of(this.context!).size.width * (percent / 100);
  }
  getHeightPercent(percent){
    return MediaQuery.of(this.context!).size.height * (percent / 100);
  }
}
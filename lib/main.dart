import 'package:b2b/view/Login.dart';
import 'package:flutter/material.dart';

import 'modal/constants/constants.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: color1,
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        home: Login(key: Key("login")
        )
      )
  );
}




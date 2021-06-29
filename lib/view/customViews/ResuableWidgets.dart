import 'package:flutter/material.dart';

class ResuableWidgets{
 static Widget AppLogo(String path){
    return(
        InkWell(
          child:
             Image.asset(
                  path
            )
        )
    );
  }
}
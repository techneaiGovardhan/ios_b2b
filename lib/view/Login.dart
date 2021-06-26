import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child:Center(
        child: Column(
          children: [
             _logo()
          ],
        ),
      ) ,
    ));
  }

  _logo(){
    return(
      Image.asset("assets/logo.png")
    );
  }

}

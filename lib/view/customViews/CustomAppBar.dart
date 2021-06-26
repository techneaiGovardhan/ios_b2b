import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget {
  String? title = null;
  Widget? leading_widget=null;
  List<Widget>? actions = null;
 CustomAppBar({required Key key,this.title,this.leading_widget,this.actions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.title!),
      actions: this.actions,
      leading: this.leading_widget,
    );
  }
}

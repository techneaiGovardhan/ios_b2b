import 'package:b2b/utils/ScreenUtils.dart';
import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  Widget? wtitle = null;
  Widget? leading_widget=null;
  List<Widget>? actions = null;
  Size? mpreferredSize;
 CustomAppBar({required Key key,this.wtitle,this.leading_widget,this.actions,this.mpreferredSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   // ScreenUtils _utils = ScreenUtils(context: context);
    return AppBar(
      title:wtitle ,
      actions: this.actions,
      leading: this.leading_widget,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => mpreferredSize!;
}

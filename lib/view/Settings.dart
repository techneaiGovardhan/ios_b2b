
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/view/customViews/CustomAppBar.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late ScreenUtils _screenUtils;
  late String ip1_protocal,ip1_protocal1;
  TextEditingController _address1_controller = TextEditingController();
  TextEditingController _address2_controller = TextEditingController();
  TextEditingController _route_controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
     _screenUtils = ScreenUtils(context: context);
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: CustomAppBar(
  wtitle: Text("Settings"),
  mpreferredSize: Size(_screenUtils.getWidthPercent(100),
      _screenUtils.getHeightPercent(5)),
  key:Key("Settings") ,
),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _globalKey,
            child: Column(
             children: [
                  _address1(),
                  _address2(),
                  _route(),
             ],
        ),
          ),
        ),
      ),
    );
  }

  _address1() {
    return Container(
      margin:EdgeInsets.all(10),
      decoration: CustomStyles.boxDecoration(),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child:DropdownButton<String>(
                    value: "http",
                    items: <String>["http","https"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),

                    onChanged: (_) {},
                  )

              ),
              _verticalDivider(),
              Expanded(
                flex: 6,
                child: TextFormField(
                  controller: _address1_controller,
                  decoration: CustomStyles.customTextFieldStyle("Enter Ip Address 1", false, 0),

        ),
              ),
            ],
          )
      ),
    );
  }
  _verticalDivider() =>
      Container(
        margin: EdgeInsets.only(left: marging_top,right: marging_top),
        width: 1,
        height: _screenUtils!.getHeightPercent(6),
        color: color1,
      );

  _address2(){
    return Container(
      margin:EdgeInsets.all(10),
      decoration: CustomStyles.boxDecoration(),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child:DropdownButton<String>(
                      value: "http",
                    items: <String>["http","https"].map((String value) {

                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  )

              ),
              _verticalDivider(),
              Expanded(
                flex: 6,
                child: TextFormField(
                  controller: _address2_controller,
                  decoration: CustomStyles.customTextFieldStyle("Enter Ip Address2", false, 0),

                ),
              ),
            ],
          )
      ),
    );
  }

  _route() {
    return Container(
      decoration: CustomStyles.boxDecoration(),
      child: Padding(padding: EdgeInsets.only(bottom: 10,top: 10,left: 25,right: 25),
      child: TextFormField(
        controller:_route_controller ,
        decoration: CustomStyles.customTextFieldStyle("Enter route", false, 0),
      )),
    );

  }

}

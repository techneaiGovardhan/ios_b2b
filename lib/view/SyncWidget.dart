import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
class SyncWidget extends StatefulWidget {
  const SyncWidget({required Key key}) : super(key: key);

  @override
  _SyncWidgetState createState() => _SyncWidgetState();
}

class _SyncWidgetState extends State<SyncWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
              child:
              GridView.count(crossAxisCount: 2,children: [
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: 0,
                  header: new Text("Employee"),
                  center: new Icon(
                    Icons.person_pin,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: 0,
                  header: new Text("Images"),
                  center: new Icon(
                    Icons.person_pin,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: 0,
                  header: new Text("Products"),
                  center: new Icon(
                    Icons.person_pin,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: 0,
                  header: new Text("Rates"),
                  center: new Icon(
                    Icons.person_pin,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                )

              ],)


          ),
        ),
      ),
    );
  }
}

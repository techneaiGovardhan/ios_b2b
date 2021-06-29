import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/material.dart';
class CustomerEntryWidget extends StatefulWidget {
  const CustomerEntryWidget({required Key key}) : super(key: key);

  @override
  _CustomerEntryWidgetState createState() => _CustomerEntryWidgetState();
}

class _CustomerEntryWidgetState extends State<CustomerEntryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             _customerNo(),
              _empNameContainer(),
              _save()
            ],
          ),
        )
    );
  }
  _save(){
    return(
       Container(
         child:
          ElevatedButton(onPressed: () {

         },
           child: Text("Save"),

         ),
       )
    );
}
  _customerNo() {
    return (
        Container(
            child:
            TextField(
              decoration: CustomStyles.customTextFieldStyle(
                  "Customer number", true, 10),
            )
        )
    );

  }
  _empNameContainer(){
    return Row(
      children: [
        Expanded(
            flex: 1,
            child:
        Row(
          children: [
             Expanded(
               flex: 2,
               child: TextField(
                 decoration: CustomStyles.customTextFieldStyle("Emp Id", false, 0),
               ),
             ),
            Expanded(
                flex: 1,
                child: Icon(
              Icons.search,
              size: 24,
            ))
          ],
        )
        ),
        Expanded(
            flex: 2,
            child:TextField(
              decoration: CustomStyles.customTextFieldStyle("Employee name", true, 10),
        ))
      ],
    );
  }
}

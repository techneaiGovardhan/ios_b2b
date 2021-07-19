import 'dart:io';

import 'package:b2b/controller/share_product.dart';
import 'package:b2b/database/database.dart';
import 'package:b2b/modal/ProductDetails.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/customViews/ResuableWidgets.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class ProductDetailsView extends StatefulWidget {
  int? product_id;
  File? imageFile;
  ProductDetails? current_product;
  ProductDetailsView({Key? key,required this.current_product,required this.imageFile}) : super(key: key);

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  ScreenUtils? _screenUtils;
  List<Widget> product_details=[];
  ResuableWidgets? _resuableWidgets;
  double product_height = 80.0;
  ProductDetails? currentProduct;
  bool isInfo  = false;
  String bt_text = "bt_text";
  mDatabase? mdatabase;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _customer_mobile_no=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init_methods();
  }

 // File getImageFile(path){
 //    return File(path);
 //  }
 // String getFilePath(ProductDetails productDetails) async{
 //    String path;
 //    Directory dir = await getApplicationDocumentsDirectory();
 //
 //    return "";
 // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      child: Stack(
        children: [
          Column(
            children:[
            _BannerImage(widget.imageFile),
            _WidgetRowProudctDetails(currentProduct!),

           ]
          ) ,
      Visibility(
          visible: isInfo,
          child:
          Positioned(
             left: 0,
             right: 0,
             bottom: 0,
             child:Column(
               children: [
                 _WidgetProductDetails(widget.current_product!),
                 ResuableWidgets.BottomView(_screenUtils, context,widget.current_product!.itemId) ,
               ],
             )
          )
           )
        ],
      ),
    ),
    );
  }


  Widget _BannerImage(File? file){
    return Container(
      width: _screenUtils!.getWidthPercent(100),
      height: _screenUtils!.getHeightPercent(40),
      child: Stack(
        children:[
          Container(
            width: _screenUtils!.getWidthPercent(100),
            height: _screenUtils!.getHeightPercent(product_height),
            child: Image.file(file!,fit: BoxFit.cover),
          ),
          Positioned(
            right: 10,
            top: 25,
            child: Align(
                alignment: Alignment.topRight,
                child:
                Material(
                  elevation: 2.0,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => share_product(),
                    child: Container(
                      padding: EdgeInsets.all(9.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: color1, width: 1.4)),
                      child: Icon(
                        Icons.share,
                        size: 22,
                        color: color1,
                      ),
                    ),
                  ),
                )),
            //Icon(Icons.share,color:  color1,),
            // child: OutlinedButton(
            //   style:  OutlinedButton.styleFrom(
            //     primary: color1,
            //     side: BorderSide(color: color1,width: 2)
            // ),
            //   onPressed: () {  },
            //   child: Text("Share",style: CustomStyles.smallTextStyle(context),),
            // ),
          ),
          Positioned(
            top: 25,
            left: 10,
            child: Container(

              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: color1,
                    side: BorderSide(color: color1,width: 2)
                ),
                onPressed: () {
                 setState(() {
                    isInfo = isInfo;
                 });
                  //Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProductDetailsView(key:Key("productViewDetails"), current_product:currentProduct,imageFile:gallaryItems[0])));
                },
                child: Text(bt_text,style: CustomStyles.smallTextStyle(context),),

              ),
            ),
          ),
        ]
      ),
    );
  }

  void init_methods()  async{
    mdatabase = mDatabase();
    _screenUtils = ScreenUtils(context: context);
    _resuableWidgets = ResuableWidgets();
    currentProduct =    (await mdatabase!.productDetails(widget.product_id!));
  }

  _WidgetRowProudctDetails(ProductDetails details) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                child:Text(details.product_name,style: CustomStyles.headingBlackText(context)) ,
              )

          ),
          Align(
            alignment: Alignment.topRight,
            child: Expanded(
                flex: 1,
                child:Container(
                 child:Row(
                   children: [
                     Text(currency,style: CustomStyles.headingBlackText(context)),
                     Text(details.productPrice.toString(),style: CustomStyles.headingBlackText(context)),
                   ],
                 ) ,

         )
            ),
          )
        ],
      ),
    );
  }

  _WidgetProductDetails(ProductDetails productDetails) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Expanded(
        flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child:
                                Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Proudct Details",style: CustomStyles.smallTextBoldStyle(context),)),
                                    SizedBox(
                                      height: _screenUtils!.getHeightPercent(2),
                                    ),
                                    Column(
                                      children:widget_product_details(),
                                  )

                                  ],
                                )
                            ),
                            Expanded(
                            flex:1,
                                child:
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Align(
                                          child: Text("Stone Details",style:
                                          CustomStyles.smallTextBoldStyle(context))
                                      ,alignment: Alignment.topLeft,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child:
                                                Text("Weight")
                                              ),
                                              Expanded(child:Text(productDetails.grossWt.toString()))
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 5,top: 5),
                                            height: _screenUtils!.getHeightPercent(0.1),
                                            color: color1,
                                          )
                                        ],
                                      )

                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),

                      ],
                    ),
                  )

                ],
              ),
            ),
          )
      ),
    );
  }

  widget_product_details() {
    List<Widget> listWidgets=[];
    ProductDetails details = widget.current_product!;
    listWidgets.add(
      Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child:
                  Text(title_purity,style: CustomStyles.smallTextStyle(context)),

              ),
              Expanded(child:
              Text(details.purity.toString()!,
                   style:CustomStyles.smallTextStyle(context))
                 )
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5,top: 5),
            height: _screenUtils!.getHeightPercent(0.1),
            color: color1,
          )
        ],
      )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_size,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                Text(details.size.toString()!,
                    style:CustomStyles.smallTextStyle(context))
                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_net_wt,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                Text(details.netWt.toString(),
                    style:CustomStyles.smallTextStyle(context))
                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_product_code,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                Text(details.barcodeNo!,
                    style:CustomStyles.smallTextStyle(context))
                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_product_name,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                Text(details.product_name!,
                    style:CustomStyles.smallTextStyle(context))
                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_category,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                  FutureBuilder<String>(
                    future: getCategoryName(details.itemId),
                    builder: (context,data){
                      if(data.hasData){
                        return Text(data.data!);
                      }
                      else{
                        return Text("");
                      }
                    },
                  )

                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_wastage,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                Text(details.wastage.toString(),
                    style:CustomStyles.smallTextStyle(context)),

                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_pieces,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                Text(details.pieces!.toString(),
                    style:CustomStyles.smallTextStyle(context))
                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    listWidgets.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Text(title_current_location,style: CustomStyles.smallTextStyle(context)),

                ),
                Expanded(child:
                Text(details.currentLocation!,
                    style:CustomStyles.smallTextStyle(context))
                ),

              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5,top: 5),
              height: _screenUtils!.getHeightPercent(0.1),
              color: color1,
            )
          ],
        )
    );
    return listWidgets;
  }
  share_product() {

    _resuableWidgets!.showAlertDialog(context: context, title: "Share Product",
        contentWidget: shareProductBody(), cancelActionText:"Share",
        defaultActionText: "Cancle", okCallBack: shareDialogCallback);

  }

  shareProductBody() {

    return Form(
      key: _globalKey,
      child: Container(

          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(20),
                  child:Center(
                    child: Text("Ask whatsapp number to customer",style: CustomStyles.smallTextBoldStyle(context),),
                  )
              ),
              SizedBox(
                height: 30,
              ),
              Material(
                child: TextFormField(
                  controller: _customer_mobile_no,
                  decoration: CustomStyles.customTextFieldStyle("Enter whatsapp number ", true, 0),
                  validator: (value){
                    RegExp regex = new RegExp(mobileRegex);
                    if(value!.isEmpty){
                      return "Enter customer whatsapp mobile no";
                    }
                    else if(!regex.hasMatch(value)){
                      return "Enter customer whatsapp valid mobile no";
                    }
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
  shareDialogCallback() async{
    final valid =  _globalKey.currentState!.validate();
    if(!valid){
      return;
    }
    ShareProduct shareProduct = ShareProduct(onResponse);
    shareProduct.shareProduct(_customer_mobile_no.text,widget.product_id);
  }


  void onResponse(Response<dynamic> response){
        int status = response.data["status"];
        var message = response.data["message"];
        if(status == 1){
          Fluttertoast.showToast(
              msg:message ,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        else{
          Fluttertoast.showToast(
              msg:message ,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        Navigator.of(context).pop();
  }
}


Future<String> getCategoryName(int? item_id)  async{
  mDatabase database = mDatabase();
 String category_name =  await database.getCategoryName(item_id!);
 return category_name;

}

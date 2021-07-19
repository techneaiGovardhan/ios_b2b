import 'dart:io';
import 'package:b2b/controller/share_product.dart';
import 'package:b2b/database/database.dart';
import 'package:b2b/modal/FilterModal.dart';
import 'package:b2b/modal/ProductDetails.dart';
import 'package:b2b/modal/cat_product_images.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/OrderViewWidget.dart';
import 'package:b2b/view/customViews/ResuableWidgets.dart';
import 'package:b2b/view/proudct_details_view.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sqflite/sqflite.dart';

class ProductViewWidget extends StatefulWidget {
 int? product_id;


  ProductViewWidget(this.product_id);
  

  @override
  _ProductViewWidgetState createState() => _ProductViewWidgetState();
}

class _ProductViewWidgetState extends State<ProductViewWidget> {
  late PageController _pageController;
  List<File> gallaryItems=[];
  List<File> similerProducts=[];
  ProductDetails? currentProduct;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  mDatabase? mdatabase;
  List<ProductDetails> similerProductsDetails=[];

  final CarouselController _controller = CarouselController();

  ScreenUtils?  _screenUtils;
  ResuableWidgets? _resuableWidgets;
  bool isInfo =false;
  int _current=0;
  String bt_text="View More";
  TextEditingController _customer_mobile_no=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    

    inti_methods();
  }
 List<Widget> getImagesSlider(){
    final List<Widget> imageSliders = gallaryItems
        .map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                //Text("Share",style: CustomStyles.headingText(context),),
                Container(
                  width: _screenUtils!.getWidthPercent(100),
                  child: PhotoView(
                    imageProvider:FileImage(item)
                  ,initialScale: 0.5,
                   ),
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
                          isInfo = !isInfo;
                          if(isInfo){
                            bt_text = "Hide Details";
                          }
                          else {
                            bt_text = "View More";
                          }
                        });
                       // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProductDetailsView(key:Key("productViewDetails"), current_product:currentProduct,imageFile:gallaryItems[0])));
                      },
                      child: Text(bt_text,style: CustomStyles.smallTextStyle(context),),

                    ),
                  ),
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


                //),
              //  Image.file(item, fit: BoxFit.cover, width: 1000.0),
              //   Positioned(
              //     bottom: 0.0,
              //     left: 0.0,
              //     right: 0.0,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [
              //             Color.fromARGB(200, 0, 0, 0),
              //             Color.fromARGB(0, 0, 0, 0)
              //           ],
              //           begin: Alignment.bottomCenter,
              //           end: Alignment.topCenter,
              //         ),
              //       ),
              //       padding: EdgeInsets.symmetric(
              //           vertical: 10.0, horizontal: 20.0),
              //       child: Text(
              //         'No. ${gallaryItems.indexOf(item)} image',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 20.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              ],
            )),
      ),
    ))
        .toList();
    return imageSliders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
       // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Column(
      children:[
        gallaryItems.length > 0 ?
        Expanded(child:
        _BannerWidget(gallaryItems),
            flex: 4,
        ):Container(),

        currentProduct != null ?
        Expanded(
          flex:1,
          child: _WidgetRowProudctDetails(currentProduct!)
        )
                :
        Container(),
        ]
            ),
          ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child:Column(
              children: [
                Visibility(
                    child:
                    currentProduct != null ? _WidgetProductDetails(currentProduct!):Container(),
                visible: isInfo,),
                currentProduct != null ? ResuableWidgets.BottomView(_screenUtils, context,currentProduct!.itemId):Container() ,
              ],
            )
        )

      //  )
        //  similerProducts.length > 0 ?
         // _RelatedProductS(similerProducts):Container(),
         //ResuableWidgets.BottomView(_screenUtils, context,widget.product_id)
        ],
      ),
    );
  }

  _WidgetProductDetails(ProductDetails productDetails) {
    return Align(
      alignment: Alignment.bottomCenter,
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
      ),
    );
  }

  Widget _causalImage(){
    return Expanded(
      flex: 4,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
                child: CarouselSlider(
                  carouselController:_controller ,
                options: CarouselOptions(
                  viewportFraction: 1,
                autoPlay: false,

                enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
            ),

            items: getImagesSlider()

            )),
          ),
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: gallaryItems.asMap().entries.map((entry) {
      return GestureDetector(
      onTap: () => _controller.animateToPage(entry.key),
      child: Container(
      width: 12.0,
      height: 12.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: (Theme.of(context).brightness == Brightness.dark
      ? Colors.white
          : Colors.black)
          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
      ),
      );
      }).toList()
      )
        ],
      ),
    );
  }
  widget_product_details() {
    List<Widget> listWidgets=[];
    ProductDetails details = currentProduct!;
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
                  future: getCategoryName(details.categoryId),
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

 Widget _BannerWidget(List<File> galleryItems){
    return Container(
      height: _screenUtils!.getHeightPercent(60),
      child: (
      Stack(
        children:[
          PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(
            color: Colors.white
          ),
          builder: (BuildContext context, int index) {
            final file = gallaryItems[index];
            final size = ImageSizeGetter.getSize(FileInput(file));
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(galleryItems[index]),
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          itemCount: galleryItems.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                  value: event == null
                    ? 0
                    :100
              ),
            ),
          ),
          onPageChanged: (e) {
          },
          pageController: _pageController,
          // backgroundDecoration: widget.backgroundDecoration,
          // pageController: widget.pageController,
          // onPageChanged: onPageChanged,
        ),
          Positioned(
            top: 25,
            left: 10,
            child: Container(

              child: ElevatedButton(
                style:CustomStyles.customButtonStyle(),
                onPressed: () {
                  setState(() {
                    isInfo = !isInfo;
                    if(isInfo){
                      bt_text = "Hide Details";

                    }
                    else {
                      bt_text = "View More";
                    }
                  });
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProductDetailsView(key:Key("productViewDetails"), current_product:currentProduct,imageFile:gallaryItems[0])));
                },
                child: Text(bt_text,style: CustomStyles.smallTextStyle(context),),

              ),
            ),
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
        ]
      )),
    );
}

 Widget _ProductDetails(String product_name) {
   return Expanded(
     flex: 1,
     child: (
         Container(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [

                  Text(
                         product_name,
                         style: CustomStyles.mediumTextstyle(context)
                      )

               ],
           ),
         )
     ),
   );
 }

 Widget _RelatedProductS(List<File> similerProducts) {
      return _widgetProductList(similerProducts);
  }




 _getProductImages() async{
    List<Map<String,dynamic>> productImages;
    List<File> files=[];
    mDatabase mdatabase = mDatabase();
    productImages = await mdatabase.getProductImages(product_id: widget.product_id) ;
   for(int i=0;i<productImages.length;i++){
     Directory dir = await getApplicationDocumentsDirectory();
     String path = dir.path+productImages[i]['image_path']+"/"+productImages[i]['image_name'];
     File file = File(path);
     files.add(file);
   }
   setState(() {
     gallaryItems = files;
   });
 }

 _widgetProductList(List<File> files) {
    return Expanded(
      flex: 2,
      child: Container(
        width: _screenUtils!.getWidthPercent(100),
        child: ListView.builder(
           shrinkWrap: true,
            scrollDirection:Axis.horizontal,
            itemBuilder: (context,index)=>_custom_widget_product(files[index]),
            itemCount: files.length
          ),
      ),
    );

  }

  _custom_widget_product(File file) {
    return Card(
      child:Container(
        child: Image.file(file),
      ) ,
    );
  }

  void inti_methods() async {
    _screenUtils = ScreenUtils(context: context);
    _pageController = new PageController(initialPage: 0);
    _resuableWidgets = ResuableWidgets();

    mdatabase = mDatabase();
    await _getProductImages();

    mdatabase!.productDetails(widget.product_id!).then((value){
      setState(() {
        currentProduct = value;
      });
    });


    //similerProducts = getSimilarProductsImages(mdatabase,widget.product_id);
    _customer_mobile_no.text = (await SessionStorage.getCustomerMobileno())!;

  }

  getSimilarProductsImages(mDatabase? mdatabase, int? product_id) async {
    try {
      List<File> files = [];
      List<Map<String, dynamic>> productList = await mdatabase!
          .getRelatedProductImages(product_id);
      for (int i = 0; i < productList.length; i++) {
        Directory dir = await getApplicationDocumentsDirectory();
        String path = dir.path + productList[i]['image_path'] + "/" +
            productList[i]['image_name'];
        File file = File(path);
        files.add(file);
      }
      setState(() {
        similerProducts = files;
      });
    }catch(ex){
      throw(ex);
    }
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

          ElevatedButton(onPressed: (){
            shareDialogCallback();
          },
              style: CustomStyles.customButtonStyle(),

              child: Text("Share",style: CustomStyles.title_with_white_text(context),))
        ],
      )
    ),
  );  
 }
  _WidgetRowProudctDetails(ProductDetails details) {
    return Container(
      width: _screenUtils!.getWidthPercent(100),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
             alignment: Alignment.topLeft,
              child: Container(
                child:Text(details.product_name,style: CustomStyles.headingBlackText(context)) ,
              )

          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child:Row(
                children: [
                  Text(currency,style: CustomStyles.headingBlackText(context)),
                  Text(details.productPrice.toString(),style: CustomStyles.headingBlackText(context)),
                ],
              ) ,

            ),
          )
        ],
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


//}

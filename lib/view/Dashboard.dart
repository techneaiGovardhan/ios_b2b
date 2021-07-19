import 'dart:convert';
import 'dart:io';

import 'package:b2b/controller/collection_view_controller.dart';
import 'package:b2b/database/database.dart';
import 'package:b2b/database/db_helper.dart';
import 'package:b2b/modal/FilterModal.dart';
import 'package:b2b/modal/cat_product_images.dart';
import 'package:b2b/modal/client_master.dart';
import 'package:b2b/modal/constants/constants.dart';
import 'package:b2b/modal/location_master.dart';
import 'package:b2b/utils/DeviceDetails.dart';
import 'package:b2b/utils/ScreenUtils.dart';
import 'package:b2b/utils/SessionStorage.dart';
import 'package:b2b/view/CustomerEntryWidget.dart';
import 'package:b2b/view/FilterViewWidget.dart';
import 'package:b2b/view/OrderViewWidget.dart';
import 'package:b2b/view/ProductViewWidget.dart';
import 'package:b2b/view/ReceivedOrderView.dart';
import 'package:b2b/view/SyncWidget.dart';
import 'package:b2b/view/customViews/CustomAppBar.dart';
import 'package:b2b/view/customViews/ResuableWidgets.dart';
import 'package:b2b/view/customer_ordered_list.dart';
import 'package:b2b/view/styles/CustomStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../view/Settings.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({required Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {
  final String viewType = 'collectionview';
  ScreenUtils? _screenUtils;
  late mDatabase mdatabase;
   List<Map<String,dynamic>> lists=[];
   int crossAxisCount = 5;
   List<Map<String, dynamic>> creationParams = [];
  late List<FilterModal> filterList=[];

  //MessageCodec<dynamic> _messageCodec = [];
  String? url;
  late CollectionViewController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init_methods();
  }

  init_methods()  async{
     _screenUtils  = ScreenUtils(context: context);
     await  _getProductImages();
     clear_all();


  }
  void clear_all()  async{

    for(int i=0;i<filterList.length;i++){
      FilterModal obj = filterList![i];
      obj.filters!.forEach((element) {
        element['isSelected'] = false;
      });
    }
    setState(() {
      filterList = filterList;
    });
    clear_filter_session();
  }

  void clear_filter_session() async {
    try {
      String filterd_string = json.encode(filterList);
      await SessionStorage.saveFilter(filterd_string);
    }catch(ex){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child:
        Stack(
        children:[
        ListView(
          children:
            _sidebarWidget()
        ),
        Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
          children: [
          Expanded(child:FutureBuilder<String>(future:
          DeviceDetails.getVersion() ,
          builder:(context,data){
          if(data.hasData){
            return Text(version_string+data.data!,style: CustomStyles.smallTextBoldStyle(context),);
          }
          else{
            return Text("");
          }
          },
          ),
          flex: 3,),
          Expanded(
          flex: 1,
          child: InkWell(
            onTap: (){
               Navigator.of(context).push(MaterialPageRoute(builder:(_)=>Settings()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.settings,size: 24,color:color1,),
            ),
          ))
    ],
    ),
        ),
    )
        ],
      )
      ),
      appBar: CustomAppBar(
                    key: Key("appbar"),
                    wtitle: Text("Home",style: CustomStyles.title_with_white_text(context),),
                    mpreferredSize: Size(_screenUtils!.getWidthPercent(100),_screenUtils!.getHeightPercent(8)),
                    actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: (){
                            // _controller.counterGridCountFlutter(5);
                            setState(() {
                              crossAxisCount = 5;
                            });
                            },
                           child:Text("5")
                          ),
                        ),
                        Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                crossAxisCount = 3;
                              });
                            },
                            child:Text("3"),
                        ),
                      ),
                        Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                crossAxisCount = 1;
                              });
                            },
                            child:Text("1")
                        ),
                      ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                  onTap: (){
                                   navigate_to_filter_widget();
                                 },
                                child: Icon(Icons.filter_alt_sharp,size: 24,color: Colors.white,)),
                          ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                _scaffoldKey.currentState!.openEndDrawer();
                              },
                                child: Icon(Icons.menu,size: 24,color: Colors.white,)),
                          )
                        ],leading_widget:Platform.isIOS ? _IosLeadingWidget(url): ResuableWidgets.AppLogo("assets/logo1.png", empty_string, context) ,
         ),
   body:SafeArea(
     child:
      // Platform.isIOS ?
      //   UiKitView(
      //     viewType: viewType,
      //     creationParams: creationParams,
      //     creationParamsCodec: const StandardMessageCodec(),
      //   )
          // :Text("No product Founds")
      android_dashboard()
    )
    );
  }

  _IosLeadingWidget(url) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              if(Navigator.of(context).canPop()){
                Navigator.of(context).pop();
              }
              SystemNavigator.pop();
            },
            child: Icon(Icons.arrow_back_ios_outlined,
                         size: _screenUtils!.getWidthPercent(3),
                         color: Colors.white,),
          ),
        ),
        Expanded(
            child:  url == null ?
            Image.asset("assets/logo1.png",fit: BoxFit.fitWidth, width: _screenUtils!.getWidthPercent(8),height:_screenUtils!.getWidthPercent(8),):
            Image.network(url,width: 15,height: 15,)
         )
      ],
    );
  }

  List<Widget> _sidebarWidget() {
    return(
      [
      //  DrawerHeader(child: Text("Header")),
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Dashboard(key: Key("Dashboard"))));
            },
            child:
            ListTile(
               title: Text("Home"),
               trailing: Icon(Icons.home,size: 24,color: color1,),
        )
        ),
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_)=> CustomerOrderedList()
            ));
          },
          child: ListTile(
            title: Text("Placed Order"),
            trailing:
            SvgPicture.asset("assets/placed_order.svg", height: 20.0,
              width: 20.0,
              allowDrawingOutsideViewBox: true,),
          ),
        ),
        GestureDetector(
          onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
           builder: (_)=> ReceivedOrderView()
    ));
    },
          child: ListTile(
            title: Text("Required Order"),
            trailing: SvgPicture.asset("assets/required_order.svg", height: 20.0,
              width: 20.0,
              allowDrawingOutsideViewBox: true,),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=> SyncWidget(key: Key("syncWidget"))
            ));
          },
          child: ListTile(
            title: Text("Sync Manually"),
            trailing: SvgPicture.asset("assets/required_order.svg", height: 20.0,
              width: 20.0,
              allowDrawingOutsideViewBox: true,),
          ),
        ),
        GestureDetector(
          onTap: (){
            clear_session();
          },
          child: ListTile(
            title: Text("Customer Logout"),
            trailing: Icon(Icons.power_settings_new_outlined,size: 24,color: color1,),
          ),
         ),

      ]
    );
      // return Column(
      //   children: [
      //     Text("")
      //   ],
      // )
  }

  void clear_session() async{
    mdatabase = mDatabase();
    Map<String,dynamic> row = Map();
    row['out_dt'] = DateFormat.yMd().format(DateTime.now()) + " " + DateFormat.jms().format(DateTime.now());
    row['is_active'] = "0";
    row['updated_at'] = DateFormat.yMd().format(DateTime.now()) + " " + DateFormat.jms().format(DateTime.now());
    row['updated_by'] = await SessionStorage.getEmployeeId() ;
    await mdatabase.customer_logout(row);
    await SessionStorage.logout();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>CustomerEntryWidget(key:Key("customerEntry"))), (route) => false);
    //SystemNavigator.pop();

  }

   Future<void> _getProductImages()  async{
    try {
      mdatabase = mDatabase();

      lists = await mdatabase.getProductImages();

      _controller = CollectionViewController(
          callBackClickedProduct: callbackProductClicked);

     String json_string = json.encode(lists);
      _controller.receiveFromFlutter(json_string);
    }catch(ex){

    }

    // setState(() {
    //   lists = lists;
    // });

     return;
  }


  void callbackProductClicked(Cat_product_images cat_product_images){
    insert_customer_activity(cat_product_images);

  }


    void navigate_to_filter_widget() async {
     checkFiltersExists().then((value) {
       Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FilterViewWidget(value!))).
       then((value) {
         filterProduct(value!);
       }
       );
     });

  }

  void filterProduct(List<FilterModal> value) async {
    try {
      mdatabase = mDatabase();
      lists = await mdatabase.getFilteredProductImages(value);
      // mdatabase = mDatabase();
      setState(() {
        lists = lists;
        filterList = value;
      });
      try {
        String filterd_string = json.encode(filterList);
        await SessionStorage.saveFilter(filterd_string);
      } on FormatException catch (ex) {

      }
    //  lists  = await mdatabase.getProductImages();
      _controller = CollectionViewController(
          callBackClickedProduct: callbackProductClicked);
      //_controller.receiveFromFlutter(json.encode(lists));
    }catch(ex){
      print(ex);
    }
  }

  void insert_customer_activity(Cat_product_images cat_product_images) async {
    Map<String,dynamic> row = Map<String,dynamic> ();
    int clientId=0;
    int maxrecords = await mdatabase.getRecords(DbHelper.tbl_customer_activity);
    Client_master? client_master  = await mdatabase.getClientMaster();
    List<Map<String,dynamic>>? locations  =   await mdatabase.getLocationMaster();
   int site_id =   locations![0]['site_id'];
   //String location_nm =  locations![0]['location_nm'];
    clientId  = client_master!.id!;


    row['id'] = maxrecords+1;
    row['client_id'] = clientId;
    row['pos_id'] = 1;
    row['activity_criteria'] = "Product";
    row['activity'] = "View";
    row['value1'] = cat_product_images.productId;
    row['value2'] = "";
    row['remark'] = "Viewed";
    row['is_active'] = "0";
    row['created_at'] = DateFormat.yMd().format(DateTime.now());
    row['created_by'] = site_id;

    await mdatabase.insertCustomerActivity(row);

    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProductViewWidget(cat_product_images.productId)));
  }

  android_dashboard() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: crossAxisCount,
           crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: getAspectRatio(),


        ),
        itemCount: lists.length,
        itemBuilder: (BuildContext ctx, index) => _widgetImageView(lists[index])
        );
  }

  _widgetImageView(Map<String, dynamic> list) {
    return GestureDetector(
      onTap: (){
        insert_customer_activity(Cat_product_images.fromJson(list));
      },
      child: Container(
        width: _screenUtils!.getWidthPercent(100)/crossAxisCount,
        child: FutureBuilder<String>(
          future: _getFilepath(list['image_name'], list['image_path']),
            builder:(context,data){
              if(data.hasData){
                return Center(child: Image.file(File(data.data!),fit: BoxFit.contain,));
              }
              else
              return Center(child: Image.asset("assets/loading.png"));
            }
        ),
      ),
    );

  }

   Future<String> _getFilepath(String list, String list2)  async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    String image_path = path+list2+"/"+list;
    return image_path;

  }

  Future<List<FilterModal>?> checkFiltersExists()  async{
    var result;
    List<FilterModal> filters;
    List<Map<String,dynamic>>? Mmaplist;
    try {
      if ((result = await SessionStorage.getSavedFilter()) != null) {
        List<dynamic> list = json.decode(result);
        filters = list.map((e) {
                                List<dynamic>? list = e['_filters'] ;
                                Mmaplist = list!.map((e) {
                                  Map<String,dynamic> Mmap = Map();
                                  Mmap['name'] = e['name'];
                                  Mmap['filter_id'] = e['filter_id'];
                                  Mmap['isSelected'] = e['isSelected'];
                                  return Mmap;
                                }).toList();
                            return    FilterModal(e['filterId'], e['_filter_name'],Mmaplist);
                }
            )
            .toList();
      }
      else {
        filters = [];
      }
      return filters;
    }catch(ex){
      print(ex);
      return null;
    }
  }

  getAspectRatio() {
    if(crossAxisCount == 1){
      return 1.0;
    }
    else{
      return crossAxisCount/4;
    }
  }
}

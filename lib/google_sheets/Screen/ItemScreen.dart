import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/Config/config.dart';
import 'package:eshop5nofirebase/Counters/cartitemcounter.dart';
import 'package:eshop5nofirebase/Models/item.dart';
import 'package:eshop5nofirebase/Store/cart.dart';
import 'package:eshop5nofirebase/Store/product_page.dart';
import 'package:eshop5nofirebase/Widgets/loadingWidget.dart';
import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:eshop5nofirebase/Widgets/searchBox.dart';
import 'package:eshop5nofirebase/google_sheets/Model_google/item_google_model.dart';
// import 'package:eshop5nofirebase/Admin/adminOrderCard.dart';
// import 'package:e_shop/Store/cart.dart';
// import 'package:e_shop/Store/product_page.dart';
// import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:e_shop/Config/config.dart';
// import '../Widgets/loadingWidget.dart';
// import '../Widgets/myDrawer.dart';
// import '../Widgets/searchBox.dart';
// import '../Models/item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eshop5nofirebase/Store/Search.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:universal_platform/universal_platform.dart';
import 'ditail_page.dart';
import 'ditail_web_page.dart';

// double width;

class ItemHome extends StatefulWidget {
  @override
  _ItemHomeState createState() => _ItemHomeState();
}

class _ItemHomeState extends State<ItemHome> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green,Colors.cyanAccent],
                    begin: const FractionalOffset(0.0, 0.0),
                    end:  const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
              ),
            ),
            title: Text(
              '商品一覧',
              style: TextStyle(
                  fontSize: 50, color: Colors.white, fontFamily: 'Signatra'),
            ),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.sell_outlined,
                      color: Colors.pink,
                      size: 25,
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.push(context, route);
                    },
                  ),
                  Positioned(
                      child: Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 20,
                            color: Colors.green,
                          ),
                          Positioned(
                            top: 3,
                            bottom: 4,
                            left: 4,
                            child: Consumer<CartItemCounter>(
                                builder: (context, counter, _) {
                                  return Text(
                                    (EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!.length -1).toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  );
                                }),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ],
          ),
          drawer: MyDrawer(),
          body:CustomScrollView(
            slivers: [
              SliverPersistentHeader(pinned:true,delegate: SearchBoxDelegate(),),
              _itemStream()
            ],
          )

      ),
    );
  }
}

Widget _itemStream(){
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('item_from_google').orderBy('publishedDate',descending: true).snapshots(),
      builder: (context, dataSnapshot) {
        return !dataSnapshot.hasData
            ? SliverToBoxAdapter(
          child: Center(
            child: circularProgress(),
          ),
        )
            : SliverList(
          delegate: SliverChildBuilderDelegate(
                  (context,index){
                Map<String, dynamic> data = dataSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                googleItemModel? model = googleItemModel.fromJson(data);

                return sourceInfo(model, context);
              },
              childCount: dataSnapshot.hasData ? dataSnapshot.data!.docs.length : 0
          ),
        );
      });
}





Widget sourceInfo(googleItemModel model, BuildContext context, {
  Color? background, removeCartFunction}) {
  bool isWeb = UniversalPlatform.isWeb;
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
          builder: (c) => isWeb ? DitailWebPage(googleitemModel: model):DitailPage(googleitemModel: model));
      Navigator.push(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6),
      child: Container(
        height: 210,
        width: MediaQuery.of(context).size.width,
        color: Colors.white10,
        child: Row(
          children: [
            // Image.network(
            //   model.thumbnailUrl!,
            //   width: 140,
            //   height: 140,
            // ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                              '商品名：${model.name!}',
                              style: TextStyle(color: Colors.black, fontSize: 12),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                              model.theme == null ?'null': 'テーマ：${model.theme!}',
                              style: TextStyle(color: Colors.black54, fontSize: 12),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Row(
                          children: [
                            Text(
                              '価格 : ¥${model.price}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Text(
                              '作成日：',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              // (model.publishedDate).toString(),
                              DateFormat('yyyy年M月d日').format(model.publishedDate!.toDate()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Text(
                              'サイズ：',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${model.size!}',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                            Text(
                              ' [mm]',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.pink),
                        alignment: Alignment.topLeft,
                        width: 100,
                        height: 30,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '賞味期限:',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                model.itemlimit!,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: removeCartFunction == null
                            ? IconButton(
                          icon:Icon(Icons.notification_add_outlined,color: Colors.pinkAccent,),
                          onPressed: () { checkItemInCart(model.name!, context); },
                        )
                            : IconButton(
                          icon:Icon(Icons.delete,color: Colors.pinkAccent,),
                          onPressed: () {
                            removeCartFunction();
                            Route route = MaterialPageRoute(builder: (c) => ItemHome());
                            Navigator.pushReplacement(context, route);
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 5,
                    color: Colors.pink,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String? imgPath}) {
  return Container(
    height: 150,
    width: 300,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0,5),blurRadius: 10,color: Colors.grey
          )
        ]
    ),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imgPath!,
          height: 150,
          width: 200,
          fit: BoxFit.fill,
        )
    ),

  );
}

void checkItemInCart(String shortInfoAsID, BuildContext context) {
  EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!.contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: 'Item is already in Cart')
      : addItemToCart(shortInfoAsID,context);
}

addItemToCart(String shortInfoAsId, BuildContext context){
  List<String> tempCartList = EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!;
  tempCartList.add(shortInfoAsId);
  EcommerceApp5.firestore!.collection(EcommerceApp5.collectionUser)
      .doc(EcommerceApp5.sharedPreferences!.getString(EcommerceApp5.userUID))
      .update({EcommerceApp5.userCartList:tempCartList
  }).then((v){
    Fluttertoast.showToast(msg: 'Item Added to Cart Successfully');
    EcommerceApp5.sharedPreferences?.setStringList(EcommerceApp5.userCartList,tempCartList);
    Provider.of<CartItemCounter>(context,listen: false).displayResult();
  });
}


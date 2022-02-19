// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eshop5nofirebase/Config/config.dart';
// import 'package:eshop5nofirebase/Counters/cartitemcounter.dart';
// import 'package:eshop5nofirebase/Models/item.dart';
// import 'package:eshop5nofirebase/Store/product_page.dart';
// import 'package:eshop5nofirebase/Widgets/loadingWidget.dart';
// import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
// import 'package:eshop5nofirebase/Widgets/searchBox.dart';
// // import 'package:eshop5nofirebase/Admin/adminOrderCard.dart';
// // import 'package:e_shop/Store/cart.dart';
// // import 'package:e_shop/Store/product_page.dart';
// // import 'package:e_shop/Counters/cartitemcounter.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:provider/provider.dart';
// // import 'package:e_shop/Config/config.dart';
// // import '../Widgets/loadingWidget.dart';
// // import '../Widgets/myDrawer.dart';
// // import '../Widgets/searchBox.dart';
// // import '../Models/item.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:eshop5nofirebase/Store/Search.dart';
//
// import '../google_sheets/Model_google/item_google_model.dart';
// import 'cart.dart';
// // double width;
//
// class StoreHome extends StatefulWidget {
//   @override
//   _StoreHomeState createState() => _StoreHomeState();
// }
//
// class _StoreHomeState extends State<StoreHome> {
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//               colors: [Colors.pink, Colors.lightGreenAccent],
//               begin: const FractionalOffset(0.0, 0.0),
//               end: const FractionalOffset(1.0, 0.0),
//               stops: [0.0, 1.0],
//               tileMode: TileMode.clamp,
//             )),
//           ),
//           title: Text(
//             'e-Shop',
//             style: TextStyle(
//                 fontSize: 55, color: Colors.white, fontFamily: 'Signatra'),
//           ),
//           centerTitle: true,
//           actions: [
//             Stack(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.shopping_cart,
//                     color: Colors.pink,
//                   ),
//                   onPressed: () {
//                     Route route = MaterialPageRoute(builder: (c) => CartPage());
//                     Navigator.pushReplacement(context, route);
//                   },
//                 ),
//                 Positioned(
//                     child: Stack(
//                   children: [
//                     Icon(
//                       Icons.brightness_1,
//                       size: 20,
//                       color: Colors.green,
//                     ),
//                     Positioned(
//                       top: 3,
//                       bottom: 4,
//                       left: 4,
//                       child: Consumer<CartItemCounter>(
//                           builder: (context, counter, _) {
//                         return Text(
//                           (EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!.length -1).toString(),
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500),
//                         );
//                       }),
//                     )
//                   ],
//                 ))
//               ],
//             )
//           ],
//         ),
//         drawer: MyDrawer(),
//         body:CustomScrollView(
//           slivers: [
//             SliverPersistentHeader(pinned:true,delegate: SearchBoxDelegate(),),
//             _itemStream()
//           ],
//         )
//
//       ),
//     );
//   }
// }
//
// Widget _itemStream(){
//   return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('items').orderBy('publishedDate',descending: true).snapshots(),
//       builder: (context, dataSnapshot) {
//         return !dataSnapshot.hasData
//             ? SliverToBoxAdapter(
//           child: Center(
//             child: circularProgress(),
//           ),
//         )
//             : SliverList(
//           delegate: SliverChildBuilderDelegate(
//                   (context,index){
//                 Map<String, dynamic> data = dataSnapshot.data!.docs[index].data() as Map<String, dynamic>;
//                 googleItemModel? calendar_model = googleItemModel.fromJson(data);
//
//                 return sourceInfo(calendar_model, context);
//               },
//               childCount: dataSnapshot.hasData ? dataSnapshot.data!.docs.length : 0
//           ),
//         );
//       });
// }
//
//
//
//
//
// Widget sourceInfo(googleItemModel calendar_model, BuildContext context, {
//     Color? background, removeCartFunction}) {
//   return InkWell(
//     onTap: () {
//       Route route = MaterialPageRoute(
//           builder: (c) => ProductPage(
//                 googleitemModel: calendar_model,
//               ));
//       Navigator.pushReplacement(context, route);
//     },
//     splashColor: Colors.pink,
//     child: Padding(
//       padding: EdgeInsets.all(6),
//       child: Container(
//         height: 190,
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           children: [
//             Image.network(
//               calendar_model.thumbnailUrl!,
//               width: 140,
//               height: 140,
//             ),
//             SizedBox(
//               width: 4,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                             child: Text(
//                           calendar_model.name!,
//                           style: TextStyle(color: Colors.black, fontSize: 14),
//                         ))
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                             child: Text(
//                           calendar_model.sosei!,
//                           style: TextStyle(color: Colors.black54, fontSize: 12),
//                         ))
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             shape: BoxShape.rectangle, color: Colors.pink),
//                         alignment: Alignment.topLeft,
//                         width: 40,
//                         height: 43,
//                         child: Container(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 '50%',
//                                 style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.normal),
//                               ),
//                               Text(
//                                 'OFF',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.normal),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: 0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   r'Origional Price : ¥',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                       decoration: TextDecoration.lineThrough),
//                                 ),
//                                 Text(
//                                   (calendar_model.price! + calendar_model.price!).toString(),
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                       decoration: TextDecoration.lineThrough),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 5.0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   r'New Price : ',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 Text(
//                                   '¥',
//                                   style: TextStyle(
//                                       color: Colors.red, fontSize: 16),
//                                 ),
//                                 Text(
//                                   (calendar_model.price!).toString(),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   Flexible(child: Container()),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: removeCartFunction == null
//                     ? IconButton(
//                       icon:Icon(Icons.add_shopping_cart,color: Colors.pinkAccent,),
//                       onPressed: () { checkItemInCart(calendar_model.name!, context); },
//                       )
//                     : IconButton(
//                       icon:Icon(Icons.delete,color: Colors.pinkAccent,),
//                       onPressed: () {
//                         removeCartFunction();
//                         Route route = MaterialPageRoute(builder: (c) => StoreHome());
//                         Navigator.pushReplacement(context, route);
//                         },
//                     )
//                   ),
//                   Divider(
//                     height: 5,
//                     color: Colors.pink,
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// Widget card({Color primaryColor = Colors.redAccent, String? imgPath}) {
//   return Container(
//     height: 150,
//     width: 300,
//     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//     decoration: BoxDecoration(
//       color: primaryColor,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: <BoxShadow>[
//         BoxShadow(
//           offset: Offset(0,5),blurRadius: 10,color: Colors.grey
//         )
//       ]
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//     child: Image.network(
//       imgPath!,
//       height: 150,
//       width: 200,
//       fit: BoxFit.fill,
//     )
//       ),
//
//   );
// }
//
// void checkItemInCart(String shortInfoAsID, BuildContext context) {
//   EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!.contains(shortInfoAsID)
//   ? Fluttertoast.showToast(msg: 'Item is already in Cart')
//   : addItemToCart(shortInfoAsID,context);
// }
//
// addItemToCart(String shortInfoAsId, BuildContext context){
//  List<String> tempCartList = EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!;
//  tempCartList.add(shortInfoAsId);
//  EcommerceApp5.firestore!.collection(EcommerceApp5.collectionUser)
//  .doc(EcommerceApp5.sharedPreferences!.getString(EcommerceApp5.userUID))
//  .update({EcommerceApp5.userCartList:tempCartList
//  }).then((v){
//    Fluttertoast.showToast(msg: 'Item Added to Cart Successfully');
//    EcommerceApp5.sharedPreferences?.setStringList(EcommerceApp5.userCartList,tempCartList);
//    Provider.of<CartItemCounter>(context,listen: false).displayResult();
//  });
// }
//

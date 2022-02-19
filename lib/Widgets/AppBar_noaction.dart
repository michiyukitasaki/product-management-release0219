import 'package:eshop5nofirebase/Config/config.dart';
import 'package:eshop5nofirebase/Counters/cartitemcounter.dart';
import 'package:eshop5nofirebase/Store/cart.dart';
// import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppBarNoAction extends StatelessWidget with PreferredSizeWidget
{
  final String? title;
  final PreferredSizeWidget? bottom;
  AppBarNoAction({this.bottom,this.title});


  @override
  Widget build(BuildContext context) {

    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white
      ),
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
      centerTitle: true,
      title: Text(
        title!,
        style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontFamily: 'Signatra'
        ),
      ),
      bottom: bottom,
        // actions: [
        //   Stack(children: [
        //     IconButton(
        //       icon: Icon(Icons.favorite_border_rounded,color: Colors.pink,),
        //       onPressed: (){
        //         Route route = MaterialPageRoute(builder: (c) => CartPage());
        //         Navigator.pushReplacement(context, route);
        //       },
        //     ),
        //     Positioned(child: Stack(
        //       children: [
        //         Icon(
        //           Icons.brightness_1,
        //           size: 20,
        //           color: Colors.green,
        //         ),
        //         Positioned(
        //           top: 3,
        //           bottom: 4,
        //           left: 4,
        //           child: Consumer<CartItemCounter>(
        //               builder:(context,counter, _){
        //                 return Text(
        //                   (EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!.length -1).toString(),
        //                   style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 12,
        //                       fontWeight: FontWeight.w500
        //                   ),
        //                 );
        //               }
        //           ),
        //         )
        //       ],
        //     ))
        //   ],)
        // ]
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}

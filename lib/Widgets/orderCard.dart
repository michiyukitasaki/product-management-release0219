import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/Models/item.dart';
// import 'package:e_shop/Orders/OrderDetailsPage.dart';
// import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import '../google_sheets/Model_google/item_google_model.dart';


class OrderCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  InkWell(
    );
  }
}



Widget sourceInfoChouse(googleItemModel model, BuildContext context,
    {Color? background, required Function() removeCartFunction})
{
  var width =  MediaQuery.of(context).size.width;

  return  Container(child: Text('OK'),);
}

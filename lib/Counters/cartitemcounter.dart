import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:eshop5nofirebase/Config/config.dart';
import 'package:flutter/material.dart';

class CartItemCounter extends ChangeNotifier{
  int? _counter = EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!.length -1;
  int? get count => _counter;

  Future<void> displayResult()async{
    int? _counter = EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!.length -1;
  await Future.delayed(const Duration(milliseconds: 100),(){
    notifyListeners();
  });
  }

}
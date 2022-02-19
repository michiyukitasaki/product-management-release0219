
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/Authentication/authenticScreen_web.dart';
import 'package:eshop5nofirebase/Calendar/provider/event_provider.dart';
import 'package:eshop5nofirebase/Counters/ItemQuantity.dart';
import 'package:eshop5nofirebase/Counters/cartitemcounter.dart';
import 'package:eshop5nofirebase/Counters/changeAddresss.dart';
import 'package:eshop5nofirebase/Counters/totalMoney.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Config/config.dart';
import 'Authentication/authenticScreen.dart';
import 'dart:io';
import 'package:universal_platform/universal_platform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // String os = Platform.operatingSystem;
  bool isIos = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  // bool isIOS = Platform.isIOS;

  // const firebaseConfig = {
  //   apiKey: "AIzaSyCR8RuH6W49oHHvuzryZ4snEsOfDNMK1cI",
  //   authDomain: "daiichipan0209.firebaseapp.com",
  //   projectId: "daiichipan0209",
  //   storageBucket: "daiichipan0209.appspot.com",
  //   messagingSenderId: "259648805362",
  //   appId: "1:259648805362:web:3eb3db2fc1677905b3b36b"
  // }
  // if(isIOS){
  // await Firebase.initializeApp(
  //   // options: FirebaseOptions(
  //   //     apiKey: "AIzaSyCR8RuH6W49oHHvuzryZ4snEsOfDNMK1cI",
  //   //     authDomain: "daiichipan0209.firebaseapp.com",
  //   //     projectId: "daiichipan0209",
  //   //     storageBucket: "daiichipan0209.appspot.com",
  //   //     messagingSenderId: "259648805362",
  //   //     appId: "1:259648805362:web:3eb3db2fc1677905b3b36b"
  //   // ),
  // );
  // }
  // if(!isIOS){
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //           apiKey: "AIzaSyCR8RuH6W49oHHvuzryZ4snEsOfDNMK1cI",
  //           authDomain: "daiichipan0209.firebaseapp.com",
  //           projectId: "daiichipan0209",
  //           storageBucket: "daiichipan0209.appspot.com",
  //           messagingSenderId: "259648805362",
  //           appId: "1:259648805362:web:3eb3db2fc1677905b3b36b"
  //       ));
  // }

  if (isWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCR8RuH6W49oHHvuzryZ4snEsOfDNMK1cI",
            authDomain: "daiichipan0209.firebaseapp.com",
            projectId: "daiichipan0209",
            storageBucket: "daiichipan0209.appspot.com",
            messagingSenderId: "259648805362",
            appId: "1:259648805362:web:3eb3db2fc1677905b3b36b"
        ));
  } else{
    await Firebase.initializeApp();
  }



  //
  // Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyCR8RuH6W49oHHvuzryZ4snEsOfDNMK1cI",
  //         authDomain: "daiichipan0209.firebaseapp.com",
  //         projectId: "daiichipan0209",
  //         storageBucket: "daiichipan0209.appspot.com",
  //         messagingSenderId: "259648805362",
  //         appId: "1:259648805362:web:3eb3db2fc1677905b3b36b"
  //     ));

  // await PanSheetsApi.init();
  EcommerceApp5.auth = FirebaseAuth.instance;
  EcommerceApp5.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp5.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}




class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
Widget build(BuildContext context) {
    bool isWeb = UniversalPlatform.isWeb;
  // return AuthenticScreen();
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => EventProvider())
      ],
      child:MaterialApp(home: isWeb ? AuthenticScreenWeb():AuthenticScreen())
  );
}

  //0202デフォ
  // @override
  // void initState() {
  //   super.initState();
  // }
  //
  // @override
  // Widgets build(BuildContext context) {
  //   // return AuthenticScreen();
  //   return MaterialApp(home: AuthenticScreen());
  // }
}

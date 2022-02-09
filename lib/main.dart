import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'authenticScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  // return AuthenticScreen();
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child:MaterialApp(home: AuthenticScreen())
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

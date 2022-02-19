import 'package:eshop5nofirebase/Authentication/login_web.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'login.dart';
import 'register.dart';
// import 'package:e_shop/Config/config.dart';


class AuthenticScreenWeb extends StatefulWidget {
  @override
  _AuthenticScreenWebState createState() => _AuthenticScreenWebState();
}

class _AuthenticScreenWebState extends State<AuthenticScreenWeb> {

  bool isWeb = UniversalPlatform.isWeb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          '商品情報管理',
          style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontFamily: 'Signatra'
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green,Colors.cyanAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end:  const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: LoginWeb(),
          ),
      ),
    );
  }
}

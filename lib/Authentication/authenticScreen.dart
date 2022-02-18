import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'Authentication/login.dart';
import 'Authentication/register.dart';
// import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
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
              '商品情報管理',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: 'Signatra'
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock,color: Colors.white,),
                  text:'ログイン',),
                Tab(
                  icon: Icon(Icons.perm_contact_calendar,color: Colors.white,),
                  text:'ユーザー登録',),
              ],
              indicatorColor: Colors.white38,
              indicatorWeight: 5,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green,Colors.cyanAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: TabBarView(
              children: [
                Login(),
                Register(),
              ],
            ),
          ),
        ));
  }
}

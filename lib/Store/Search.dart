

import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:eshop5nofirebase/google_sheets/Model_google/item_google_model.dart';
import 'package:eshop5nofirebase/google_sheets/Screen/ItemScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eshop5nofirebase/Widgets/customAppBar.dart';





class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}



class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot>? docList;

  @override
  Widget build(BuildContext context) {
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
            '商品検索',
            style: TextStyle(
                fontSize: 50, color: Colors.white, fontFamily: 'Signatra'),
          ),
          centerTitle: true,
          bottom: PreferredSize(preferredSize: Size(80,80),
        child: searchWidget()),),
      //   appBar: MyAppBar(
      //     bottom: PreferredSize(child: searchWidget(),preferredSize: Size(56,56),
      //     ),
      // ),
        drawer: MyDrawer(),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context,snap){
            return snap.hasData
                ? ListView.builder(
              itemBuilder:(context, index) {
                Map<String, dynamic> data = snap.data!.docs[index].data() as Map<String, dynamic>;
                googleItemModel? model = googleItemModel.fromJson(data);

              return sourceInfo(model, context);
              },

              itemCount: snap.data!.docs.length,
            )
                :Text('一致する製品はありません');
          },
        ),
      ),
    );
  }

  Widget searchWidget(){
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
      gradient: LinearGradient(
    colors: [Colors.cyanAccent, Colors.greenAccent],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  )),
      child: Container(
        width: MediaQuery.of(context).size.width -40,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.search,color: Colors.greenAccent,),
            ),
            Flexible(child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: TextField(
                onChanged: (value){
                  startSeaching(value);
                },
                decoration: InputDecoration.collapsed(hintText: '検索・・・')
              ),
            ))
          ],
        ),
      ),
    );
  }

 Future startSeaching(String query) async{
    docList = FirebaseFirestore.instance
        .collection('item_from_google')
        .where('name',isGreaterThanOrEqualTo: query)
        .get();
  }
}


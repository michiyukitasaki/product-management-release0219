import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/Config/config.dart';
import 'package:eshop5nofirebase/Address/address.dart';
import 'package:eshop5nofirebase/Widgets/customAppBar.dart';
import 'package:eshop5nofirebase/Widgets/loadingWidget.dart';
import 'package:eshop5nofirebase/Models/item.dart';
import 'package:eshop5nofirebase/Counters/cartitemcounter.dart';
import 'package:eshop5nofirebase/Counters/totalMoney.dart';
import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eshop5nofirebase/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double? totalAmount;

  @override

  void initState(){
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context,listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: MyAppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(EcommerceApp5.sharedPreferences?.getStringList(EcommerceApp5.userCartList)?.length ==1){
              Fluttertoast.showToast(msg: 'Your Cart is empty');
            } else {
              Route route = MaterialPageRoute(builder: (c) => Address(totalAmount:totalAmount));
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text('Check Out',),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.navigate_next),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount,CartItemCounter>(builder: (context, amountProvider,cartProvider,c){
              return Padding(padding: EdgeInsets.all(8),
              child: cartProvider.count == 0
                ? Container()
                : Text('Total Price : ¥ ${amountProvider.totalAmount.toString()}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
              ),
              );
            }),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: EcommerceApp5.firestore?.collection('items')
              .where('shortInfo',whereIn: EcommerceApp5.sharedPreferences?.getStringList(EcommerceApp5.userCartList)).snapshots(),
              builder: (context,snapshot){
                return !snapshot.hasData
                    ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    : snapshot.data!.docs.length == 0
                    ? beginBuildingCart()
                    : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context,index){
                          Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          ItemModel? model = ItemModel.fromJson(data);
                          if (index == 0){
                            totalAmount = 0;
                            totalAmount = (model.price! + totalAmount!);
                          } else{
                            totalAmount = (model.price! + totalAmount!);
                          }
                          if(snapshot.data!.docs.length - 1 == index){
                            WidgetsBinding.instance?.addPersistentFrameCallback((t) {
                              Provider.of<TotalAmount>(context,listen: false).display(totalAmount!);
                            });
                          }
                           return sourceInfo(model, context,removeCartFunction: ()=>removeItemFromUserCart(model.shortInfo));
                        },
                        childCount: snapshot.hasData ? snapshot.data!.docs.length : 0
                    ),
                    );
              })

        ],
      ),
    );
  }

  beginBuildingCart(){
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon,color: Colors.white,),
              Text('Cart is empty'),
              Text('Start adding items to your Cart')
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String? shortInfoAsId){

    List<String> tempCartList = EcommerceApp5.sharedPreferences!.getStringList(EcommerceApp5.userCartList)!;
    tempCartList.remove(shortInfoAsId);
    EcommerceApp5.firestore!.collection(EcommerceApp5.collectionUser)
        .doc(EcommerceApp5.sharedPreferences!.getString(EcommerceApp5.userUID))
        .update({EcommerceApp5.userCartList:tempCartList
    }).then((v){
      Fluttertoast.showToast(msg: 'Item Removed Successfully');
      EcommerceApp5.sharedPreferences?.setStringList(EcommerceApp5.userCartList,tempCartList);
      Provider.of<CartItemCounter>(context,listen: false).displayResult();

      totalAmount = 0;
    });
  }
}

// import 'package:e_shop/Widgets/customAppBar.dart';
// import 'package:e_shop/Widgets/myDrawer.dart';
// import 'package:e_shop/Models/item.dart';
import 'package:eshop5nofirebase/Models/item.dart';
import 'package:eshop5nofirebase/Widgets/customAppBar.dart';
import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:eshop5nofirebase/google_sheets/Model_google/item_google_model.dart';
import 'package:flutter/material.dart';
import 'package:eshop5nofirebase/Store/storehome.dart';

import '../google_sheets/Screen/ItemScreen.dart';


class ProductPage extends StatefulWidget {
  final googleItemModel googleitemModel;

  ProductPage({required this.googleitemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(bottom: null,),
        drawer: MyDrawer(),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [Center(
                    child: Image.network(widget.googleitemModel.thumbnailUrl!),
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: SizedBox(
                      height: 1,
                      width: double.infinity,
                    ),
                  ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.googleitemModel.name!,
                        style: boldTextStyle,
                        ),
                        SizedBox(height: 10,),
                        Text(widget.googleitemModel.sosei!,
                          style: boldTextStyle,
                        ),
                        SizedBox(height: 10,),
                        Text("??" + widget.googleitemModel.price.toString(),
                          style: boldTextStyle,
                        ),
                        SizedBox(height: 10,)
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: InkWell(
                    onTap: () => checkItemInCart(widget.googleitemModel.name!, context),
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink,Colors.lightGreenAccent],
                              begin: const FractionalOffset(0.0, 0.0),
                              end:  const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            )
                        ),
                      width: MediaQuery.of(context).size.width -40,
                      height: 50,
                      child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                )
              ],
            ),
          )
        ],),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

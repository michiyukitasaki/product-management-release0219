import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:eshop5nofirebase/google_sheets/Screen/pan_sheets_api.dart';
import 'package:eshop5nofirebase/google_sheets/Screen/product.dart';
// import 'package:eshop5nofirebase/google_sheets/user.dart';
// import 'package:eshop5nofirebase/google_sheets/user_form_widget.dart';
import 'package:flutter/material.dart';

import 'item_form_widget.dart';
import 'navigate_users_widget.dart';
// import 'create_sheets_page.dart';
// import 'navigate_users_widget.dart';

class SheetToFirestorePage extends StatefulWidget {
  const SheetToFirestorePage({Key? key}) : super(key: key);



  @override
  State<SheetToFirestorePage> createState() => _SheetToFirestorePageState();
}

class _SheetToFirestorePageState extends State<SheetToFirestorePage> {
  List<Product> products = [];
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  Future getProducts({index})async{
    final products = await PanSheetsApi.getAll();
    print('OK');
    setState(() {
      this.products = products;
    });

  }


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
        title: Text('データベースへ追加'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            ItemFormWidget(
              product:products.isEmpty ? null : products[index],
              // product: products[index],
              onSavedUser: (products) async {
                await PanSheetsApi.update(products.id!, products.toJson());
              },
            ),
            const SizedBox(height: 16,),
            buildUserControls(),
          ],
        ),
      ),
    );

  }


  Widget buildUserControls() => Column(
    children: [
      // ButtonWidget(
      //     text: 'Delete',
      //     onClicked: deleteUser),
      NavigateUsersWidget(
        text: '${index + 1}/${products.length} Products',
        onClickedNext:(){
          final nextIndex = index >= products.length -1 ? 0 :index + 1;
          setState(() => index = nextIndex);
        },
        onClickedPrevious:(){
          final previousIndex = index <=0 ? products.length -1 :index - 1;
          setState(() => index = previousIndex);
        },
      ),
    ],
  );
}






class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key,required this.text,required this.onClicked}):super(key:key);
  final String text;
  final VoidCallback onClicked;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary:Colors.greenAccent,
          minimumSize: Size.fromHeight(50),
          shape: StadiumBorder(),),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white
            ),
          ),
        ));
  }
}

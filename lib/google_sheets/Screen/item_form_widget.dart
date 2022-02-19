import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/google_sheets/Screen/product.dart';
import 'package:eshop5nofirebase/google_sheets/Screen/sheet_to_firestore.dart';
// import 'package:eshop5nofirebase/google_sheets/user.dart';
import 'package:flutter/material.dart';



class ItemFormWidget extends StatefulWidget {

  final Product? product;
  final ValueChanged<Product> onSavedUser;
  const ItemFormWidget({
    Key? key,
    this.product,
    required this.onSavedUser}) : super(key: key);

  @override
  _ItemFormWidgetState createState() => _ItemFormWidgetState();
}

class _ItemFormWidgetState extends State<ItemFormWidget> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController controllerName;
  late TextEditingController controllerEmail;
  late bool isBeginner;
  bool uploading = false;

  late TextEditingController controllerTheme;
  late TextEditingController controllerPrice;
  late TextEditingController controllerItemlimit;
  late TextEditingController controllerSize;
  late TextEditingController controllerWeight;
  late TextEditingController controllerSosei;
  late TextEditingController controlleritemfuture;
  late TextEditingController controllerthumbnailUrl;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUser();
  }

  void initUser(){
    final name = widget.product == null ? '':widget.product!.name;
    final email = widget.product == null ? '':widget.product!.email;
    final isBeginner = widget.product == null ? true:widget.product!.isBeginner;

    final theme = widget.product == null ? '' : widget.product!.theme;
    final price = widget.product ==null ? '' :widget.product!.price;
    final itemlimit = widget.product == null ? '':widget.product!.itemlimit;
    final size = widget.product ==null ? '' : widget.product!.size;
    final weight = widget.product == null ? '' : widget.product!.weight;
    final sosei = widget.product == null ? '' : widget.product!.sosei;
    final itemfuture = widget.product == null ? '' : widget.product!.itemfuture;
    final thumbnailUrl = widget.product == null ? '' : widget.product!.thumbnailUrl;

    setState(() {
      // name1 = name;
      controllerName = TextEditingController(text: name);
      controllerEmail = TextEditingController(text: email);
      this.isBeginner = isBeginner;

      controllerTheme = TextEditingController(text: theme);
      controllerPrice = TextEditingController(text: price.toString());
      controllerItemlimit = TextEditingController(text: itemlimit);
      controllerSize = TextEditingController(text: size);
      controllerWeight = TextEditingController(text: weight);
      controllerSosei = TextEditingController(text: sosei);
      controlleritemfuture = TextEditingController(text: itemfuture);
      controllerthumbnailUrl = TextEditingController(text: thumbnailUrl);
    });

  }

  @override
  void didUpdateWidget(covariant ItemFormWidget oldWidget){
    super.didUpdateWidget(oldWidget);
    initUser();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10,),
        buildName(),
        const SizedBox(height: 10,),
        buildEmail(),
        const SizedBox(height: 10,),
        // buildFlutterBeginner(),
        // const SizedBox(height: 15,),
        buildTheme(),
        const SizedBox(height: 10,),
        buildPrice(),
        const SizedBox(height: 10,),
        buildSize(),
        const SizedBox(height: 10,),
        // buildSosei(),
        const SizedBox(height: 10,),
        buildItemFuture(),
        const SizedBox(height: 10,),
        buildItemLimit(),
        const SizedBox(height: 10,),
        buildWeight(),
        const SizedBox(height: 10,),
        buildThumbnailUrl(),
        const SizedBox(height: 30,),
        buildfirestoreSubmit(),
      ],
    ),
  );

  // Widget buildSubmit() => ButtonWidget(
  //     text: '保存',
  //     onClicked: (){
  //       final form = formKey.currentState!;
  //       final isValid = form.validate();
  //
  //       if(isValid){
  //         final id = widget.product == null ?null : widget.product!.id;
  //         final product = Product(
  //             id: id,
  //             name: controllerName.text,
  //             email: controllerEmail.text,
  //             isBeginner: isBeginner,
  //             itemlimit: '',
  //             itemfuture: '',
  //             weight: '',
  //             theme: '',
  //             price: '',
  //             size: '',
  //             sosei: '',
  //             thumbnailUrl: ''
  //         );
  //         widget.onSavedUser(product);
  //       }
  //
  //     }
  // );

  Widget buildfirestoreSubmit() => ButtonWidget(
      text: 'FireStoreへ保存',
      onClicked: (){
        final form = formKey.currentState!;
        final isValid = form.validate();

        if(isValid){
          final id = widget.product == null ?null : widget.product!.id;
          final product = Product(
              id: id,
              name: controllerName.text,
              email: controllerEmail.text,
              isBeginner: isBeginner,
              theme: controllerTheme.text,
              price: controllerPrice.text,
              itemlimit: controllerItemlimit.text,
              size:controllerSize.text,
              weight :controllerWeight.text,
              sosei: controllerSosei.text,
              itemfuture:controlleritemfuture.text,
            thumbnailUrl: controllerthumbnailUrl.text
          );
          saveUserInfo(product);
        }

      }
  );



  Widget buildName() => TextFormField(
    controller: controllerName,
    decoration: InputDecoration(
      labelText: '商品名',
      border: OutlineInputBorder(),
    ),
  );
  Widget buildEmail() => TextFormField(
    controller: controllerEmail,
    decoration: InputDecoration(
      labelText: 'Email',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildTheme() => TextFormField(
    controller: controllerTheme,
    decoration: InputDecoration(
      labelText: 'テーマ',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildPrice() => TextFormField(
    controller: controllerPrice,
    decoration: InputDecoration(
      labelText: '価格',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildSize() => TextFormField(
    controller: controllerSize,
    decoration: InputDecoration(
      labelText: 'サイズ',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildWeight() => TextFormField(
    controller: controllerWeight,
    decoration: InputDecoration(
      labelText: '重さ[g]',
      border: OutlineInputBorder(),
    ),
  );

  // Widget buildSosei() => TextFormField(
  //   controller: controllerSosei,
  //   decoration: InputDecoration(
  //     labelText: '生地組成',
  //     border: OutlineInputBorder(),
  //   ),
  // );

  Widget buildItemLimit() => TextFormField(
    controller: controllerItemlimit,
    decoration: InputDecoration(
      labelText: '賞味期限',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildItemFuture() => TextFormField(
    controller: controlleritemfuture,
    decoration: InputDecoration(
      labelText: '商品特徴',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildThumbnailUrl() => TextFormField(
    controller: controllerthumbnailUrl,
    decoration: InputDecoration(
      labelText: '商品画像',
      border: OutlineInputBorder(),
    ),
  );


  Widget buildFlutterBeginner() => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    value: isBeginner,
    title: Text('Is Flutter Beginner ?'),
    onChanged: (value) => setState(() => isBeginner = value),
  );



  saveUserInfo(Product product){
    String ProductIdGoogle = DateTime.now().millisecondsSinceEpoch.toString();
    final itemsRef = FirebaseFirestore.instance.collection('item_from_google');
    itemsRef.doc(ProductIdGoogle).set({
      'name':product.name,
      'email':product.email,
      'isBeginner':product.isBeginner,
      'publishedDate':DateTime.now(),

      'theme':product.theme,
      'price':product.price,
      'itemlimit':product.itemlimit,
      'size':product.size,
      'weight':product.weight,
      'sosei':product.sosei,
      'itemfuture':product.itemfuture,
      'thumbnailUrl':product.thumbnailUrl

    });
    setState(() {
      uploading = false;
    });
  }



}

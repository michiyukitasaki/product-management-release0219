import 'package:eshop5nofirebase/Address/address.dart';
import 'package:eshop5nofirebase/Config/config.dart';
import 'package:eshop5nofirebase/Widgets/customAppBar.dart';
import 'package:eshop5nofirebase/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
            label: Text('Done'),
          icon: Icon(Icons.check),
          onPressed: (){
              if(formKey.currentState!.validate()){
                final model = AddressModel(
                    name: cName.text.trim(),
                    phoneNumber: cPhoneNumber.text.trim(),
                    flatNumber: cFlatHomeNumber.text.trim(),
                    city: cCity.text.trim(),
                    state: cState.text.trim(),
                    pincode: cPinCode.text.trim(),
                ).toJson();

                //add to firestore
                EcommerceApp5.firestore!.collection(EcommerceApp5.collectionUser)
                .doc(EcommerceApp5.sharedPreferences!.getString(EcommerceApp5.userUID))
                .collection(EcommerceApp5.subCollectionAddress)
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model)
                    .then((value){
                      final snack = SnackBar(content: Text('New Address added sucsessfuly!'));
                });

              }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment:Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Add New Adress',
                  style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Form(
                key: key,
                  child: Column(
                    children: [
                      MyTextField(hint: 'Name',controller: cName,),
                      MyTextField(hint: 'Phene Number',controller: cPhoneNumber,),
                      MyTextField(hint: 'Flat Number / House Number',controller: cFlatHomeNumber,),
                      MyTextField(hint: 'City',controller: cCity,),
                      MyTextField(hint: 'Pincode',controller: cPinCode,),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {

  final String? hint;
  final TextEditingController? controller;

  MyTextField({Key? key, this.hint,this.controller}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val!.isEmpty ? 'Fill can not be empty':null,
      ),
    );
  }
}

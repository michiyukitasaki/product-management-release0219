import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/DialogBox/errorDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Admin/adminLogin.dart';
import 'package:flutter/material.dart';

import '../Config/config.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import '../Widgets/customTextField.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset("images/logo.jpg"),
              height: 240,
              width: 240,
            ),
            Padding(
                padding: EdgeInsets.all(8),
              child: Text(
                'Login to your Account',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: 'Email',
                    isObsecure:false,
                  ),
                  SizedBox(height: 10,),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: 'Passaword',
                    isObsecure:true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _emailTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                    context: context,
                    builder: (c){
                      return ErrorAlertDialog(message: 'Please write email and password!');
                    });
              },
              // onPressed: (){},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pink)),
              child: Text(
                'Login',
                style: TextStyle(
                    color: Colors.white
                ),),
            ),
            SizedBox(height: 50,),
            Container(
              height: 4,
              width: _screenWidth * 0.8 ,
              color: Colors.pink,
            ),
            SizedBox(height: 10,),
            TextButton.icon(
                onPressed: ()=>
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AdminSignInPage()
                )),
                icon: Icon(Icons.nature_people,color:Colors.pink) ,
                label: Text("I'm Admin",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),))

          ],
        )
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async{
    showDialog(
        context: context,
        builder: (c){
          return LoadingAlertDialog(
            message: "Authenticating, Please wait.....",);
        });
    User? firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim()
    ).then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),);
          });
    });
    if (firebaseUser != null){
      readData(firebaseUser!).then((s){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
 }
 Future readData(User fUser) async{

    FirebaseFirestore.instance.collection('users').doc(fUser.uid).get().then((dataSnapshot)
    async {
      await EcommerceApp5.sharedPreferences?.setString('uid', dataSnapshot.data()![EcommerceApp5.userUID]);
      await EcommerceApp5.sharedPreferences?.setString(EcommerceApp5.userEmail, dataSnapshot.data()![EcommerceApp5.userEmail]);
      await EcommerceApp5.sharedPreferences?.setString(EcommerceApp5.userName, dataSnapshot.data()![EcommerceApp5.userName]);
      await EcommerceApp5.sharedPreferences?.setString(EcommerceApp5.userAvatarUrl, dataSnapshot.data()![EcommerceApp5.userAvatarUrl]);
      List<String> cartList = dataSnapshot.data()![EcommerceApp5.userCartList].cart<String>();
      await EcommerceApp5.sharedPreferences?.setStringList(EcommerceApp5.userCartList, cartList);
      await EcommerceApp5.sharedPreferences?.setString(EcommerceApp5.signInDateTime, dataSnapshot.data()![EcommerceApp5.signInDateTime]);
    });
 }

}

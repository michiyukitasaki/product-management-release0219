import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/Admin/uploadItems.dart';
import 'package:eshop5nofirebase/DialogBox/errorDialog.dart';
import 'package:eshop5nofirebase/Widgets/customTextField.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
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
            '管理者ページ',
            style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontFamily: 'Signatra'
            ),
          ),
          centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{

  final TextEditingController _adminIdTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green,Colors.cyanAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end:  const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
            child:Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Image.asset("images/mainlogo.jpg"),
                height: 240,
                width: 240,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Admin',
                  style: TextStyle(
                      color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _adminIdTextEditingController,
                      data: Icons.person,
                      hintText: 'id',
                      isObsecure:false,
                    ),
                    SizedBox(height: 20,),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      data: Icons.person,
                      hintText: 'Passaword',
                      isObsecure:true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              ElevatedButton(
                onPressed: () {
                  _adminIdTextEditingController.text.isNotEmpty &&
                      _passwordTextEditingController.text.isNotEmpty
                      ? loginAdmin()
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
                          builder: (context) => AdminSignInScreen()
                      )),
                  icon: Icon(Icons.nature_people,color:Colors.pink) ,
                  label: Text("I'm not Admin",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),)),
              SizedBox(height: 50,),
            ],
          )
      ),
    );
  }

  loginAdmin(){
    FirebaseFirestore.instance.collection('admins').get().then((snapshot){
      snapshot.docs.forEach((result) {
        if(result.data()['id'] != _adminIdTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Your id is not correct.')));
        }
        else if(result.data()['password'] != _passwordTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Your password is not correct.')));
        }
        else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Welcom Dir Admin,'+ result.data()['name'])));
          setState(() {
            _adminIdTextEditingController.text = '';
            _passwordTextEditingController.text = "";
            Navigator.pop(context);
            Route route = MaterialPageRoute(builder: (c) => UploadPage());
            Navigator.pushReplacement(context, route);
          });
        }
      });
    });
  }

}
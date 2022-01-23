
// import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/DialogBox/loadingDialog.dart';
import 'package:eshop5nofirebase/Widget/customTextField.dart';
// import 'package:eshop5nofirebase/eshop2_re/Config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Config/config.dart';
import 'DialogBox/errorDialog.dart';
import 'package:eshop5nofirebase/Store/storehome.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = '';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10,),
            InkWell(
              onTap: () => _selectAndPickedImage(),
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!):null,
                child: _imageFile != null
                      ? null
                      :Icon(
                          Icons.add_photo_alternate,
                          size: _screenWidth * 0.15,
                          color: Colors.grey,
                        )
                ,
              ),
            ),
            SizedBox(height: 8,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: 'Name',
                    isObsecure:false,
                  ),
                  SizedBox(height: 10,),
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
                  SizedBox(height: 10,),
                  CustomTextField(
                    controller: _cPasswordTextEditingController,
                    data: Icons.person,
                    hintText: 'Confirm Password',
                    isObsecure:true,
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {uploadAndSaveImage();},
              // onPressed: (){},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pink)),
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white
                ),),
            ),
            SizedBox(height: 30,),
            Container(
              height: 4,
              width: _screenWidth * 0.8 ,
              color: Colors.pink,
            ),
            SizedBox(height: 25,)
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickedImage() async{
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(_image!.path);
    });
  }

  Future<void> uploadAndSaveImage() async{
    if(_imageFile == null){
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: 'Please select an image file.',);
          }
          );
    }
    else{
      _passwordTextEditingController.text == _cPasswordTextEditingController.text

          ? _emailTextEditingController.text.isNotEmpty
          && _passwordTextEditingController.text.isNotEmpty
          && _cPasswordTextEditingController.text.isNotEmpty
          && _nameTextEditingController.text.isNotEmpty

          ? upLoadToStorage()
          // ? print('OK')

          :displayDialog('Please fill up the registration complete form.')

          :displayDialog('Password do not match');
    }
  }

  displayDialog(String msg){
    showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: msg,);
        }
        );
  }

  upLoadToStorage() async {
    showDialog(
        context: context,
        builder: (c){
          return LoadingAlertDialog(message: 'Authenticating, Please wait.....',);
        });
    String imageFiledName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child(imageFiledName);
    UploadTask storageUpLoadTask = storageReference.putFile(_imageFile!);
    String imageurl = await (await storageUpLoadTask).ref.getDownloadURL();
    userImageUrl = imageurl;
    _registerUser();

    // TaskSnapshot taskSnapshot = await storageUpLoadTask;
    // await taskSnapshot.ref.getDownloadURL().then((urlImage){
    //   userImageUrl = urlImage;
  // });
  //   print('OK');

  }
  FirebaseAuth _auth = FirebaseAuth.instance;
 _registerUser()async{
   // print('OK');
    User? firebaseUser;
    await _auth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
    ).then((auth){
      firebaseUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),);
          });
    });

    if(firebaseUser != null){
      saveUserInfoToFireStore(firebaseUser!).then((value){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
 }
  Future saveUserInfoToFireStore(User fUser)async{
    FirebaseFirestore.instance.collection('users').doc(fUser.uid).set({
      'uid':fUser.uid,
      'email':fUser.email,
      'name':_nameTextEditingController.text.trim(),
      'url':userImageUrl,
    });
  await EcommerceApp5.sharedPreferences?.setString('uid', fUser.uid);
    await EcommerceApp5.sharedPreferences?.setString(EcommerceApp5.userEmail, fUser.email!);
    await EcommerceApp5.sharedPreferences?.setString(EcommerceApp5.userName, _nameTextEditingController.text);
    await EcommerceApp5.sharedPreferences?.setString(EcommerceApp5.userAvatarUrl, userImageUrl);
    await EcommerceApp5.sharedPreferences?.setStringList(EcommerceApp5.userCartList, ['garbageValue']);
 }
  
}



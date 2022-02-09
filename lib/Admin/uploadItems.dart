import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop5nofirebase/Admin/adminShiftOrders.dart';
import 'package:eshop5nofirebase/Authentication/authenication.dart';
import 'package:eshop5nofirebase/Authentication/login.dart';
import 'package:eshop5nofirebase/Widgets/loadingWidget.dart';
import 'package:eshop5nofirebase/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File? file;
  TextEditingController _descriptiontextEditingController = TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shortInftextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => AuthenticScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )
        ],
      ),
      body: getAdminHomeScreen(),
    );
  }

  getAdminHomeScreen() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.pink, Colors.lightGreenAccent],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Text(
                  'Add New Items',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => takeImage(context),
                // onPressed: (){},
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Item Image',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text('Capture with camera',
                  style: TextStyle(
                    color: Colors.green,
                  )),
              onPressed: capturePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text('Select From Gallery',
                  style: TextStyle(
                    color: Colors.green,
                  )),
              onPressed: pickPhotoFromGallery,
            ),
            SimpleDialogOption(
              child: Text('Cancel',
                  style: TextStyle(
                    color: Colors.green,
                  )),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    ImagePicker picker = ImagePicker();
    XFile? ximagefile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
    File imagefile = File(ximagefile!.path);
    setState(() {
      file = imagefile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    ImagePicker picker = ImagePicker();
    XFile? ximagefile =
        await picker.pickImage(source: ImageSource.gallery);
    // XFile? imagefile1 = XFile(ximagefile!.path);
    File imagefile = File(ximagefile!.path);

    setState(() {
      file = imagefile;
    });
  }

  displayAdminUploadFormScreen() {
    {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearFormInfo,
          ),
          title: Text(
            'New Products',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [
            ElevatedButton(
              onPressed:uploading? null: () => uploadImageAndSaveItemInfo(),
              child: Text(
                'Add',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        body: ListView(
          children:[
          uploading ? circularProgress():Text(''),
            Container(
              height: 230,
              width: MediaQuery.of(context).size.width * 0.8,
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        file!
                      ),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12)),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title: Container(
                width: 250,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _titletextEditingController,
                  decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                      border: InputBorder.none
                  )
                  ,
                ),
              ),
            ),
            Divider(color: Colors.pink,),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
           title: Container(
             width: 250,
             child: TextField(
               style: TextStyle(color: Colors.deepPurpleAccent),
               controller: _shortInftextEditingController,
               decoration: InputDecoration(
                 hintText: 'Short Info',
                 hintStyle: TextStyle(
                   color: Colors.deepPurpleAccent,
                 ),
                 border: InputBorder.none
               )
               ,
             ),
           ),
            ),
            Divider(color: Colors.pink,),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title: Container(
                width: 250,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _descriptiontextEditingController,
                  decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                      border: InputBorder.none
                  )
                  ,
                ),
              ),
            ),
            Divider(color: Colors.pink,),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title: Container(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _pricetextEditingController,
                  decoration: InputDecoration(
                      hintText: 'Price',
                      hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                      border: InputBorder.none
                  )
                  ,
                ),
              ),
            ),
            Divider(color: Colors.pink,),
          ],

        ),
      );
    }
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _pricetextEditingController.clear();
      _shortInftextEditingController.clear();

    });
  }

  uploadImageAndSaveItemInfo()async{
    setState(() {
      uploading = true;
    });
    String? imageDownloadUrl = await uploadItemImage(file!);
    saveItemInfo(imageDownloadUrl);
  }
  Future<String?> uploadItemImage(mFileImage) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('Items');
    UploadTask upLoadTask = storageReference.child('product_$productId.jpg').putFile(mFileImage);
    String downloadurl = await (await upLoadTask).ref.getDownloadURL();
    return downloadurl;
  }

  saveItemInfo(String? downloadUrl){
    final itemsRef = FirebaseFirestore.instance.collection('items');
    itemsRef.doc(productId).set({
      'shortInfo':_shortInftextEditingController.text.trim(),
    'longDescription':_descriptiontextEditingController.text.trim(),
      'price':int.parse(_pricetextEditingController.text),
      'publishedDate':DateTime.now(),
      'status': 'available',
      'thumbnailUrl':downloadUrl,
      'title':_titletextEditingController.text.trim(),
      });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _shortInftextEditingController.clear();
      _pricetextEditingController.clear();
    });
  }


}

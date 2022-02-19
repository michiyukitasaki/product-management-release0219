// import 'package:e_shop/Widgets/customAppBar.dart';
// import 'package:e_shop/Widgets/myDrawer.dart';
// import 'package:e_shop/Models/item.dart';
import 'package:eshop5nofirebase/Models/item.dart';
import 'package:eshop5nofirebase/Widgets/customAppBar.dart';
import 'package:eshop5nofirebase/Widgets/myDrawer.dart';
import 'package:eshop5nofirebase/google_sheets/Model_google/item_google_model.dart';
import 'package:eshop5nofirebase/google_sheets/Screen/ItemScreen.dart';
import 'package:flutter/material.dart';
import 'package:eshop5nofirebase/Store/storehome.dart';
import 'package:pdf/pdf.dart';

import '../../PDF/invoice_service.dart';
import '../../PDF/pdf_home_page.dart';

class DitailWebPage extends StatefulWidget {
  final googleItemModel googleitemModel;

  DitailWebPage({required this.googleitemModel});
  @override
  _DitailWebPageState createState() => _DitailWebPageState();
}

class _DitailWebPageState extends State<DitailWebPage> {
  int quantityOfItems = 1;
  int number = 0;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.green, Colors.cyanAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
          ),
          centerTitle: true,
          title: Text(
            '商品詳細',
            style: TextStyle(
                fontSize: 50, color: Colors.white, fontFamily: 'Signatra'),
          ),
        ),
        // drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child:Center(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.5,
                              width: MediaQuery.of(context).size.height*0.5,
                              child: Image.network(widget.googleitemModel.thumbnailUrl!,   errorBuilder: (c, o, s) {
                                return const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                );
                              },)),
                        ),
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
                          Divider(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '商品名：',
                            style: boldTextStyle,
                          ),
                          Text('${widget.googleitemModel.name!}'),
                          Divider(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'テーマ：',
                            style: boldTextStyle,
                          ),
                          Text('${widget.googleitemModel.theme!}'),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            '価格(税込）:',
                            style: boldTextStyle,
                          ),
                          Text('￥${widget.googleitemModel.price!}'),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            'サイズ[cm]:',
                            style: boldTextStyle,
                          ),
                          Text('${widget.googleitemModel.size!} '),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            '重量[g]:',
                            style: boldTextStyle,
                          ),
                          Text('${widget.googleitemModel.weight!}'),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            '賞味期限：',
                            style: boldTextStyle,
                          ),
                          Text('${widget.googleitemModel.itemlimit!}'),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            '組成：',
                            style: boldTextStyle,
                          ),
                          Text('${widget.googleitemModel.sosei!}'),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            '特徴：',
                            style: boldTextStyle,
                          ),
                          Text('${widget.googleitemModel.itemfuture!}'),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 8),
                  //   child: Center(
                  //     child: InkWell(
                  //       onTap: () async{
                  //         // Route route = MaterialPageRoute(builder: (c) => PdfHomePage(googleitemmodel: widget.googleitemModel,));
                  //         // Navigator.pushReplacement(context, route);
                  //         final PdfInvoiceService service = PdfInvoiceService();
                  //         final data = await service.createInvoice(widget.googleitemModel);
                  //         service.savePdfFile("invoice_$number", data);
                  //         number++;
                  //       },
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //             gradient: LinearGradient(
                  //           colors: [Colors.cyanAccent, Colors.greenAccent],
                  //           begin: const FractionalOffset(0.0, 0.0),
                  //           end: const FractionalOffset(1.0, 0.0),
                  //           stops: [0.0, 1.0],
                  //           tileMode: TileMode.clamp,
                  //         )),
                  //         width: MediaQuery.of(context).size.width - 40,
                  //         height: 50,
                  //         child: Center(
                  //             child: Text(
                  //           'PDFファイル作成',
                  //           style: TextStyle(color: Colors.white, fontSize: 20),
                  //         )),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

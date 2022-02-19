import 'dart:io';
import 'dart:typed_data';
import 'package:eshop5nofirebase/PDF/model/product.dart';
import 'package:eshop5nofirebase/google_sheets/Model_google/item_google_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../Config/config.dart';

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;
  final String vat;
  // final googleItemModel? googleitemmodel;

  CustomRow(this.itemName, this.itemPrice, this.amount, this.total, this.vat,);
}

class PdfInvoiceService {
  Future<Uint8List> createHelloWorld() async {
    final font = await PdfGoogleFonts.belgranoRegular();
    // final fontData = await rootBundle.load('images/fonts/ShipporiMicho-Regular.ttf');
    // final font = Font.ttf(fontData);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font),
        // theme: ThemeData.withFont(base: font),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> createInvoice(googleItemModel googleitemmodel) async {
    final pdf = pw.Document();
    // final font = await PdfGoogleFonts.belgranoRegular();
    final fontData = await rootBundle.load('images/fonts/ShipporiMincho-Regular.ttf');
    final font = Font.ttf(fontData);

    final List<CustomRow> elements = [
      CustomRow("Item Name", "Item Price", "Amount", "Total", "Vat"),
      // for (var product in soldProducts)
        CustomRow(
          googleitemmodel.name!,
          googleitemmodel.price!,
          googleitemmodel.email!,
          googleitemmodel.itemfuture!,
          googleitemmodel.itemlimit!
        ),
      CustomRow(
        "Sub Total",
        "",
        "",
        "",
        "${googleitemmodel.name!} EUR",
      ),
      CustomRow(
        "Vat Total",
        "",
        "",
        "",
        "${googleitemmodel.price!} EUR",
      ),
      CustomRow(
        "Vat Total",
        "",
        "",
        "",
        "${googleitemmodel.itemfuture!} EUR",
      )
    ];
    // NetworkAssetBundle networkAssetBundle = NetworkAssetBundle(widget.googleitemModel.thumbnailUrl!)
    final netImage = await networkImage(googleitemmodel.thumbnailUrl!);
    // final image =
    // (await rootBundle.load("images/mainlogo.jpg")).buffer.asUint8List();
        // (await rootBundle.load("images/mainlogo.jpg")).buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: font),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children:[
            pw.Column(
            children: [
              // pw.Image(pw.MemoryImage(image),
              //     width: 150, height: 150, fit: pw.BoxFit.cover),
              pw.Image(netImage,
                  width: 150, height: 150, fit: pw.BoxFit.cover),
              address(googleitemmodel),
              pw.SizedBox(height: 50),
              pw.Text("商品情報詳細",style: pw.TextStyle(fontSize: 20)),
              pw.SizedBox(height: 25),
              contents(googleitemmodel),
              // itemColumn(elements),
              // pw.SizedBox(height: 25),
              // pw.Text("Thanks for your trust, and till the next time."),
              // pw.SizedBox(height: 25),
              // pw.Text("Kind regards,"),
              // pw.SizedBox(height: 25),
            ],
          ),
          ]);
        },
      ),
    );
    return pdf.save();
  }

  pw.Row address(googleitemmodel) {
    return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('作成者：${
              EcommerceApp5.sharedPreferences!.getString(EcommerceApp5.userName)!}',textAlign: pw.TextAlign.left),
                  pw.Text('作成日：${DateFormat('yyyy年M月d日').format(googleitemmodel.publishedDate.toDate())}',textAlign: pw.TextAlign.left),
                    // pw.Text('商品名：${googleitemmodel.name}',textAlign: pw.TextAlign.left),
                  ],
                ),
                // pw.Column(
                //   children: [
                //     pw.Text("Max Weber"),
                //     pw.Text("Weird Street Name 1"),
                //     pw.Text("77662 Not my City"),
                //     pw.Text("Vat-id: 123456"),
                //     pw.Text("Invoice-Nr: 00001")
                //   ],
                // )
              ],
            );
  }

  pw.Wrap contents(googleitemmodel) {
    return pw.Wrap(
      // crossAxisAlignment: pw.CrossAxisAlignment.start,
      // mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('商品名：${googleitemmodel.name}',textAlign: pw.TextAlign.right,),
            pw.SizedBox(height: 5),
            pw.Text('価格：${googleitemmodel.price}',textAlign: pw.TextAlign.right,),
            pw.SizedBox(height: 5),
            pw.Text('賞味期限：${googleitemmodel.itemlimit}',textAlign: pw.TextAlign.right,),
            pw.SizedBox(height: 5),
            pw.Text('テーマ：${googleitemmodel.theme}',overflow: pw.TextOverflow.visible,),
            pw.SizedBox(height: 5),
            pw.Text('サイズ[幅×奥×高]：${googleitemmodel.size}',textAlign: pw.TextAlign.left),
            pw.SizedBox(height: 5),
            pw.Text('重量[g]：${googleitemmodel.weight}',textAlign: pw.TextAlign.left),
            pw.SizedBox(height: 20),
            pw.Text('組成：'),
            pw.Text('${googleitemmodel.sosei}',textAlign: pw.TextAlign.left),
            pw.SizedBox(height: 20),
            pw.Text('商品特徴：',textAlign: pw.TextAlign.left,overflow: pw.TextOverflow.clip,),
            pw.Text('${googleitemmodel.itemfuture}',textAlign: pw.TextAlign.left,overflow: pw.TextOverflow.clip,),

          ],
        ),
        // pw.Column(
        //   children: [
        //     pw.Text("Max Weber"),
        //     pw.Text("Weird Street Name 1"),
        //     pw.Text("77662 Not my City"),
        //     pw.Text("Vat-id: 123456"),
        //     pw.Text("Invoice-Nr: 00001")
        //   ],
        // )
      ],
    );
  }




  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text(element.amount,
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(
                    child: pw.Text(element.itemPrice,
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child:
                        pw.Text(element.amount, textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child:
                        pw.Text(element.total, textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child: pw.Text(element.vat, textAlign: pw.TextAlign.right)),
              ],
            )
        ],
      ),
    );
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
    await uploadToFirebasePdfFile(file);
  }

  String getSubTotal(List<Product> products) {
    return products
        .fold(0.0,
            (double prev, element) => prev + (element.amount * element.price))
        .toStringAsFixed(2);
  }

  String getVatTotal(List<Product> products) {
    return products
        .fold(
          0.0,
          (double prev, next) =>
              prev + ((next.price / 100 * next.vatInPercent) * next.amount),
        )
        .toStringAsFixed(2);
  }

  Future<UploadTask> uploadToFirebasePdfFile(File file) async {
    // if (file == null) {
    //   Scaffold.of(context)
    //       .showSnackBar(SnackBar(content: Text("Unable to Upload")));
    //   return null;
    // }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('/some-file.pdf');

    // final metadata = FirebaseStorage.SettableMetadata(
    //     contentType: 'file/pdf',
    //     customMetadata: {'picked-file-path': file.path});
    // print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes());
    print("done..!");
    return Future.value(uploadTask);
  }


}

import 'package:eshop5nofirebase/PDF/model/product.dart';
import 'package:eshop5nofirebase/Widgets/AppBar_noaction.dart';
import 'package:eshop5nofirebase/Widgets/customAppBar.dart';
import 'package:eshop5nofirebase/google_sheets/Model_google/item_google_model.dart';
import 'package:flutter/material.dart';

import 'invoice_service.dart';

class PdfHomePage extends StatefulWidget {
  const PdfHomePage({Key? key, required this.googleitemmodel}) : super(key: key);
  final googleItemModel googleitemmodel;

  @override
  _PdfHomePageState createState() => _PdfHomePageState();
}

class _PdfHomePageState extends State<PdfHomePage> {
  final PdfInvoiceService service = PdfInvoiceService();
  List<Product> products = [
    Product("Membership", 9.99, 19),
    Product("Nails", 0.30, 19),
    Product("Hammer", 26.43, 19),
    Product("Hamburger", 5.99, 7),
  ];
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNoAction(title: 'PDF作成',bottom: null,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final currentProduct = products[index];
                  return Row(
                    children: [
                      Expanded(child: Text(currentProduct.name)),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Price: ${currentProduct.price.toStringAsFixed(2)} €"),
                            Text("VAT ${currentProduct.vatInPercent.toStringAsFixed(0)} %")
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  setState(() => currentProduct.amount++);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                currentProduct.amount.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  setState(() => currentProduct.amount--);
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
                itemCount: products.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("VAT"), Text("${getVat()} €")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Total"), Text("${getTotal()} €")],
            ),
            ElevatedButton(
              onPressed: () async {
                final data = await service.createInvoice(widget.googleitemmodel);
                service.savePdfFile("invoice_$number", data);
                number++;
              },
              child: const Text("Create Invoice"),
            ),
          ],
        ),
      ),
    );
  }

  getTotal() => products
      .fold(0.0, (double prev, element) => prev + (element.price * element.amount))
      .toStringAsFixed(2);

  getVat() => products
      .fold(
      0.0,
          (double prev, element) =>
      prev + (element.price / 100 * element.vatInPercent * element.amount))
      .toStringAsFixed(2);
}



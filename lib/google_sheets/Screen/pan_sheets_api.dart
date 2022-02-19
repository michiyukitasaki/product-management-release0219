

import 'package:eshop5nofirebase/google_sheets/Screen/product.dart';
// import 'package:eshop5nofirebase/google_sheets/user.dart';
import 'package:flutter/widgets.dart';
import 'package:gsheets/gsheets.dart';


class PanSheetsApi{
  static final _spreadsheetId = '1OSzG00IU04AGDjxrlGGN0bFOw_izTLEpNLs0vYtD0Vc';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "dai1pan",
  "private_key_id": "866eee3fddb9b3bbc81247e1ff3596b4a19652f8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCjxxUdOFQx93fU\nNUxxSjYi8FXbaDmxL05i2Zyc4jv5zHVjJC3I7T0H5DG/2kxHxVKzNVDPdxeyByzU\ncW4wl3p6DSVubZn9sFnf4IK24qerQ/l1QihR9f/VufsBpanLjmuPHWqTx8y/SKuT\nirR1m+cq+CGO8/6tFNV/ppPkNFaiJgpJecLU1U0kekAVhEjIU6sznch1yivQG5Sr\n+PO8VsI9GCGDPe5Hi2J92ih7Cfh8hrxx4/jKnp1HFrObi4k0w4xFoPGbWY9wWYeR\nVfDtKjY/3raC2macNQkyKRuyLpfHCeXaOIHLtIFyFUd6GDQKJDwz2Ifej02nCjHz\nW5YMexj5AgMBAAECggEANkDm360fRwYhbezSC913nY9cAbi/E9EF+Hz6AoZ3M8Ll\nSBheCmd8hjazvEhGaKgXQ0JwKKnc8Z6q3R1OUU58xh3AvpoUHxPiUeV/p7HhtTxp\nUMy/qpcBTv2zBtKoMsRVIS2vdpEDZIJgRBn4udUReQyFoWN2hEOYjhbSexBTepbz\nutCIWvlLN64FLq61tlTh0YRJGyOg8XQkGGZbaxKK7x/iJ3p973oiyiY0J1rYbjlw\n2ucN2NInJvkCnR87knmtdRrrLCfpJ8nUt5Ex/6AlrnOJo2/cZ4/6Nb3qGbfDG/PQ\nBRpjKQn4/Yqh4AFzY7+NEGAcQShNIQ5N1TMx5BLyeQKBgQDOfaKiFRTqq2Dx3h4a\nX1MWGS9dfy/y4zuJHllU6eDk/DzdgoadR0GhYhIL/ROHWkbMfySpLEGwghU9GgMo\nnojyWmvSv4nl6KUbAiJbPzBBQIxHDq7yKYiFDpINzc+MkTc7kQUwIWzOCuvMGVMn\nNibHs5cmFjSZZKS7fWjtbJR9ywKBgQDLC7mogIcrKHOw+er/3hBz0nPz33VQJHLt\n2ubSScs8oR15KvJaY0SEAAMXHsR4hsO7uucEV1pOsvBSkCH+IPTdhhOa30Pj7Th2\ncrChS/AJV8sWiDjCBW4d3Dl//m7JssgTk2/U2Arg2rPak9YPntJPpASTdVVe8QQZ\nYdGnAYbrywKBgEHUIa3kZKevfRd+hUBJFXbdDpGTA5k+QfOjvjzo1q6Jj2nau8mW\nNuEZH8G8q6Yh7KIzAmAAYOzBe73f9hPT/rqsguVL9M1bzo7+ri9CxMJ4rn/UuYcw\nIHqyu3M1Iq6geOg/glTmwwYoyyVlCXJdvB08LrqQp7IjOLUg9PuD+w7jAoGBAJAm\nN91vugaixlerZfHW9nkzvMwzJXcLGWjR0rMSXq4hd+ow2jPfa6IG3CrK1hL3Ifii\nPSYw2dUrZkBHQUrInO60JDD8NpeXL1GwJMOuRLBtWqoZdaoQ7tdWJKBAwuiA+1gi\ngO9rnXV67trLv9oBGDAgMnt5fm1T0GQwtQXKqL23AoGBAMAOyabjWnbeZtYl1EYW\nFwNEjdfdW8jT63kZUqPd9SdohmOhwB5SLh7uPBVyGrNpdMrpuUhVjSzs4agkRgKg\n/WGbqII0oHFxN6eQXsrAlui6Cl28wUW6yjrAD0GYAPvjBRUtI8S6B35LvbXCl+S7\nKk8OS7QxiEGZHsMRN5hSf247\n-----END PRIVATE KEY-----\n",
  "client_email": "dai1pan@dai1pan.iam.gserviceaccount.com",
  "client_id": "108674267103901659867",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dai1pan%40dai1pan.iam.gserviceaccount.com"
}
  ''';

  static Future init() async{
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Users');
      final firstRow = ProductFields.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e){
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, {
        required String title,
      }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    }catch (e){
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<int> getRowCount() async {
    if (_userSheet == null) return 0;
    final lastRow = await _userSheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future insert(List<Map<String, dynamic>> rowList) async{
    if(_userSheet == null) return;
    _userSheet!.values.map.appendRows(rowList);
  }

  //readメソッド

  static Future<List<Product>> getAll() async{
    if(_userSheet == null) return <Product>[];
    final products = await _userSheet!.values.map.allRows();
    return products == null ? <Product>[] : products.map(Product.fromJson).toList();
  }

  static Future<Product?> getById(int id) async{
    if(_userSheet == null) return null;
    final json = await _userSheet!.values.map.rowByKey(id, fromColumn: 1);
    return json == null ?null :Product.fromJson(json);
  }

  static Future <bool> update(
      int id,
      Map<String, dynamic> product
      ) async {
    if(_userSheet == null) return false;
    return _userSheet!.values.map.insertRow(id, product);
  }

  static Future<bool> updateCell({
    required int id,
    required String key,
    required dynamic value,
  }) async {
    if(_userSheet == null)return false;
    return _userSheet!.values.insertValueByKeys(
        value,
        columnKey: key,
        rowKey: id);
  }

  static Future<bool> deleteById(int id) async{
    if(_userSheet == null)return false;
    final index = await _userSheet!.values.rowIndexOf(id);
    if(index == -1) return false;
    return _userSheet!.deleteRow(index);
  }


}
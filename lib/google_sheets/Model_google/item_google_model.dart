
import 'package:cloud_firestore/cloud_firestore.dart';

class googleItemModel {
  String? name;
  // String? shortInfo;
  Timestamp? publishedDate;
  String? email;
  bool? isBeginner;

  String? theme;
  String? price;
  String? itemlimit;
  String? size;
  String? weight;
  String? sosei;
  String? itemfuture;
  String? thumbnailUrl;

  

  googleItemModel(
      {required this.name,
        required this.publishedDate,
        required this.email,
        required this.isBeginner,

        required this.theme,
        required this.price,
        required this.itemlimit,
        required this.size,
        required this.weight,
        required this.sosei,
        required this.itemfuture,
        required this.thumbnailUrl
      });

  googleItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    email = json['email'];
    isBeginner = json['isBeginner'];

    theme = json['theme'];
    price = json['price'];
    itemlimit = json['itemlimit'];
    size = json['size'];
    weight = json['weight'];
    sosei = json['sosei'];
    itemfuture = json['itemfuture'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['isBeginner'] = this.isBeginner;

    data['theme'] = this.theme;
    data['price'] = this.price;
    data['itemlimit'] = this.itemlimit;
    data['size'] = this.size;
    data['weight'] = this.weight;
    data['sosei'] = this.sosei;
    data['itemfuture'] = this.itemfuture;
    data['thumbnailUrl'] = this.thumbnailUrl;
    return data;
  }
}

class PublishedDate {
  String? date;

  PublishedDate({required this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}

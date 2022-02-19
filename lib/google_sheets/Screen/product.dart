


import 'dart:convert';

import 'dart:ui';

class ProductFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String email = 'email';
  static final String isBeginner = 'isBeginner';

  static final String theme = 'theme';
  static final String price = 'price';
  static final String itemlimit = 'itemlimit';
  static final String size = 'size';
  static final String weight = 'weight';
  static final String sosei = 'sosei';
  static final String itemfuture = 'itemfuture';
  static final String thumbnailUrl = 'thumbnailUrl';

  static List<String> getFields() => [id, name, email, isBeginner, theme, price,itemlimit, size, weight, sosei, itemfuture];
}

class Product {
  final int? id;
  final String name;
  final String email;
  final bool isBeginner;

  final String theme;
  final String price;
  final String itemlimit;
  final String size;
  final String weight;
  final String sosei;
  final String itemfuture;
  final String thumbnailUrl;


  const Product({
    this.id,
    required this.name,
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

  Product copy({
    int? id,
    String? name,
    String? email,
    bool? isBeginner,

    String? theme,
    String? price,
    String? itemlimit,
    String? size,
    String? weight,
    String? sosei,
    String? itemfuture,
    String? thumbnailUrl

  }) => Product(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isBeginner: isBeginner ?? this.isBeginner,

      theme:theme ?? this.theme,
      price:price ?? this.price,
      itemlimit: itemlimit ?? this.itemlimit,
      size : size ?? this.size,
      weight:weight ?? this.weight,
      sosei: sosei ?? this.sosei,
      itemfuture: itemfuture ?? this.itemfuture,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl

  );

  static Product fromJson(Map<String, dynamic> json) => Product(
    id: jsonDecode(json[ProductFields.id]),
    name: json[ProductFields.name],
    email: json[ProductFields.email],
    isBeginner: jsonDecode(json[ProductFields.isBeginner]),

    // theme: jsonDecode(json[ProductFields.theme]),
    theme: json[ProductFields.theme],
    itemlimit: json[ProductFields.itemlimit],
    size: json[ProductFields.size],
    weight: json[ProductFields.weight],
    sosei: json[ProductFields.sosei],
    itemfuture: json[ProductFields.itemfuture],
    price: json[ProductFields.price],
    thumbnailUrl: json[ProductFields.thumbnailUrl]
  );

  Map<String, dynamic> toJson() => {
    ProductFields.id: id,
    ProductFields.name:name,
    ProductFields.email:email,
    ProductFields.isBeginner:isBeginner,

    ProductFields.theme:theme,
    ProductFields.price:price,
    ProductFields.itemlimit:itemlimit,
    ProductFields.size:size,
    ProductFields.weight:weight,
    ProductFields.sosei:sosei,
    ProductFields.itemfuture:itemfuture,
    ProductFields.thumbnailUrl:thumbnailUrl
  };

}
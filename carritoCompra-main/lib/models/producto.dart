// To parse this JSON data, do
//
//     final producto = productoFromMap(jsonString);

import 'dart:convert';

class Producto {
  Producto({
    required this.name,
    required this.image,
    required this.price,
    required this.descripcion,
    this.id,
  });

  String name;
  String image;
  double price;
  String descripcion;
  String? id;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        name: json["name"],
        image: json["image"],
        price: json["price"].toDouble(),
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "image": image,
        "price": price,
        "descripcion": descripcion,
        "id": id,
      };

  Producto copy() => Producto(
      name: name, image: image, price: price, descripcion: descripcion);
}

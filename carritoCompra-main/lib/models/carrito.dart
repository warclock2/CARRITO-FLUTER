// To parse this JSON data, do
//
//     final carrito = carritoFromMap(jsonString);

import 'dart:convert';

class Carrito {
    Carrito({
      this.id,
      required this.imagen,
      required this.cantidad,
      required this.total,
      required this.idUsuario,
      required this.nombre,
    });

    String? id;
    String imagen;
    int cantidad;
    double total;
    String idUsuario;
    String nombre;

    factory Carrito.fromJson(String str) => Carrito.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Carrito.fromMap(Map<String, dynamic> json) => Carrito(
        id: json["id"],
        imagen: json["imagen"],
        cantidad: json["cantidad"],
        total: json["total"].toDouble(),
        idUsuario: json["idUsuario"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "imagen": imagen,
        "cantidad": cantidad,
        "total": total,
        "idUsuario": idUsuario,
        "nombre": nombre,
    };
}

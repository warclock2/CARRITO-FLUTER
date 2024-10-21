// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

class Usuario {
    Usuario({
      this.id,
      required  this.email,
      required  this.nombre,
      required  this.telefono,
      required  this.barrio,
      required  this.direccion,
      required this.imagen
    });

    String? id;
    String email;
    String nombre;
    String telefono;
    String barrio;
    String direccion;
    String imagen;

    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        email: json["email"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        barrio: json["barrio"],
        direccion: json["direccion"],
        imagen: json["imagen"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "nombre": nombre,
        "telefono": telefono,
        "barrio": barrio,
        "direccion": direccion,
        "imagen": imagen,
    };
}

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:loginapp/models/carrito.dart';


class CarritoService extends ChangeNotifier {

  final String _baseUrl = 'tiendaapp-899a7-default-rtdb.firebaseio.com';
  final List<Carrito> carritos = [];
  late List<Carrito> carritoFiltro = [];
  double precioTotal = 0.0;

  final storage = const FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;

  CarritoService(){
    loadCarritos();
  }

  Future<List<Carrito>> loadCarritos() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'carrito.json');
    final resp = await http.get( url );

    final Map<String, dynamic> carritosMap = json.decode(resp.body);

    carritosMap.forEach((key, value) {
      final tempCarrito = Carrito.fromMap(value);
        tempCarrito.id = key;
        carritos.add(tempCarrito);
    });

    isLoading = false;
    notifyListeners();
    return carritos;
  }

  Future createCarrito(Carrito carrito) async {
    isSaving = true;
    notifyListeners();

    final url = Uri.https( _baseUrl , 'carrito.json');
    final resp = await http.post( url, body: carrito.toJson() );
    final decodedData =  json.decode(resp.body);

    carrito.id = decodedData['name'];
    carritos.add(carrito);
    isSaving = false;
    notifyListeners();
    return carrito.id!;
  }

  Future<List<Carrito>> carritoFiltrado(String idUser) async {
    precioTotal = 0;
    for (var producto in carritos) {
      print(producto.idUsuario);
      if(producto.idUsuario == idUser){
        carritoFiltro.add(producto);
        precioTotal = producto.total + precioTotal;
        print(producto.id);
      }
    }
    return carritoFiltro;
  }

  Future deleteProductoCarrito(Carrito carrito) async {
    isSaving = true;
    print(carrito.id);
    final url = Uri.https(_baseUrl, 'carrito/${carrito.id}.json' );
    final resp = await http.delete(url, body: carrito.toJson());
    final decodedData = resp.body;

    carritos.removeWhere((element) => element.id == carrito.id);
    carritoFiltro.removeWhere((element) => element.id == carrito.id);
    precioTotal = precioTotal - carrito.total;

    print(decodedData);
    isSaving = false;
    notifyListeners();
    return carrito;
  }

}
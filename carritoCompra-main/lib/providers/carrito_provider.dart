import 'package:flutter/material.dart';
import 'package:loginapp/models/carrito.dart';

class CarritoProvider extends ChangeNotifier {

  Carrito carrito;

  CarritoProvider(this.carrito);

  updateAvailability ( bool value ) {
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:loginapp/models/producto.dart';

class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Producto producto;

  ProductFormProvider(this.producto);


  updateAvailability ( bool value ) {
    notifyListeners();
  }

  bool isValidForm() {

    return formKey.currentState?.validate() ?? false;

  }

}
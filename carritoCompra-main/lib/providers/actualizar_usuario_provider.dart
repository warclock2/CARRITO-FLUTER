import 'package:flutter/material.dart';
import 'package:loginapp/models/usuario.dart';

class UsuarioActualizarFromProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey =  GlobalKey<FormState>();

  Usuario usuario;

  UsuarioActualizarFromProvider(this.usuario);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading (bool value) {
    _isLoading = value;
    notifyListeners();
  }


  bool isValidForm(){
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }

}
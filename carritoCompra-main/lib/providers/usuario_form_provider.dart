import 'package:flutter/material.dart';

class UsuarioFromProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey =  GlobalKey<FormState>();

  String email = '';
  String password = '';
  String nombre = '';
  String telefono =  '';
  String direccion = '';
  String barrio = '';
  String imagen = '';
  

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading (bool value) {
    _isLoading = value;
    notifyListeners();
  }


  bool isValidForm(){

    print('$email - $password');
    
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }

}
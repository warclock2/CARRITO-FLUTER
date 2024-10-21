import 'package:flutter/material.dart';
import 'package:loginapp/servicios/usuario_service.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService extends ChangeNotifier {

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBhVApzxPj21R9jUGH_EzPrpbW77Bm_v9M';

  String correo = '';
  bool validatorAdmin = false;

  final storage = const FlutterSecureStorage();

  final usuario = UsuarioService();


  Future<String?> createUser( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      // token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // decodedResp['idToken'];
      return null;
    }else{
      return decodedResp['error']['message'];
    }

  }


  Future<String?> login( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      // token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // decodedResp['idToken'];
      correo = decodedResp['email'];
      notifyListeners();
      final admin = await usuario.loadAdmin();
      print(admin);
      if(correo == admin){
        validatorAdmin = true; 
      }
      print(validatorAdmin);
      await usuario.filtroUsuario(correo);
      return null;
    }else{
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    validatorAdmin = false;
    print(validatorAdmin);
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

}
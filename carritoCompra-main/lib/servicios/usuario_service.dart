import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:loginapp/models/usuario.dart';


class UsuarioService extends ChangeNotifier {

  final String _baseUrl = 'tiendaapp-899a7-default-rtdb.firebaseio.com';

  final List<Usuario> usuarios = [];

  String admin = '';
  String correo = '';
  String image = '';
  File? newImageFile;
  bool isLoading = true;
  bool isSaving = false;
  late Usuario user = Usuario(
    email: '', 
    nombre: '', 
    telefono: '', 
    barrio: '', 
    direccion: '', 
    imagen: ''
  );
  late Usuario selectUsuario; 

  UsuarioService(){
    loadUsuario();
    loadAdmin();
  }

  Future<List<Usuario>> loadUsuario() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'usuario.json');
    final resp = await http.get( url );

    final Map<String, dynamic> usuariossMap = json.decode(resp.body);

    usuariossMap.forEach((key, value) { 
      final tempUsuario = Usuario.fromMap(value);
      tempUsuario.id = key;
      usuarios.add(tempUsuario);
    });

    isLoading = false;
    notifyListeners();
    print('paso');
    return usuarios;
  }

  Future<String> createUsuaria( Usuario usuario ) async {

    final url = Uri.https( _baseUrl , 'usuario.json');
    final resp = await http.post( url, body: usuario.toJson() );
    final decodedData =  json.decode(resp.body);

    usuario.id = decodedData['name'];

    usuarios.add(usuario);

    return usuario.id!;
  }

  Future<String> updateUser(Usuario usuario) async {

    final url = Uri.https( _baseUrl , 'usuario/${usuario.id}.json');
    final resp = await http.put( url, body: usuario.toJson() );
    final decodedData =  json.decode(resp.body);

    user = usuario;
    print(decodedData);
    return usuario.id!;
  }

  Future<String> loadAdmin() async {

    final url = Uri.https( _baseUrl, 'admin/token.json');
    final resp = await http.get( url );

    admin = json.decode(resp.body);

    return admin;
  }

    Future filtroUsuario(String id) async{
    correo = id;
    for (var usuario in usuarios) { 
      if(usuario.email == id){
        user = usuario;
      }
    }
  }

  void updateSelectedProductImage( String path ){

    image = path;
    newImageFile = File.fromUri( Uri(path: path) );

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if( newImageFile == null ) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dki3svtkb/image/upload?upload_preset=rtewv1nj');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newImageFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201 ){
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    newImageFile = null;

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];

  }
}
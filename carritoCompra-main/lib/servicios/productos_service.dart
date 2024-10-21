import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:loginapp/models/producto.dart';

class ProductsService extends ChangeNotifier {
  
  final String _baseUrl = 'tiendaapp-899a7-default-rtdb.firebaseio.com';
  final List<Producto> products = [];
  late Producto selectedProduct;

  final storage = const FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;

  File? newImageFile;

  ProductsService(){
    loadProducts();
  }

  Future<List<Producto>> loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'products.json');
    final resp = await http.get( url );

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) { 
      final tempProduct = Producto.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future deleteProduct(Producto product) async {
    isSaving = true;
    final url = Uri.https( _baseUrl , 'products/${ product.id }.json');
    final resp = await http.delete( url, body: product.toJson() );
    final decodedData = resp.body;

    products.removeWhere((element) => element.id == product.id );

    print(decodedData);
    isSaving = false;
    notifyListeners();
    return product;
  }

  Future saveOrCreateProduct( Producto product ) async {
    isSaving = true;
    notifyListeners();

    if(product.id == null){
      // es necesario crear
      await createProduct(product);
    }else{
      // actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();

  }

  Future<String> updateProduct( Producto product) async {

    final url = Uri.https( _baseUrl , 'products/${ product.id }.json');
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;

    // Actualizar el listado de productos

    final index = products.indexWhere((element) => element.id == product.id );
    products[index] = product;

    print(decodedData);
    return product.id!;
  }

  Future<String> createProduct( Producto product) async {

    final url = Uri.https( _baseUrl , 'products.json');
    final resp = await http.post( url, body: product.toJson() );
    final decodedData =  json.decode(resp.body);

    product.id = decodedData['name'];

    products.add(product);

    return product.id!;
  }

  void updateSelectedProductImage( String path ){

    selectedProduct.image = path;
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
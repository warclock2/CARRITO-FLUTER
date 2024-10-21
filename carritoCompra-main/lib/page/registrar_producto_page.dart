import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart';
import 'package:loginapp/models/producto.dart';
import 'package:loginapp/providers/producto_form_provider.dart';
import 'package:loginapp/servicios/productos_service.dart';

class RegistrarProductoPage extends StatelessWidget {
  const RegistrarProductoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productoService = Provider.of<ProductsService>(context);
    final Producto producto;

    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productoService.selectedProduct),
        child: _bodyPage(
          size: size,
          productoService: productoService,
        ));
  }
}

class _bodyPage extends StatelessWidget {
  const _bodyPage({
    Key? key,
    required this.productoService,
    required this.size,
  }) : super(key: key);

  final Size size;
  final ProductsService productoService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          productoService.selectedProduct.id == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[300],
                        size: 40,
                      ),
                      onPressed: productoService.isSaving
                          ? null
                          : () async {
                              await productoService
                                  .deleteProduct(productForm.producto);
                              Navigator.pop(context, 'home');
                            }),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt_rounded,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 100);

                if (pickedFile == null) {
                  print('no selecciono nada');
                  return;
                }
                productoService.updateSelectedProductImage(pickedFile.path);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * 0.40,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: size.height * 0.35,
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: (productoService.selectedProduct.image == '')
                          ? const Image(
                              image: AssetImage('assets/no-image.png'),
                              fit: BoxFit.cover,
                            )
                          : getImage(productoService.selectedProduct.image),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const _FormProducto(),
            const SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: productoService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save_outlined),
        onPressed: productoService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;

                final String? imageUrl = await productoService.uploadImage();

                print(imageUrl);

                if (imageUrl != null) productForm.producto.image = imageUrl;

                await productoService.saveOrCreateProduct(productForm.producto);
                Navigator.pop(context, 'home');
              },
      ),
    );
  }
}

Widget getImage(String? url) {
  if (url!.startsWith('http')) {
    return FadeInImage(
      placeholder: const AssetImage('assets/jar-loading.gif'),
      image: NetworkImage(url),
      fit: BoxFit.cover,
    );
  }

  return Image.file(
    File(url),
    fit: BoxFit.cover,
  );
}

class _FormProducto extends StatelessWidget {
  const _FormProducto({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productForm = Provider.of<ProductFormProvider>(context);
    final producto = productForm.producto;

    return SizedBox(
      width: size.width * 0.7,
      child: Form(
        key: productForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              initialValue: producto.name,
              onChanged: (value) => producto.name = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Nombre del producto',
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
                initialValue: '${producto.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                decoration: const InputDecoration(
                    hintText: '\$150', labelText: 'Precio'),
                onChanged: (value) => double.tryParse(value) == null
                    ? producto.price = 0
                    : producto.price = double.parse(value)),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: producto.descripcion,
              decoration: const InputDecoration(
                hintText: 'Descripción del producto',
                labelText: 'Descripción',
              ),
              onChanged: (value) => producto.descripcion = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'debe ser de 6 o mas caracteres';
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

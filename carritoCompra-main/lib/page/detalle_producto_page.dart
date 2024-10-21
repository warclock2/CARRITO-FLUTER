import 'package:flutter/material.dart';
import 'package:loginapp/models/carrito.dart';
import 'package:loginapp/servicios/auth_service.dart';
import 'package:loginapp/servicios/carrito_service.dart';
import 'package:provider/provider.dart';

import 'package:loginapp/page/registrar_producto_page.dart';
import 'package:loginapp/servicios/productos_service.dart';

class DetalleProdcutoPage extends StatefulWidget {
  const DetalleProdcutoPage({Key? key}) : super(key: key);

  @override
  State<DetalleProdcutoPage> createState() => _DetalleProdcutoPageState();
}

class _DetalleProdcutoPageState extends State<DetalleProdcutoPage> {
  int cantidad = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final producto = Provider.of<ProductsService>(context);
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          producto.selectedProduct.name,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.5,
            color: Colors.blue,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    height: size.height * 0.40,
                    width: size.width * 0.8,
                    child: (producto.selectedProduct.image == '')
                        ? const Image(
                            image: AssetImage('assets/no-image.png'),
                            fit: BoxFit.cover,
                          )
                        : getImage(producto.selectedProduct.image)),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Descripción del producto:",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(producto.selectedProduct.descripcion,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        elevation: 3,
                        color: Colors.red,
                        child: const Icon(
                          Icons.remove_rounded,
                          size: 40,
                        ),
                        onPressed: () {
                          if (cantidad > 0) {
                            cantidad = cantidad - 1;
                            setState(() {});
                            print(cantidad);
                          }
                        }),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      '$cantidad',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        elevation: 3,
                        color: Colors.blue,
                        child: const Icon(
                          Icons.add,
                          size: 40,
                        ),
                        onPressed: () {
                          cantidad++;
                          setState(() {});
                          print(cantidad);
                        }),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    elevation: 3,
                    color: Colors.green,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Agregar',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.shopping_cart_checkout_sharp,
                            size: 35,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    onPressed: cantidad <= 0
                        ? null
                        : () async {
                            final carritoService = Provider.of<CarritoService>(
                                context,
                                listen: false);

                            carritoService.isLoading = true;
                            final String? message =
                                await carritoService.createCarrito(Carrito(
                              imagen: producto.selectedProduct.image,
                              cantidad: cantidad,
                              total: producto.selectedProduct.price * cantidad,
                              idUsuario: auth.correo,
                              nombre: producto.selectedProduct.name,
                            ));
                            Navigator.pop(context, 'home');
                            print(auth.correo);
                            if (message == null) {
                              print('Todo correcto');
                            } else {
                              print(message);
                              carritoService.isLoading = false;
                            }
                          }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

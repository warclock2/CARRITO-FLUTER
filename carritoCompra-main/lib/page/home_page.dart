import 'package:flutter/material.dart';
import 'package:loginapp/models/producto.dart';
import 'package:loginapp/servicios/carrito_service.dart';
import 'package:loginapp/servicios/productos_service.dart';
import 'package:loginapp/servicios/usuario_service.dart';
import 'package:provider/provider.dart';

import 'package:loginapp/servicios/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final productService = Provider.of<ProductsService>(context);
    final carrito = Provider.of<CarritoService>(context);
    final usuario = Provider.of<UsuarioService>(context);

    final productos = productService.products;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundImage: NetworkImage(usuario.user.imagen),
                maxRadius: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'opcionesUser');
                  },
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.4, vertical: 20),
          child: GridView.builder(
            itemCount: productos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.4,
                crossAxisSpacing: 20.4,
                childAspectRatio: 0.78),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    productService.selectedProduct = productos[index];
                    if (authService.validatorAdmin) {
                      Navigator.pushNamed(context, 'producto');
                    } else {
                      Navigator.pushNamed(context, 'detalle');
                    }
                  },
                  child: _Card(
                    producto: productos[index],
                  ));
            },
          ),
        ),
        floatingActionButton: (authService.validatorAdmin)
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  productService.selectedProduct =
                      Producto(name: '', image: '', price: 0, descripcion: '');
                  Navigator.pushNamed(context, 'producto');
                },
              )
            : FloatingActionButton(
                child: const Icon(
                  Icons.shopping_cart_checkout_sharp,
                  size: 35,
                ),
                onPressed: () async {
                  carrito.carritoFiltro = [];
                  await carrito.carritoFiltrado(authService.correo);
                  Navigator.pushNamed(context, 'carrito');
                },
              ));
  }
}

class _Card extends StatelessWidget {
  const _Card({Key? key, required this.producto}) : super(key: key);

  final Producto producto;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[50],
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 10), blurRadius: 5)
          ]),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  image: NetworkImage(producto.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(producto.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 5),
          Text(
            '\$ ${producto.price}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

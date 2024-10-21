import 'package:flutter/material.dart';
import 'package:loginapp/models/carrito.dart';
import 'package:loginapp/servicios/carrito_service.dart';
import 'package:provider/provider.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final carritoService = Provider.of<CarritoService>(context);
    final carritos = carritoService.carritoFiltro;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: carritos.length,
                itemBuilder: (context, int index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 20),
                      child: cardCarrito(carrito: carritos[index]));
                }),
          ),
          Container(
            width: double.infinity,
            height: size.height * 0.08,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total: ${carritoService.precioTotal}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 25,
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    elevation: 3,
                    color: Colors.green,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pedir',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.add_task,
                            size: 35,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {})
              ],
            ),
          )
        ],
      ),
    );
  }
}

class cardCarrito extends StatelessWidget {
  const cardCarrito({Key? key, required this.carrito}) : super(key: key);

  final Carrito carrito;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final carritoService = Provider.of<CarritoService>(context);

    return Container(
      height: size.height * 0.18,
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 10), blurRadius: 2)
          ]),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            width: size.width * 0.3,
            height: size.height * 0.14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(carrito.imagen),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Container(
                width: size.width * 0.5,
                height: 25,
                alignment: Alignment.topLeft,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      carrito.nombre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Cantidad: ${carrito.cantidad}',
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Total: ${carrito.total}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 18)),
              Container(
                alignment: Alignment.topRight,
                width: size.width * 0.45,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    size: 35,
                    color: Colors.red,
                  ),
                  onPressed: carritoService.isSaving
                      ? () => print(carrito.id)
                      : () async {
                          await carritoService.deleteProductoCarrito(carrito);
                        },
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          )
        ],
      ),
    );
  }
}

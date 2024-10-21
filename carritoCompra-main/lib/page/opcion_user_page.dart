import 'package:flutter/material.dart';
import 'package:loginapp/servicios/usuario_service.dart';

import 'package:provider/provider.dart';

import '../servicios/auth_service.dart';
import '../servicios/carrito_service.dart';

class OpcionUserPage extends StatelessWidget {
  const OpcionUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final carrito = Provider.of<CarritoService>(context);
    final usuarioService = Provider.of<UsuarioService>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Opciones de Usuario',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.deepPurpleAccent[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(usuarioService.user.imagen),
              maxRadius: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: () {
                usuarioService.selectUsuario = usuarioService.user;
                Navigator.pushNamed(context, 'actualizarUser');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              elevation: 3,
              color: Colors.blue,
              child: Container(
                width: size.width * 0.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_ind_sharp,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Datos',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: () {
                authService.logout();
                carrito.carritoFiltro = [];
                Navigator.pushReplacementNamed(context, 'login');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              elevation: 3,
              color: Colors.red,
              child: Container(
                width: size.width * 0.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Logaut',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

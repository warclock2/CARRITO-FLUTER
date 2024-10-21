import 'package:flutter/material.dart';
import 'package:loginapp/page/actualizar_usuario_page.dart';
import 'package:loginapp/page/carrito_page.dart';
import 'package:loginapp/page/detalle_producto_page.dart';
import 'package:loginapp/page/home_page.dart';
import 'package:loginapp/page/opcion_user_page.dart';
import 'package:loginapp/page/registrar_producto_page.dart';
import 'package:loginapp/servicios/auth_service.dart';
import 'package:loginapp/servicios/carrito_service.dart';
import 'package:loginapp/servicios/productos_service.dart';
import 'package:loginapp/servicios/usuario_service.dart';
import 'package:provider/provider.dart';

import 'package:loginapp/page/login_page.dart';
import 'package:loginapp/page/registro_page.dart';

void main() async {
 
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => UsuarioService(), lazy: false),
        ChangeNotifierProvider(
          create: (_) => CarritoService(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginPage(),
        'registrar': (_) => const RegistrarPage(),
        'home': (_) => const HomePage(),
        'producto': (_) => const RegistrarProductoPage(),
        'detalle': (_) => const DetalleProdcutoPage(),
        'carrito': (_) => const CarritoPage(),
        'opcionesUser': (_) => const OpcionUserPage(),
        'actualizarUser': (_) => const ActualizarUsuarioPage(),
      },
    );
  }
}

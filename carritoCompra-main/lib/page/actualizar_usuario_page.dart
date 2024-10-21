import 'package:flutter/material.dart';
import 'package:loginapp/providers/actualizar_usuario_provider.dart';

import 'package:provider/provider.dart';

import 'package:loginapp/models/usuario.dart';
import 'package:loginapp/page/registrar_producto_page.dart';
import 'package:loginapp/providers/usuario_form_provider.dart';
import 'package:loginapp/servicios/usuario_service.dart';

class ActualizarUsuarioPage extends StatelessWidget {
  const ActualizarUsuarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioService = Provider.of<UsuarioService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.deepPurpleAccent[400],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Center(
                    child: Text(
                  'Datos Usuario',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
                const SizedBox(
                  height: 20,
                ),
                ChangeNotifierProvider(
                  create: (_) => UsuarioActualizarFromProvider(
                      usuarioService.selectUsuario),
                  child: const _RegisterForm(),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final registerService = Provider.of<UsuarioActualizarFromProvider>(context);
    final registerForm = registerService.usuario;

    return SizedBox(
      width: size.width * 0.6,
      child: Form(
        key: registerService.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Container(
              height: size.height * 0.1,
              width: size.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: GestureDetector(
                  onTap: () {},
                  child: (registerForm.imagen == '')
                      ? const Image(
                          image: AssetImage('assets/no-image.png'),
                          fit: BoxFit.cover,
                        )
                      : getImage(registerForm.imagen),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: registerForm.email,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
              decoration: const InputDecoration(
                  hintText: 'user@gmail.com',
                  labelText: 'Correo electronico',
                  prefixIcon: Icon(Icons.alternate_email_rounded)),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'No es un correo';
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: registerForm.nombre,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  hintText: 'juan',
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person_outline_outlined)),
              onChanged: (value) => registerForm.nombre = value,
              validator: (value) {
                return (value != null && value.length >= 2)
                    ? null
                    : 'debe ser de 2 o mas caracteres';
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: registerForm.telefono,
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: '312....',
                  labelText: 'telefono',
                  prefixIcon: Icon(Icons.person_outline_outlined)),
              onChanged: (value) => registerForm.telefono = value,
              validator: (value) {
                return (value != null && value.length == 10)
                    ? null
                    : 'el numero lleva 10 digitos';
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: registerForm.barrio,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  hintText: 'Barrio obrero',
                  labelText: 'Barrio',
                  prefixIcon: Icon(Icons.directions)),
              onChanged: (value) => registerForm.barrio = value,
              validator: (value) {
                return (value != null && value.length >= 2)
                    ? null
                    : 'debe ser de 2 o mas caracteres';
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: registerForm.direccion,
              autocorrect: false,
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                  hintText: 'calle #',
                  labelText: 'direccion',
                  prefixIcon: Icon(Icons.directions)),
              onChanged: (value) => registerForm.direccion = value,
              validator: (value) {
                return (value != null && value.length >= 5)
                    ? null
                    : 'debe ser de 5 o mas caracteres';
              },
            ),
            const SizedBox(
              height: 40,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurpleAccent[400],
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                child: const Text(
                  'Actualizar',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              onPressed: registerService.isLoading
                  ? null
                  : () async {
                      final usuarioService =
                          Provider.of<UsuarioService>(context, listen: false);

                      if (!registerService.isValidForm()) return;

                      registerService.isLoading = true;

                      final String? messageRegistro =
                          await usuarioService.updateUser(Usuario(
                        email: registerForm.email,
                        nombre: registerForm.nombre,
                        telefono: registerForm.telefono,
                        barrio: registerForm.barrio,
                        direccion: registerForm.direccion,
                        imagen: registerForm.imagen,
                        id: registerForm.id,
                      ));
                      Navigator.pop(context, 'opcionesUser');
                      if (messageRegistro == null) {
                        print('todo correcto');
                      } else {
                        registerService.isLoading = false;
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

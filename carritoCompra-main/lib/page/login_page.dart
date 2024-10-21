import 'package:flutter/material.dart';
import 'package:loginapp/providers/login_form_provider.dart';
import 'package:loginapp/servicios/auth_service.dart';
import 'package:loginapp/servicios/usuario_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: size.height * 0.50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent[400],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45))),
            ),
            Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    width: size.width * 0.7,
                    height: size.height * 0.4,
                    child: const Image(
                      image: AssetImage('assets/loginPerson.png'),
                    ),
                  ),
                ),
                const Center(
                    child: Text(
                  'LOGIN ',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
                const SizedBox(
                  height: 35,
                ),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const _loginForm(),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, 'registrar'),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent[400]),
                    )),
                const SizedBox(height: 25)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _loginForm extends StatelessWidget {
  const _loginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginForm = Provider.of<LoginFormProvider>(context);

    return SizedBox(
        width: size.width * 0.8,
        child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'user@gmail.com',
                    labelText: 'Correo electronico',
                    prefixIcon: Icon(Icons.alternate_email_rounded)),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'no es un correo';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: '********',
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline_rounded)),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'Debe ser de 6 o mas carateres';
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                disabledColor: Colors.grey,
                color: Colors.deepPurpleAccent[400],
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        final usuario =
                            Provider.of<UsuarioService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        final String? message = await authService.login(
                            loginForm.email, loginForm.password);

                        if (message == null) {
                          await usuario.filtroUsuario(authService.correo);
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          displayDialog(
                              context,
                              'Usuario o contraseña incorrecto',
                              Icons.error,
                              Colors.red,
                              'Error');
                          loginForm.isLoading = false;
                        }
                      },
              )
            ],
          ),
        ));
  }

  void displayDialog(BuildContext context, String message, IconData icon,
      Color color, String titulo) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: Text(titulo),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(
                  height: 10,
                ),
                Icon(
                  icon,
                  color: color,
                  size: 60,
                ),
              ],
            ),
          );
        });
  }
}

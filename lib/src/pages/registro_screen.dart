import 'package:app_inspections/providers/login_form_provider.dart';
import 'package:app_inspections/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 280), //para mover el widget
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10), // Agregar márgenes horizontales
                child: SizedBox(
                  height: 700,
                  child: CardContainer(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Crear cuenta',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 70),
                        ChangeNotifierProvider(
                          create: (_) => LoginFormProvider(),
                          child: _LoginForm(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Colors.indigo.withOpacity(0.1),
                  ),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: const Text(
                  '¿Ya tienes una nueva cuenta?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formkey,
      child: Column(
        children: [
          const SizedBox(height: 30), //separar renglones

          TextFormField(
            // Configuraciones del cuadro de texto
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => loginForm.name = value,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Escribe tu nombre completo';
              }
              return null;
            },
            // Decoración del cuadro de texto
            decoration: InputDecoration(
              hintText: 'Nombre Completo',
              labelText: 'Nombre Completo',
              prefixIcon: const Icon(Icons.alternate_email_rounded),
              // Cambiar el color del borde del cuadro de texto
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(
                        169, 27, 96, 1)), // Cambia el color del borde aquí
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(
                        169, 27, 96, 1)), // Cambia el color del borde aquí
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),

          const SizedBox(height: 30), //separar renglones

          TextFormField(
            // Configuraciones del cuadro de texto
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => loginForm.usuario = value,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Escribe tu nombre completo';
              }
              return null;
            },
            // Decoración del cuadro de texto
            decoration: InputDecoration(
              hintText: 'Conexsa21',
              labelText: 'Nombre de Usuario',
              prefixIcon: const Icon(Icons.alternate_email_rounded),
              // Cambiar el color del borde del cuadro de texto
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(
                        169, 27, 96, 1)), // Cambia el color del borde aquí
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(
                        169, 27, 96, 1)), // Cambia el color del borde aquí
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),

          const SizedBox(height: 30), //separar renglones

          TextFormField(
            // Configuraciones del cuadro de texto
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            obscureText: true, //para ocultar la contraseña
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe de ser de 6 caracteres';
            },
            // Decoración del cuadro de texto
            decoration: InputDecoration(
              hintText: '***********',
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outlined),
              // Cambiar el color del borde del cuadro de texto
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(
                      169, 27, 96, 1), // Cambia el color del borde aquí
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(
                      169, 27, 96, 1), // Cambia el color del borde aquí
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),

          const SizedBox(height: 90),

          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromRGBO(6, 6, 68, 1),
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!loginForm.isValidForm()) return;
                      loginForm.isLoading = true;
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  )))
        ],
      ),
    );
  }
}

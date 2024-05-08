import 'package:flutter/material.dart';

class UserInsertion extends StatefulWidget {
  const UserInsertion({super.key});

  @override
  State<UserInsertion> createState() => _UserInsertionState();
}

class _UserInsertionState extends State<UserInsertion> {
  final _formKey = GlobalKey<FormState>();

  int idTiend = 0;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Limpia los controladores cuando el widget se elimina del árbol de widgets
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String nombreTienda = arguments['nombreTienda'];
    print('ID de tienda en InspeccionTienda: $nombreTienda');
    int idTiend = arguments['idTienda'];
    print('ID de tienda en InspeccionTienda: $idTiend');
    PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: const Size.fromHeight(120.0), // Define la altura deseada
      child: AppBar(
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        flexibleSpace: Container(
          alignment: Alignment.center, // Centra vertical y horizontalmente
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿QUIÉN REALIZARÁ LA INSPECCIÓN?',
                style: TextStyle(fontSize: 35, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              size: 40.0, color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'inicioInsp');
          },
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí puedes enviar los datos a tu backend o hacer lo que necesites con ellos
                    String nombre = _nombreController.text;
                    String correo = _correoController.text;
                    String password = _passwordController.text;

                    // Por ejemplo, imprimir los datos registrados
                    print('Nombre: $nombre');
                    print('Correo electrónico: $correo');
                    print('Contraseña: $password');

                    // Puedes agregar aquí la lógica para enviar los datos al backend
                  }
                  Navigator.pushNamed(
                    context,
                    'inspectienda',
                    arguments: {
                      'nombreTienda': nombreTienda,
                      'idTienda': idTiend,
                    },
                  );
                },
                child: const Text('Iniciar Inspección'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/src/pages/f1.dart';
import 'package:app_inspections/src/pages/inicio_indv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspeccionTienda extends StatefulWidget {
  final int initialTabIndex;
  final TabController? controller;

  const InspeccionTienda(
      {Key? key, required this.initialTabIndex, this.controller})
      : super(key: key);

  @override
  State<InspeccionTienda> createState() => _InspeccionTiendaState();
}

class _InspeccionTiendaState extends State<InspeccionTienda>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    // Obtén los datos de la tienda desde los argumentos
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String nombreTienda = arguments['nombreTienda'];
    int idTi = arguments['idTienda'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            // Puedes agregar código para manejar el evento de retroceso aquí
            Navigator.pushReplacementNamed(context, 'inicioInsp');
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        title: Text(
          nombreTienda,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: const Color.fromRGBO(169, 27, 96, 1),
          controller: controller,
          labelStyle: const TextStyle(fontSize: 20),
          unselectedLabelColor: Colors.white,
          unselectedLabelStyle: const TextStyle(fontSize: 20),
          tabs: const [
            Tab(
              child: SizedBox(
                // Especifica un ancho fijo para la pestaña "Inicio"
                width: 100,
                child: Row(
                  children: [
                    Text("Historial"),
                  ],
                ),
              ),
            ),
            Tab(
              child: SizedBox(
                // Especifica un ancho fijo para la pestaña "Registro"
                width: 100,
                child: Text("Registro"),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<PopupMenuEntry>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/inicio.png"),
                    ),
                    const SizedBox(
                        width: 10), // Espacio entre la imagen y el texto
                    Text(
                      ' ${authService.currentUser}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text("Cerrar Sesión"),
                onTap: () {
                  authService.logout();
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Inicio(
              idTienda: idTi,
              nomTienda: nombreTienda), // Aquí pasas el argumento a Inicio
          F1Screen(idTienda: idTi),
        ],
      ),
    );
  }
}

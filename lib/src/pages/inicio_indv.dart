import 'dart:async';

import 'package:app_inspections/models/reporte_model.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:app_inspections/src/pages/editar_form.dart';
import 'package:app_inspections/src/pages/reporteGeneral.dart';
import 'package:app_inspections/src/pages/reporte_F1.dart';
import 'package:app_inspections/src/pages/reporte_F2.dart';
import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  final int idTienda;
  final int initialTabIndex;
  final String nomTienda;

  const InicioScreen(
      {super.key,
      required this.idTienda,
      required this.initialTabIndex,
      required this.nomTienda});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Inicio(
        idTienda: idTienda,
        nomTienda: nomTienda,
      ),
    );
  }
}

class Inicio extends StatefulWidget {
  final int idTienda;
  final TabController? controller;
  final String nomTienda;

  const Inicio({
    super.key,
    required this.idTienda,
    this.controller,
    required this.nomTienda,
  });

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<Reporte> reporte = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> cargarReporte(int idTienda) async {
    List<Reporte> loadedTiendas =
        await DatabaseProvider.mostrarReporte(widget.idTienda);
    setState(() {
      reporte = loadedTiendas;
    });
  }

  Future<List<Reporte>> _filtrarReportes(
      List<Reporte> reportes, String searchText) async {
    if (searchText.isEmpty) {
      reportes = await DatabaseProvider.mostrarReporte(widget.idTienda);
      return reportes; // No hay texto de búsqueda, devuelve todos los reportes
    } else {
      // Filtra los reportes basados en el texto de búsqueda
      return reportes
          .where((reporte) => reporte.claveUbi
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    int idTiend = widget.idTienda;
    String nomTienda = widget.nomTienda;
    print("Tienda seleccionadaaa iniciooo $idTiend");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 45),
        child: Column(
          children: [
            Text('Historial', style: Theme.of(context).textTheme.headline4),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Buscar ubicación',
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: 'Search...',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 38,
                              129), // Color del borde cuando el campo de texto está enfocado
                          width:
                              1.0, // Ancho del borde cuando el campo de texto está enfocado
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: const BorderSide(
                          color: Colors
                              .grey, // Color del borde cuando el campo de texto está deshabilitado
                          width:
                              1.0, // Ancho del borde cuando el campo de texto está deshabilitado
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchText = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    FutureBuilder<List<Reporte>>(
                      future: DatabaseProvider.mostrarReporte(widget.idTienda),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Comprueba tu conexión a internet');
                        } else {
                          List<Reporte> reportes = snapshot.data!;

                          // Llamar a _filtrarReportes y esperar el resultado
                          return FutureBuilder<List<Reporte>>(
                            future: _filtrarReportes(reportes, _searchText),
                            builder: (context, filteredSnapshot) {
                              if (filteredSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (filteredSnapshot.hasError) {
                                return const Text(
                                    'Error al filtrar los reportes');
                              } else {
                                List<Reporte> filteredReportes =
                                    filteredSnapshot.data!;

                                // Construir el DataTable con los reportes filtrados
                                return SizedBox(
                                  width: 650.0,
                                  child: DataTable(
                                    horizontalMargin: 0,
                                    columnSpacing: 10,
                                    // ignore: deprecated_member_use
                                    dataRowHeight: 90,
                                    columns: const [
                                      DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            'Ubicación',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Departamento',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Problema',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Editar',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: filteredReportes.map((item) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(item.claveUbi!)),
                                          DataCell(Text(item.nomDep!)),
                                          DataCell(Text(
                                            item.nomProbl!,
                                            softWrap: true,
                                          )),
                                          DataCell(
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditarForm(
                                                      idTienda: idTiend,
                                                      data: item.toMap(),
                                                      nombreTienda: nomTienda,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Center(
                                                child: Icon(
                                                  Icons.mode_edit,
                                                  color: Color.fromRGBO(
                                                      6, 6, 68, 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(), // Convertir el Iterable a una lista
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReporteF1Screen(
                      idTienda: idTiend,
                      nomTienda: nomTienda,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(
                    6, 6, 68, 1), // Cambia el color del texto del botón
              ),
              child: const Text('Ver Reporte F1'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReporteF2Screen(
                      idTienda: idTiend,
                      nomTienda: nomTienda,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(
                    6, 6, 68, 1), // Cambia el color del texto del botón
              ),
              child: const Text('Ver Reporte F2'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReporteScreen(
                      idTienda: idTiend,
                      nomTienda: nomTienda,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(
                    6, 6, 68, 1), // Cambia el color del texto del botón
              ),
              child: const Text('Fixture y Mano de Obra'),
            ),
          ],
        ),
      ),
    );
  }
}

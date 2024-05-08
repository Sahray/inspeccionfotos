import 'package:app_inspections/models/tiendas.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:flutter/material.dart';

class TiendaSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar tienda';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Tiendas>>(
      future: DatabaseProvider.searchTiendas(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Revise su conexión a internet'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron tiendas'));
        }

        List<Tiendas> datos = snapshot.data!;

        return ListView.builder(
          itemCount: datos.length,
          itemBuilder: (context, index) {
            final dato = datos[index];
            int? idTiendaSeleccionada = dato.id;
            return ListTile(
              title: Text('${dato.codigo} ${dato.nombre}'),
              onTap: () {
                String nombreTiendaSeleccionada =
                    '${dato.codigo} ${dato.nombre}';

                Navigator.pushNamed(
                  context,
                  'inspectienda',
                  arguments: {
                    'nombreTienda': nombreTiendaSeleccionada,
                    'idTienda': idTiendaSeleccionada,
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Icon(
          Icons.construction_sharp,
          color: Color.fromARGB(174, 176, 176, 176),
          size: 100,
        ),
      );
    }
    return FutureBuilder<List<Tiendas>>(
      future: DatabaseProvider.searchTiendas(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Revise su conexión a internet'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron tiendas'));
        }

        List<Tiendas> datos = snapshot.data!;

        return ListView.builder(
          itemCount: datos.length,
          itemBuilder: (context, index) {
            final dato = datos[index];
            int? idTiendaSeleccionada = dato.id;
            return ListTile(
              title: Text('${dato.codigo} ${dato.nombre}'),
              onTap: () {
                String nombreTiendaSeleccionada =
                    '${dato.codigo} ${dato.nombre}';

                Navigator.pushNamed(
                  context,
                  'inspectienda',
                  arguments: {
                    'nombreTienda': nombreTiendaSeleccionada,
                    'idTienda': idTiendaSeleccionada,
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

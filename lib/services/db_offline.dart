import 'package:app_inspections/models/mano_obra.dart';
import 'package:app_inspections/models/materiales.dart';
import 'package:app_inspections/models/models.dart';
import 'package:app_inspections/models/problemas.dart';
import 'package:app_inspections/models/reporte_model.dart';
import 'package:app_inspections/models/usuarios.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Future<Database> openDB() async {
    return openDatabase(
        join(await getDatabasesPath(), 'conexsa.db'), //acceder a la bd
        onCreate: (db, version) async {
      //creación de la tabla problemas
      await db.execute(
          "CREATE TABLE problemas (id_probl INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom_probl TEXT, cod_probl TEXT, formato TEXT);");
      //creación de la tabla materiales
      await db.execute(
          "CREATE TABLE materiales (id_mat INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom_mat TEXT);");
      //creación de tabla mano de obra
      await db.execute(
          "CREATE TABLE obra (id_obra INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom_obra TEXT);");
      //creación de tabla tiendas
      await db.execute(
          "CREATE TABLE tiendas (id_tienda INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, cod_tienda INTEGER, nom_tienda TEXT, dist_tienda TEXT);");
      //creación de tabla usuariosA
      await db.execute(
          "CREATE TABLE usuarios (id_usu INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nombre TEXT NOT NULL, nom_usu TEXT NOT NULL, password TEXT NOT NULL);");
      //creación de tabla reporte
      await db.execute(
          "CREATE TABLE reporte (id_rep INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, formato TEXT NOT NULL, nom_dep TEXT NOT NULL, clave_ubi TEXT NOT NULL, id_probl INTEGER, nom_probl TEXT, id_mat INTEGER, nom_mat TEXT, otro TEXT, cant_mat INTEGER, id_obra INTEGER, nom_obr TEXT, otro_obr TEXT, cant_obr INTEGER, foto TEXT, dato_unico TEXT NOT NULL, insertion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, nom_user TEXT NOT NULL, last_updated DATETIME, id_tienda INTEGER NOT NULL,"
          "FOREIGN KEY (id_probl) REFERENCES problemas(id_probl),"
          "FOREIGN KEY (id_mat) REFERENCES materiales(id_mat),"
          "FOREIGN KEY (id_obra) REFERENCES obra(id_obra),"
          "FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda));");
    }, version: 1);
  }

  //método para insertar la lista de problemas
  static Future<Future<int>> insertProblem(Problemas problema) async {
    Database database = await openDB();

    return database.insert("problemas", problema.toMap());
  }

  //método para insertar la lista de materiales
  static Future<Future<int>> insertMaterial(Materiales material) async {
    Database database = await openDB();
    print("MATERIALES $material");

    return database.insert("materiales", material.toMap());
  }

  //método para insertar la lista de mano de obra
  static Future<Future<int>> insertManoObra(Obra obr) async {
    Database database = await openDB();

    return database.insert("obra", obr.toMap());
  }

  //método para insertar la lista de tiendas
  static Future<Future<int>> insertTiendas(Tiendas tienda) async {
    Database database = await openDB();

    return database.insert("tiendas", tienda.toMap());
  }

  //método para insertar la lista de usuarios
  static Future<Future<int>> insertUsuarios(Usuarios usuario) async {
    Database database = await openDB();

    return database.insert("usuarios", usuario.toMap());
  }

  //método para insertar los datos del form de reporte
  static Future<int> insertReporte(Reporte reporte) async {
    Database database = await openDB();

    print("SE INSERTO CORRECTAMENTE EL REPORTE $reporte");

    return database.insert("reporte", reporte.toMap());
  }

  //método para mostrar la lista de problemas para el form
  /* static Future<List<Problemas>> showProblemas() async {
    Database database = await openDB();
    try {
      final List<Map<String, dynamic>> results =
          await database.rawQuery('SELECT * FROM problemas');

      return results
          .map((row) => Problemas(
                id: row['id_probl'],
                nombre: row['nom_probl'],
                codigo: row['cod_probl'],
                formato: row['formato'],
              ))
          .toList();
    } catch (e) {
      print('Error al ejecutar la consulta: $e');
      return [];
    }
  } */

  static Future<List<Problemas>> showProblemas() async {
    Database database = await openDB();
    final List<Map<String, dynamic>> problemasMap =
        await database.query("problemas");

    return List.generate(
        problemasMap.length,
        (i) => Problemas(
            id: problemasMap[i]['id_probl'],
            nombre: problemasMap[i]['nom_probl'],
            codigo: problemasMap[i]['cod_probl'],
            formato: problemasMap[i]['formato']));
  }

  //método para mostrar la lista de materiales en el form
  static Future<List<Materiales>> showMateriales() async {
    Database database = await openDB();
    final List<Map<String, dynamic>> materialesMap =
        await database.query("materiales");

    return List.generate(
        materialesMap.length,
        (i) => Materiales(
            id: materialesMap[i]['id_mat'],
            nombre: materialesMap[i]['nom_mat']));
  }

  //método para mostrar la lista de mano de obra en el form
  static Future<List<Obra>> showObra() async {
    Database database = await openDB();
    final List<Map<String, dynamic>> obraMap = await database.query("obra");

    return List.generate(obraMap.length,
        (i) => Obra(id: obraMap[i]['id_obra'], nombre: obraMap[i]['nom_obra']));
  }

  //método para mostrar la lista de tiendas
  static Future<List<Tiendas>> showTiendas() async {
    Database database = await openDB();
    final List<Map<String, dynamic>> tiendasMap =
        await database.query("tiendas");
    return List.generate(
        tiendasMap.length,
        (i) => Tiendas(
            id: tiendasMap[i]['id_tienda'],
            codigo: tiendasMap[i]['cod_tienda'],
            nombre: tiendasMap[i]['nom_tienda'],
            distrito: tiendasMap[i]['dist_tienda']));
  }

  //método para mostrar los usuarios y verificar si existen sino para insertarlos
  static Future<List<Usuarios>> showUsers() async {
    Database database = await openDB();
    try {
      final List<Map<String, dynamic>> results =
          await database.rawQuery('SELECT * FROM usuarios');

      return results
          .map((row) => Usuarios(
                id: row['id_usu'],
                nombre: row['nombre'],
                nomUsu: row['nom_usu'],
                contrasena: row['password'],
              ))
          .toList();
    } catch (e) {
      print('Error al ejecutar la consulta: $e');
      return [];
    }
  }

  //método para buscar tiendas por nombre
  static Future<List<Tiendas>> searchTiendas(String query) async {
    Database database = await openDB();
    try {
      final List<Map<String, dynamic>> results = await database.rawQuery(
        'SELECT * FROM tiendas WHERE cod_tienda LIKE ? OR nom_tienda LIKE ?',
        ['%$query%', '%$query%'],
      );

      return results
          .map((row) => Tiendas(
                id: row['id_tienda'],
                codigo: row['cod_tienda'],
                nombre: row['nom_tienda'],
                distrito: row['dist_tienda'],
              ))
          .toList();
    } catch (e) {
      print('Error al ejecutar la consulta: $e');
      return [];
    }
  }

  static Future<List<Reporte>> mostrarReporte(int idtienda) async {
    Database database = await openDB();
    try {
      final List<Map<String, dynamic>> results = await database.rawQuery(
        'SELECT * FROM reporte WHERE id_tienda LIKE ?',
        ['%$idtienda%'],
      );
      //print('despues de la consulta');
      if (kDebugMode) {
        print('Resultados de la consulta: $results');
      }

      return results
          .map((row) => Reporte(
                formato: row['formato'],
                nomDep: row['nom_dep'],
                claveUbi: row['clave_ubi'],
                idProbl: row['id_probl'],
                nomProbl: row['nom_probl'],
                idMat: row['id_mat'],
                nomMat: row['nom_mat'],
                otro: row['otro'],
                cantMat: row['cant_mat'],
                idObr: row['id_obra'],
                nomObr: row['nom_obr'],
                otroObr: row['otro_obr'],
                cantObr: row['cant_obr'],
                foto: row['foto'],
                datoU: row['dato_unico'],
                nombUser: row['nom_user'],
                lastUpdated: row['last_updated'],
                idTienda: row['id_tienda'],
              ))
          .toList();
    } catch (e) {
      const Text('Comprueba tu conexión a internet');
      return [];
    } finally {
      try {
        await database.query('DEALLOCATE ALL');
        //await database.close();
      } catch (e) {
        if (kDebugMode) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  Future<List<Reporte>> mostrarReporteF1(int idtienda) async {
    Database database = await openDB();
    try {
      final List<Map<String, dynamic>> results = await database.rawQuery(
        "SELECT * FROM reporte WHERE id_tienda LIKE ? AND formato = 'F1'",
        ['%$idtienda%'],
      );
      //print('despues de la consulta');
      if (kDebugMode) {
        print('Resultados de la consulta: $results');
      }

      return results
          .map((row) => Reporte(
                formato: row['formato'],
                nomDep: row['nom_dep'],
                claveUbi: row['clave_ubi'],
                idProbl: row['id_probl'],
                nomProbl: row['nom_probl'],
                idMat: row['id_mat'],
                nomMat: row['nom_mat'],
                otro: row['otro'],
                cantMat: row['cant_mat'],
                idObr: row['id_obra'],
                nomObr: row['nom_obr'],
                otroObr: row['otro_obr'],
                cantObr: row['cant_obr'],
                foto: row['foto'],
                datoU: row['dato_unico'],
                nombUser: row['nom_user'],
                lastUpdated: row['lastUpdated'],
                idTienda: row['id_tienda'],
              ))
          .toList();
    } catch (e) {
      const Text('Comprueba tu conexión a internet');
      return [];
    } finally {
      try {
        await database.query('DEALLOCATE ALL');
        //await database.close();
      } catch (e) {
        if (kDebugMode) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  //vincular bd con postgre
  static Future<List<Reporte>> leerReportesDesdeSQLite() async {
    // Abrir la conexión a la base de datos SQLite
    Database database = await openDB();

    // Ejecutar una consulta para obtener los datos de la tabla 'reporte'
    final resultados = await database.query('reporte');

    // Mapear los resultados a objetos Reporte
    final reportes = resultados.map((row) => Reporte.fromMap(row)).toList();

    // Cerrar la conexión a la base de datos
    //await database.close();

    return reportes;
  }
}

import 'package:app_inspections/services/db_offline.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Usuarios {
  int? id;
  String nombre;
  String nomUsu;
  String contrasena;

  Usuarios(
      {required this.id,
      required this.nombre,
      required this.nomUsu,
      required this.contrasena});

  Map<String, dynamic> toMap() {
    return {
      'id_usu': id,
      'nombre': nombre,
      'nom_usu': nomUsu,
      'password': contrasena
    };
  }
}

void insertInitialDataUser() async {
  getDatabasesPath().then((databasePath) async {
    join(databasePath, 'conexsa.db');

    final List<Usuarios> usuarios = [
      Usuarios(
          id: null,
          nombre: 'Pablo Balbino Chavez',
          nomUsu: 'Pablo',
          contrasena: 'InsConex1'),
      Usuarios(
          id: null,
          nombre: 'Felipe Lopez Parra',
          nomUsu: 'Felipe',
          contrasena: 'InsConex2'),
      Usuarios(
          id: null,
          nombre: 'Francisco Javier Flores Gonzalez',
          nomUsu: 'Francisco',
          contrasena: 'InsConex3'),
      Usuarios(
          id: null,
          nombre: 'Ignacio Soria Ronquillo',
          nomUsu: 'Ignacio',
          contrasena: 'InsConex4'),
      Usuarios(
          id: null,
          nombre: 'Francisco Javier Flores Gonzalez',
          nomUsu: 'Francisco',
          contrasena: 'InsConex5'),
      Usuarios(
          id: null,
          nombre: 'Juan Jose Solis Bautista',
          nomUsu: 'Juanjo',
          contrasena: 'InsConex6'),
      Usuarios(
          id: null,
          nombre: 'Luis Enrique Garcia Dominguéz',
          nomUsu: 'Kike',
          contrasena: 'InsConex7'),
      Usuarios(
          id: null,
          nombre: 'Ximena García Carmona',
          nomUsu: 'Xime',
          contrasena: 'InsConex8'),
      Usuarios(
          id: null,
          nombre: 'Sahray Aguilar Ramirez',
          nomUsu: 'Sahray',
          contrasena: 'InsConex9'),
    ];

    final List<Usuarios> existingUsers = await DatabaseProvider.showUsers();
    if (existingUsers.isEmpty) {
      for (final usuario in usuarios) {
        DatabaseProvider.insertUsuarios(usuario);
      }
      print('DATOS INSERTADOS USUARIOS CORRECTAMENTE');
    } else {
      print(
          "LOS DATOS USUARIOS YA EXISTEN EN LA BD. NO SE VOLVERÁN A INSERTAR");
    }
  });
}

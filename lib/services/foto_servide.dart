import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sqflite/sqflite.dart';

class FirebaseStorageService {
  static Future<String?> uploadImage(File image) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      firebase_storage.SettableMetadata metadata =
          firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
      );

      await ref.putFile(image, metadata);
      String downloadURL = await ref.getDownloadURL();

      print('Imagen cargada exitosamente. URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error al cargar la imagen: $e');
      return null;
    }
  }

  static Future<void> deleteImage(String imageUrl) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      print('Imagen eliminada de Firebase Storage.');
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }
}

class LocalStorageService {
  // Función para guardar una imagen localmente en SQLite
  static Future<void> saveImageInDatabase(String imageUrl) async {
    final Database db = await openDatabase(
      'images_database.db',
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE images(id INTEGER PRIMARY KEY, imageUrl TEXT)',
        );
      },
      version: 1,
    );

    await db.insert(
      'images',
      {'imageUrl': imageUrl},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Imprimir mensaje de confirmación
    print('La imagen se ha guardado correctamente en la base de datos local.');
  }


  // Función para eliminar una imagen de la base de datos local
  static Future<void> deleteImageFromDatabase(String imageUrl) async {
    final Database db = await openDatabase('images_database.db');
    await db.delete('images', where: 'imageUrl = ?', whereArgs: [imageUrl]);
  }

  // Función para obtener todas las imágenes almacenadas localmente
  static Future<List<String>> getAllImagesFromDatabase() async {
    final Database db = await openDatabase('images_database.db');
    final List<Map<String, dynamic>> maps = await db.query('images');
    return List.generate(maps.length, (i) => maps[i]['imageUrl']);
  }
}

Future<void> syncImagesWithFirebaseStorage() async {//sincroniza las imágenes almacenadas localmente con Firebase Storage, eliminando las imágenes locales después de cargarlas correctamente en Firebase Storage.
  final List<String> localImageUrls = await LocalStorageService.getAllImagesFromDatabase();

  for (final imageUrl in localImageUrls) {
    // Verificar si hay conexión a Internet
    final bool isConnected = await hasInternetConnection();
    
    if (isConnected) {
      // Subir la imagen a Firebase Storage
      String? firebaseUrl = await FirebaseStorageService.uploadImage(File(imageUrl));
      
      if (firebaseUrl != null) {
        // Eliminar la imagen de la base de datos local después de una carga exitosa
        await LocalStorageService.deleteImageFromDatabase(imageUrl);
        
        // Imprimir el mensaje de confirmación
        print('La imagen con URL: $imageUrl ha sido subida a Firebase Storage y eliminada de la base de datos local.');
      } else {
        print('Hubo un error al subir la imagen con URL: $imageUrl a Firebase Storage.');
      }
    }
  }
}
// Función para verificar la conexión a Internet
Future<bool> hasInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
}
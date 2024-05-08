import 'dart:io';
import 'package:app_inspections/src/screens/photo_view_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFoto extends StatefulWidget {
  const HomeFoto({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeFotoState createState() => _HomeFotoState();
}

class _HomeFotoState extends State<HomeFoto> {
  int maxPhotos = 6; // Define el número máximo de fotos permitidas
  List<String> imageUrls = []; // Lista para almacenar las URLs de las imágenes
  List<XFile> images = [];
  // Declara una variable para almacenar la imagen seleccionada
  // ignore: unused_field
  XFile? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImageUrls(); // Carga las URLs de las imágenes guardadas al iniciar la pantalla
    _loadImages(); // Carga las imágenes al iniciar la pantalla
  }

  // Función para guardar la URL de la imagen en SharedPreferences
  Future<void> _saveImageUrl(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    imageUrls.add(imageUrl);
    await prefs.setStringList('imageUrls', imageUrls);
  }

  //FUNCION PARA CARGAR IMAGENES DESDE EL ALMACENAMIENTO LOCAL AL INICIAR LA APP
  Future<void> _loadImageUrls() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedUrls = prefs.getStringList('imageUrls');
      if (savedUrls != null) {
        setState(() {
          imageUrls = savedUrls;
        });
      }
    } catch (e) {
      print('Error al cargar URLs de imágenes: $e');
    }
  }

  //FUNCION PARA CARGAR IMAGENES DESDE EL ALMACENAMIENTO LOCAL AL INICIAR LA APP
  Future<void> _loadImages() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      List<XFile> loadedImages = [];
      List<FileSystemEntity> files = appDir.listSync();
      for (FileSystemEntity file in files) {
        if (file is File && file.path.endsWith('.jpg')) {
          // Solo carga archivos de imagen
          loadedImages.add(XFile(file.path));
        }
      }
      setState(() {
        images = loadedImages;
      });
    } catch (e) {
      print('Error al cargar imágenes: $e');
    }
  }

  //FUNCION PARA GUARDAR LAS IMAGENES EN EL ALMACENAMIENTO LOCAL
  Future<void> _uploadImage(XFile? image) async {
    if (image == null) {
      print('No se ha seleccionado ninguna imagen para subir.');
      return;
    }

    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch.toString()}');
      final firebase_storage.UploadTask uploadTask = storageRef.putFile(
        File(image.path),
        firebase_storage.SettableMetadata(
            contentType:
                'image/jpeg'), // Establece el tipo MIME como imagen/jpeg
      );
      await uploadTask.whenComplete(() async {
        String downloadURL = await storageRef.getDownloadURL();
        print('Imagen subida. URL de descarga: $downloadURL');

        // Guarda la imagen en el almacenamiento local
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String localImagePath =
            '${appDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(image.path).copy(localImagePath);

        // Guarda la URL de la imagen
        await _saveImageUrl(downloadURL);
      });
    } catch (e) {
      print('Error al subir la imagen: $e');
    }
  }

//FUNCION PARA GUARDAR LAS IMAGENES
  Future<void> _saveImages() async {
    try {
      // Lógica para guardar las imágenes (si es necesario)
      print('Guardando imágenes...');
      // Puedes agregar aquí la lógica para guardar las imágenes si es necesario
      print('Imágenes guardadas exitosamente.');
    } catch (e) {
      print('Error al guardar imágenes: $e');
    }
  }

//FUNCION PARA ELIMINAR IMAGENES LOCALES

  Future<void> _deleteImage(int index) async {
    try {
      File imageFile = File(images[index].path);

      // Elimina la imagen del almacenamiento local
      await imageFile.delete();

      // Actualiza la lista de imágenes después de la eliminación
      setState(() {
        images.removeAt(index);
      });

      // Elimina la imagen de Firebase Storage si es necesario
      if (index < imageUrls.length) {
        if (await _isValidImageUrl(imageUrls[index])) {
          await _deleteImageFromFirebaseStorage(imageUrls[index]);
        } else {
          print('La URL de la imagen no es válida: ${imageUrls[index]}');
        }
      }

      // Elimina la URL de la lista de URLs en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        imageUrls.removeAt(index);
      });
      await prefs.setStringList('imageUrls', imageUrls);
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }

  //FUNCION PARA ELIMINAR DESDE LA BASE DE DATOS
  Future<void> _deleteImageFromFirebaseStorage(String imageUrl) async {
    try {
      print('Intentando eliminar imagen de Firebase Storage: $imageUrl');

      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();
      print('Imagen eliminada de Firebase Storage: $imageUrl');

      // Elimina la URL de la lista de URLs en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        imageUrls.remove(imageUrl);
      });
      await prefs.setStringList('imageUrls', imageUrls);

      // Elimina la URL de la lista de imágenes si existe
      int index = images.indexWhere((image) => image.path == imageUrl);
      if (index != -1) {
        setState(() {
          images.removeAt(index);
        });
      }
    } on firebase_storage.FirebaseException catch (e) {
      print('Error al eliminar la imagen de Firebase Storage: ${e.code}');
      print('Mensaje de error: ${e.message}');
    } catch (e) {
      print('Otro error al eliminar la imagen de Firebase Storage: $e');
    }
  }

//FUNCION PARA VERIFICAR SI LAS URL ALMACENADAS SON VALIDAS Y CORRESPONDEN   A OBJETOS EXISTENTES EN LA BASE
  Future<bool> _isValidImageUrl(String imageUrl) async {
    try {
      // Intenta obtener la referencia de la imagen en Firebase Storage
      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      // Intenta obtener la URL de descarga del objeto
      await storageRef.getDownloadURL();
      // Si no se produce ninguna excepción, la URL es válida
      return true;
    } catch (e) {
      // Si ocurre un error al obtener la referencia o la URL de descarga, la URL no es válida
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            // Navegar a F1Screen cuando se presiona el botón
            Navigator.of(context).pop();
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Evidencias',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        toolbarHeight: 110.0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(40),
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          File imageFile = File(images[index].path);
          return Column(
            children: [
              InkWell(
                child: Row(
                  children: [
                    Expanded(
                      child: Image.file(imageFile),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Elimina la imagen
                        _deleteImage(index);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoViewScreen(
                        imageFile: imageFile,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 11), // Espacio entre cada foto
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _optionsDialogBox,
        child: const Icon(Icons.camera),
      ),
      persistentFooterButtons: [
        _buildSaveButton(), // Agrega el botón de guardar al pie de la pantalla
      ],
    );
  }

  //FUNCION PARA MOSTRAR UN MENSAJE DE IMAGEN GUARDADA
  // Método para mostrar el SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duración del SnackBar en segundos
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Reducir el relleno vertical
      child: MaterialButton(
        onPressed: _saveImages,
        color: const Color.fromRGBO(6, 6, 68, 1),
        elevation: 2, // Agregar elevación para un aspecto más realista
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Hacer el botón más redondo
        ),
        child: const Text(
          'Guardar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0, // Reducir el tamaño de la fuente
          ),
        ),
      ),
    );
  }

  Future<void> _optionsDialogBox() async {
    if (images.length >= maxPhotos) {
      // Si ya se han tomado el máximo número de fotos, muestra un mensaje y retorna
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Límite alcanzado'),
            content: const Text(
                'Ya has tomado el máximo número de fotos permitidas.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Si no se ha alcanzado el límite, permite tomar una foto normalmente
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Tomar fotografía'),
                  onTap: () async {
                    Navigator.pop(context);
                    XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      setState(() {
                        _image = image;
                        images.add(image);
                      });
                      await _uploadImage(image);
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
              ],
            ),
          ),
        );
      },
    );
  }
}

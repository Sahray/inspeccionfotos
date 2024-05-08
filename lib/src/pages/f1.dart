import 'dart:async';
import 'dart:io';

import 'package:app_inspections/models/mano_obra.dart';
import 'package:app_inspections/models/materiales.dart';
import 'package:app_inspections/models/problemas.dart';
import 'package:app_inspections/models/reporte_model.dart';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:app_inspections/services/foto_servide.dart';
import 'package:app_inspections/services/functions.dart';
import 'package:app_inspections/src/pages/utils/check_internet_connection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'; //permiso para abrir la camara
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class F1Screen extends StatelessWidget {
  final int idTienda;

  const F1Screen({
    super.key,
    required this.idTienda,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyForm(
        idTienda: idTienda,
        context: context,
      ),
    );
  }
}

// ignore: must_be_immutable
class MyForm extends StatefulWidget {
  final int idTienda;
  final BuildContext context;

  MyForm({super.key, required this.idTienda, required this.context});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MyFormState createState() =>
      // ignore: no_logic_in_create_state
      _MyFormState(idTienda: idTienda, context: context);

  List<XFile> images = [];
}

void main() async {
  File imageFile = File('path/to/your/image.jpg');

  // Subir imagen
  String? imageUrl = await FirebaseStorageService.uploadImage(imageFile);

  if (imageUrl != null) {
    // Hacer algo con la URL de la imagen, como guardarla en la base de datos

    // Eliminar la imagen de Firebase Storage
    await FirebaseStorageService.deleteImage(imageUrl);
  }
}

class _MyFormState extends State<MyForm> {
  //verificar la conexion a internet
  late final CheckInternetConnection _internetConnection;
  late StreamSubscription<ConnectionStatus> _connectionSubscription;
  ConnectionStatus _currentStatus = ConnectionStatus.online;

  List<Materiales> materiales = [];
  List<Problemas> problemas = [];
  List<Obra> obra = [];

  final int idTienda;
  @override
  final BuildContext context;
  //bool _isButtonDisabled = true;
  List<Map<String, dynamic>> datosIngresados = [];
  List<XFile> images = [];
  int maxPhotos = 6;

  cargaProblemas() async {
    List<Problemas> auxProblema = await DatabaseProvider.showProblemas();

    setState(() {
      problemas = auxProblema;
    });
  }

  //Campos de mi formulario
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _idproblController = TextEditingController();
  final TextEditingController _idmatController = TextEditingController();
  final TextEditingController _cantmatController = TextEditingController();
  final TextEditingController _idobraController = TextEditingController();
  final TextEditingController _cantobraController = TextEditingController();
  final TextEditingController _otroMPController = TextEditingController();
  final TextEditingController _otroObraController = TextEditingController();

  int idTiend = 0;
  int idProbl = 0;
  int idMat = 0;
  int idObra = 0;
  String selectedFormato = "F1";
  bool isGuardarHabilitado = false;
  String? nomUser = "";

  String formato = "";

  List<String> problemasEscritos = [];
  List<String> materialesEscritos = [];
  List<String> obrasEscritas = [];

  _MyFormState({required this.idTienda, required this.context});

  //Desactivar campos
  final FocusNode _focusNodeProbl = FocusNode();
  final FocusNode _focusNodeMat = FocusNode();
  final FocusNode _focusNodeObr = FocusNode();
  final FocusNode _cantidadFocus = FocusNode();
  final FocusNode _focusOtO = FocusNode();

  @override
  void initState() {
    super.initState();
    _internetConnection = CheckInternetConnection();
    _connectionSubscription =
        _internetConnection.internetStatus().listen((status) {
      setState(() {
        _currentStatus = status;
      });
    });
    cargaProblemas();
    _focusNodeProbl.addListener(() {
      if (!_focusNodeProbl.hasFocus) {
        setState(() {
          // Oculta la lista cuando el campo pierde el foco
          showListProblemas = false;
        });
      }
    });
    _focusNodeMat.addListener(() {
      if (!_focusNodeMat.hasFocus) {
        setState(() {
          // Oculta la lista cuando el campo pierde el foco
          showListMaterial = false;
        });
      }
    });
    _focusNodeObr.addListener(() {
      if (!_focusNodeObr.hasFocus) {
        setState(() {
          // Oculta la lista cuando el campo pierde el foco
          showListObra = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    _internetConnection.close();
    super.dispose();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String imagePaths = ""; // Lista para almacenar las rutas de las imágenes

  final TextEditingController _textEditingControllerProblema =
      TextEditingController();
  bool showListProblemas = false;
  List<String> opcionesProblemas = [];
  List<String> filteredOptionsProblema = [];
  bool isProblemSelected = false;

  final TextEditingController _textEditingControllerMaterial =
      TextEditingController();
  bool showListMaterial = false;
  List<String> opcionesMaterial = [];
  List<String> filteredOptionsMaterial = [];
  bool isMaterialSelected = false;

  final TextEditingController _textEditingControllerObra =
      TextEditingController();
  bool showListObra = false;
  List<String> opcionesObra = [];
  List<String> filteredOptionsObra = [];
  bool isObraSelected = false;
  List<String?> imageUrls = []; //se almacenan todas las imagenes

  //FUNCION PARA  TOMAR LA FOTO
  Future<void> _getImage() async {
    if (images.length >= maxPhotos) {
      // Mostrar ventana emergente cuando se excede el límite de fotos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Límite de fotos alcanzado'),
            content: Text('No puedes agregar más de $maxPhotos fotos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar ventana emergente
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Salir del método si se alcanza el límite de fotos
    }
     // Solicitar permiso para acceder a la cámara
  var cameraPermissionStatus = await Permission.camera.request();
  if (cameraPermissionStatus != PermissionStatus.granted) {
    // El usuario denegó el permiso de la cámara, mostrar un mensaje o realizar una acción apropiada
    return;
  }

   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    setState(() {
      images.add(image); // Añade la imagen inmediatamente a la UI
    });
    String? imageUrl = await FirebaseStorageService.uploadImage(File(image.path));
    if (imageUrl != null) {
      storeImageUrl(imageUrl); // Guardar URL de imagen
      print('La imagen se ha subido a la base de datos de Postgre.');
    }
  }
}
  void _deleteImage(int index) async {
    String imageUrl =
        await getImageUrlFromPrefs(index); // Implementar esta función

    // Eliminar de Firebase Storage
    await FirebaseStorageService.deleteImage(imageUrl);

    // Eliminar del almacenamiento local
    await LocalStorageService.deleteImageFromDatabase(images[index].path);

    setState(() {
      images.removeAt(index);
      removeImageUrlFromPrefs(index); // Implementar esta función
    });
  }

  void storeImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedUrls = prefs.getStringList('imageUrls') ?? [];
    storedUrls.add(url);
    await prefs.setStringList('imageUrls', storedUrls);
  }

  Future<String> getImageUrlFromPrefs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedUrls = prefs.getStringList('imageUrls') ?? [];
    return storedUrls[index];
  }

  void removeImageUrlFromPrefs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedUrls = prefs.getStringList('imageUrls') ?? [];
    storedUrls.removeAt(index);
    await prefs.setStringList('imageUrls', storedUrls);
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar imagen'),
          content: Text('¿Estás seguro de que quieres eliminar esta imagen?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteImage(index); // Proceder a eliminar la imagen
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarFotoEnGrande(XFile image, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          // Establecer el color de fondo transparente
          child: Stack(
            children: [
              PhotoView(
                imageProvider: FileImage(File(image.path)),
                backgroundDecoration: BoxDecoration(
                  color: Colors
                      .transparent, // Establece el color de fondo transparente
                ),
                loadingBuilder: (context, event) {
                  if (event == null || event.expectedTotalBytes == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: event.cumulativeBytesLoaded /
                          event.expectedTotalBytes!,
                    ),
                  );
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child:
                        const Icon(Icons.cancel_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThumbnailWithCancel(XFile image, int index) {
    return GestureDetector(
      onTap: () {
        _mostrarFotoEnGrande(image, index);
      },
      child: Stack(
        children: [
          ClipRect(
            child: Align(
              alignment: Alignment.topLeft,
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Image.file(
                File(image.path),
                width: 100,
                height: 70,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                // Editar imagen
                //_replaceImage(index);
              },
              child: const Icon(Icons.edit),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                _showDeleteConfirmation(context,
                    index); // Llama a la confirmación antes de eliminar
              },
              child: const Icon(Icons.cancel_rounded),
            ),
          ),
        ],
      ),
    );
  }

  void handleSelectionMaterial(
      String selectedOptionMaterial, int idMaterialSeleccionado) {
    setState(() {
      _textEditingControllerMaterial.text = selectedOptionMaterial;
      showListMaterial = false; // Ocultar la lista después de la selección
      isMaterialSelected = true;
      _idmatController.text = idMat.toString();
      idMat = idMaterialSeleccionado;
    });
  }

  void handleSelectionProblem(String selectedOptionProblem,
      int idProblemaSeleccionado, String textoFormato) {
    setState(() {
      _textEditingControllerProblema.text = selectedOptionProblem;
      showListProblemas = false;
      isProblemSelected = true;
      _idproblController.text = idProbl.toString();
      idProbl = idProblemaSeleccionado;
      formato = textoFormato;
    });
  }

  void handleSelectionObra(String selectedOptionObra, int idObraSeleccionado) {
    setState(() {
      _textEditingControllerObra.text = selectedOptionObra;
      showListObra = false; // Ocultar la lista después de la selección
      isObraSelected = true;
      _idobraController.text = idObra.toString();
      idObra = idObraSeleccionado;
    });
  }

  // Función para generar un ID único que aumenta en uno cada vez
  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  // Función para guardar datos con confirmación
  void guardarDatosConConfirmacion(BuildContext context) async {
    bool confirmacion = await mostrarDialogoConfirmacion(context);
    if (confirmacion == true) {
      // Ejecutar la función _guardarDatos si el usuario acepta
      _guardarDatos();
    } else {
      // No hacer nada si el usuario  cancela
    }
  }

  /*  void _guardarImagenEnBD(File imageURL) {
    setState(() {
      // Asigna la URL de la imagen a una variable de estado para su uso en el formulario
      _urlImagenSeleccionada = imageURL;
    });
    print("URL D ELA IMAGEEEN $_urlImagenSeleccionada");
  } */
  //

  void _guardarDatos() {
    if (formKey.currentState!.validate()) {
      try {
        String valorDepartamento = _departamentoController.text;
        String valorUbicacion = _ubicacionController.text;
        String nomProbl = _textEditingControllerProblema.text;
        String nomMat = _textEditingControllerMaterial.text;
        String nomObra = _textEditingControllerObra.text;
        String otro = _otroMPController.text;
        String otroO = _otroObraController.text;
        String cantidadM = _cantmatController.text;
        String cantidadO = _cantobraController.text;
        int cantM = 0;
        int cantO = 0;
        List<String?> fotos = [];
        String datoUnico = generateUniqueId();

        for (final datos in datosIngresados) {
          // Usar un valor predeterminado si el valor es nulo

          formato = datos['Formato'] ?? '';
          valorDepartamento = datos['Departamento'] ?? '';
          valorUbicacion = datos['Ubicacion'] ?? '';
          idProbl = datos['ID_Problema'] ?? 0;
          nomProbl = datos['Problema'] ?? '';
          idMat = datos['ID_Material'] ?? 0;
          nomMat = datos['Material'] ?? '';
          otro = datos['Otro'] ?? 0;
          cantidadM = datos['Cantidad_Material'] ?? '';
          idObra = datos['ID_Obra'] ?? 0;
          nomObra = datos['Obra'] ?? '';
          otroO = datos['Otro_Obr'] ?? 0;
          cantidadO = datos['Cantidad_Obra'] ?? ' ';
          fotos = datos['Foto'] ?? 0;
          String fotosString = fotos.join(
              ','); // Concatenar las URLs de las fotos en una sola cadena separada por comas

          if (cantidadM.isNotEmpty) {
            cantM = int.tryParse(cantidadM) ?? 0;
          }

          if (cantidadO.isNotEmpty) {
            cantO = int.tryParse(cantidadO) ?? 0;
          }

          Reporte nuevoReporte = Reporte(
            formato: formato,
            nomDep: valorDepartamento,
            claveUbi: valorUbicacion,
            idProbl: idProbl,
            nomProbl: nomProbl,
            idMat: idMat,
            nomMat: nomMat,
            otro: otro,
            cantMat: cantM,
            idObr: idObra,
            nomObr: nomObra,
            otroObr: otroO,
            cantObr: cantO,
            foto: imagePaths, // Debes manejar la lógica para las fotos aquí
            datoU: datoUnico,
            nombUser: nomUser!, // Aquí debes establecer el nombre del usuario
            lastUpdated: DateTime.now().toIso8601String(),
            idTienda: idTiend, // Aquí debes establecer el ID de la tienda
          );

          print("DATOS DEL ARREGLO");
          print("FORMATO $formato");
          print("DEPARTAMENTO $valorDepartamento");
          print("UBICACION $valorUbicacion");
          print("ID PROBLEMA $idProbl");
          print("NOMBRE PROBLEMA $nomProbl");
          print("ID MATERIAL $idMat");
          print("NOMBRE MATERIAL $nomMat");
          print("OTRO MATERIAL $otro");
          print("CANTIDAD MATERIAL $cantM");
          print("ID OBRA $idObra");
          print("NOMBRE OBRA $nomObra");
          print("OTRO MANO DE OBRA $otroO");
          print("CANTIDAD MANO OBRA $cantO");
          print("DATO UNICO PARA REFERENCIAR $datoUnico");
          print("FOTO $imagePaths");
          print("USUARIO $nomUser");
          print("ID TIENDA $idTiend");

          DatabaseProvider.insertReporte(nuevoReporte);

          /* DatabaseHelper.insertarReporte(
            formato, 
            valorDepartamento,
            valorUbicacion, 
            idProbl,
            nomProbl,
            idMat,
            nomMat,
            otro,
            cantM,
            idObra,
            nomObra,
            otroO, 
            cantO,
            fotos,
            datoUnico,
            nomUser!,
            idTiend,
          ); */

          //DatabaseProvider.insertReporte(datos);
        }

        /* DatabaseHelper.insertarImagenes(fotos, datoUnico, idTiend); */

        _save();
        datosIngresados.clear();
        images.clear();
      } catch (e) {
        // Manejo de errores
        print('Error al insertar el reporte: $e');
        // Puedes mostrar un mensaje de error al usuario si lo deseas
      }
    }
  }

  // Método para eliminar un dato
  void eliminarDato(int index) {
    setState(() {
      datosIngresados.removeAt(index);
    });
  }

  void _preguardarDatos() {
    setState(() {
      isGuardarHabilitado = true;
    });
    if (formKey.currentState!.validate()) {
      // Obtener los datos ingresados por el usuario
      String valorDepartamento = _departamentoController.text;
      String valorUbicacion = _ubicacionController.text;
      String valorCanMate = _cantmatController.text;
      String valorCanObra = _cantobraController.text;
      String nomProbl = _textEditingControllerProblema.text;
      String nomMat = _textEditingControllerMaterial.text;
      String nomObra = _textEditingControllerObra.text;
      String otro = _otroMPController.text;
      String otroO = _otroObraController.text;
      List<String?> fotos = [];
      fotos = imageUrls;
      // Agregar los datos a la lista
      datosIngresados.add({
        'Formato': formato,
        'Departamento': valorDepartamento,
        'Ubicacion': valorUbicacion,
        'ID_Problema': idProbl,
        'Problema': nomProbl,
        'ID_Material': idMat,
        'Material': nomMat,
        'Otro': otro,
        'Cantidad_Material': valorCanMate,
        'ID_Obra': idObra,
        'Obra': nomObra,
        'Otro_Obr': otroO,
        'Cantidad_Obra': valorCanObra,
        'Foto': fotos,
      });
      // Crear una lista para almacenar los nombres de los campos vacíos
      List<String> camposVacios = [];

      // Verificar que los campos no estén vacíos
      if (valorDepartamento.isEmpty) camposVacios.add('Departamento');
      if (valorUbicacion.isEmpty) camposVacios.add('Ubicación');
      if (nomObra.isEmpty) camposVacios.add('Mano de Obra');

      if (camposVacios.isNotEmpty) {
        // Construir el mensaje de alerta con los campos vacíos
        String mensaje = 'Por favor completa los siguientes campos:\n';
        mensaje += camposVacios.join(', ');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Campos vacíos'),
              content: Text(mensaje),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
        return; // Salir del método sin guardar los datos
      }
      _save();
    }
  }

  void _save() {
    setState(() {
      _textEditingControllerMaterial.clear();
      isMaterialSelected = false;
      showListMaterial = false;
      _textEditingControllerProblema.clear();
      isProblemSelected = false;
      showListProblemas = false;
      _textEditingControllerObra.clear();
      isObraSelected = false;
      showListObra = false;
      _cantidadFocus.unfocus();
      _departamentoController.clear();
      _ubicacionController.clear();
      _cantmatController.clear();
      _cantobraController.clear();
      _otroMPController.clear();
      _otroObraController.clear();
      formato = "";
      _focusNodeObr.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    idTiend = idTienda;
    List<Problemas> resultadosP = [];
    List<Materiales> resultadosM = [];
    List<Obra> resultadosO = [];
    final authService = Provider.of<AuthService>(context, listen: false);
    nomUser = authService.currentUser;
    //print("usuariooo $nomUser");

    //comparar si se activa la seccion de mano de obra
    String problema = _textEditingControllerProblema.text.toLowerCase();
    bool contieneTornillo = problema.contains('tornillo');
    //generar lista de problemas que no llevan foto para activar los demas campos
    //en la bd el campo foto no debe ser requerido, puede ir nulo, configurarlo
    bool masDeUnaFoto = images.length > 1;

    bool activarCampos = contieneTornillo || masDeUnaFoto;
    // if (_currentStatus == ConnectionStatus.offline) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Registro de Inspección',
                    style: Theme.of(context).textTheme.headlineMedium),
                DropdownButtonFormField(
                  value: selectedFormato,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFormato = newValue!;
                    });
                  },
                  items: <String>['F1', 'F2']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                      labelText:
                          'Selecciona el formato de tu defecto (F1 o F2)'),
                ),
                TextFormField(
                  controller: _departamentoController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Departamento'),
                  validator: (value) {
                    if (_departamentoController.text.isEmpty &&
                        _departamentoController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ubicacionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      const InputDecoration(labelText: 'Ubicación (Bahia)'),
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_ubicacionController.text.isEmpty &&
                        _ubicacionController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  focusNode: _focusNodeProbl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerProblema,
                  onChanged: (String value) async {
                    resultadosP = await DatabaseProvider.showProblemas();
                    idProbl = 0;
                    setState(() {
                      showListProblemas = value.isNotEmpty;
                      // Utiliza la variable resultados directamente
                      filteredOptionsProblema = resultadosP
                          .where((opcion) =>
                              opcion.codigo
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              opcion.nombre
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        // Establecer como null por defecto
                        if (showListProblemas) {
                          idProbl = opcion.id!;
                          formato = opcion.formato;
                          print("formato de la seleccion $formato");
                        }

                        String textoProblema = opcion.nombre;
                        print("problema $textoProblema");
                        return '$textoProblema|id:$idProbl|formato:$formato';
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Escribe o selecciona un defecto',
                    suffixIcon: _textEditingControllerProblema.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _textEditingControllerProblema.clear();
                                isProblemSelected = false;
                                showListProblemas =
                                    true; // Muestra la lista nuevamente al eliminar la opción
                                print("VISIBILIDAD ONE $showListProblemas");
                              });
                            },
                          )
                        : null,
                  ),
                  readOnly: isProblemSelected,
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_textEditingControllerProblema.text.isEmpty &&
                        _textEditingControllerProblema.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                if (showListProblemas)
                  Visibility(
                    visible:
                        showListProblemas && filteredOptionsProblema.isNotEmpty,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredOptionsProblema.length,
                        itemBuilder: (context, i) {
                          print("VISIBILIDAD $showListProblemas");
                          // Divide el texto del problema y el ID del problema
                          List<String> partes =
                              filteredOptionsProblema[i].split('|');
                          print("PARTES DE LA SELECCIÓN $partes");
                          String textoProblema = partes[0];
                          int idProblema = int.parse(
                              partes[1].substring(3)); // Para eliminar 'id:'
                          String textoFormato = partes[2]
                              .substring(8); // Para eliminar 'formato:'
                          return ListTile(
                            title: Text(textoProblema),
                            onTap: () {
                              int idProblemaSeleccionado = idProblema;
                              print("ID PROBLEMA $idProblemaSeleccionado");
                              handleSelectionProblem(textoProblema,
                                  idProblemaSeleccionado, textoFormato);
                              showListProblemas = false;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                /* Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AgregarProblema(); // Aquí creas una instancia de tu pantalla AgregarProblema
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar nuevo defecto'),
                      ),
                    ),
                  ],
                ), */
                TextFormField(
                  focusNode: _focusNodeMat,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerMaterial,
                  onChanged: (String value) async {
                    resultadosM = await DatabaseProvider.showMateriales();
                    idMat = 0;
                    setState(() {
                      showListMaterial = value.isNotEmpty;
                      // Utiliza la variable resultados directamente
                      filteredOptionsMaterial = resultadosM
                          .where((opcion) => opcion.nombre
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        if (showListMaterial) {
                          idMat = opcion.id!;
                        }
                        // Retorna el texto para mostrar en la lista
                        String textoMaterial = opcion.nombre;
                        return '$textoMaterial|id:$idMat';
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Escribe o selecciona un material',
                    suffixIcon: _textEditingControllerMaterial.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _textEditingControllerMaterial.clear();
                                isMaterialSelected = false;
                                showListMaterial = true;
                              });
                            },
                          )
                        : null,
                  ),
                  readOnly: isMaterialSelected,
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_textEditingControllerMaterial.text.isEmpty &&
                        _textEditingControllerMaterial.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                if (showListMaterial)
                  Visibility(
                    visible:
                        showListMaterial && filteredOptionsMaterial.isNotEmpty,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredOptionsMaterial.length,
                        itemBuilder: (context, index) {
                          // Divide el texto del problema y el ID del problema
                          List<String> partes =
                              filteredOptionsMaterial[index].split('|id:');
                          String textoMaterial = partes[0];
                          int idMaterial = int.parse(partes[1]);
                          print("MATERIALESS $partes");
                          return ListTile(
                            title: Text(textoMaterial),
                            onTap: () {
                              // Puedes acceder al ID del problema seleccionado aquí
                              int idMaterialSeleccionado = idMaterial;
                              handleSelectionMaterial(
                                  textoMaterial, idMaterialSeleccionado);
                              showListMaterial = false;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _otroMPController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      const InputDecoration(labelText: 'Especifique otro'),
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_otroMPController.text.isEmpty &&
                        _otroMPController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _cantmatController,
                  decoration:
                      const InputDecoration(labelText: 'Cantidad de Material'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_cantmatController.text.isEmpty &&
                        _cantmatController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Fotos',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return buildThumbnailWithCancel(images[index],
                          index); // Usa la función para construir miniaturas con botón de cancelar
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _getImage, // Llama a la función para agregar una imagen
                      child: const Icon(Icons
                          .camera_alt_outlined), // Icono para agregar imagen
                    ),
                  ],
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Aquí se llama a la función para tomar fotos
                          await _getImage();
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Tomar fotografía'),
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(
                  height: 30,
                ),
                const Text('Mano de Obra',
                    style: TextStyle(
                      fontSize: 25,
                    )),
                /* Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddMaterial(); // Aquí creas una instancia de tu pantalla AgregarProblema
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar nuevo material'),
                      ),
                    ),
                  ],
                ), */
                TextFormField(
                  focusNode: _focusNodeObr,
                  enabled: activarCampos,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerObra,
                  onChanged: (String value) async {
                    resultadosO = await DatabaseProvider.showObra();
                    idObra = 0;
                    setState(() {
                      showListObra = value.isNotEmpty;
                      filteredOptionsObra = resultadosO
                          .where((opcion) => opcion.nombre
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        if (showListObra) {
                          idObra = opcion.id!;
                        }
                        // Retorna el texto para mostrar en la lista
                        String textoObra = opcion.nombre;
                        return '$textoObra|id:$idObra';
                      }).toList();
                    });
                  },

                  //readOnly: true, no editar el texto
                  decoration: InputDecoration(
                    labelText: 'Escribe o selecciona un dato',
                    suffixIcon: _textEditingControllerObra.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _textEditingControllerObra.clear();
                                isObraSelected = false;
                                showListObra = true;
                              });
                            },
                          )
                        : null,
                  ),
                  readOnly: isObraSelected,
                  validator: (value) {
                    if (_textEditingControllerObra.text.isEmpty &&
                        _textEditingControllerObra.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                if (showListObra)
                  Visibility(
                    visible: showListObra && filteredOptionsObra.isNotEmpty,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredOptionsObra.length,
                        itemBuilder: (context, index) {
                          // Divide el texto del problema y el ID del problema
                          List<String> partes =
                              filteredOptionsObra[index].split('|id:');
                          String textoObra = partes[0];
                          int idObra = int.parse(partes[1]);
                          return ListTile(
                            title: Text(textoObra),
                            onTap: () {
                              // Puedes acceder al ID del problema seleccionado aquí
                              int idObraSeleccionado = idObra;
                              handleSelectionObra(
                                  textoObra, idObraSeleccionado);
                              showListObra = false;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                TextFormField(
                  focusNode: _focusOtO,
                  enabled: activarCampos,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _otroObraController,
                  decoration: const InputDecoration(
                      labelText: 'Especifique otro (Mano de Obra)'),
                  validator: (value) {
                    if (_otroObraController.text.isEmpty &&
                        _otroObraController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: _cantidadFocus,
                  enabled: activarCampos,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _cantobraController,
                  decoration: const InputDecoration(
                      labelText: 'Cantidad de Material para Mano de Obra'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (_cantobraController.text.isEmpty &&
                        _cantobraController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),

                /* Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ManoObra();
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label:
                            const Text('Agregar descripción de mano de obra'),
                      ),
                    ),
                  ],
                ), */
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _preguardarDatos,
                  key: null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(
                      6,
                      6,
                      68,
                      1,
                    ),
                  ),
                  child: const Text('Guardar'),
                ),
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16.0,
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Departamento')),
                      DataColumn(label: Text('Ubicación')),
                      DataColumn(label: Text('Problema')),
                      DataColumn(label: Text('Material')),
                      DataColumn(label: Text('Cantidad Material')),
                      DataColumn(label: Text('Mano de Obra')),
                      DataColumn(label: Text('Cantidad Mano de Obra')),

                      // Agregar una columna adicional para los botones de acción (editar, eliminar)
                      DataColumn(label: Text('Eliminar')),
                    ],
                    rows: datosIngresados.asMap().entries.map((entry) {
                      final index = entry.key;
                      final dato = entry.value;
                      return DataRow(cells: <DataCell>[
                        DataCell(
                          Center(
                            child: Text(
                              dato['Departamento'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Ubicacion'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Problema'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Material'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Cantidad_Material'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Obra'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Cantidad_Obra'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // Agregar botones de acción (Editar y Eliminar)
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  eliminarDato(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: isGuardarHabilitado
                      ? () {
                          guardarDatosConConfirmacion(context);
                        }
                      : null, // Desactiva el botón si isGuardarHabilitado es falso
                  key: null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(
                      6,
                      6,
                      68,
                      1,
                    ),
                  ),
                  child: const Text('Guardar todo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    /* } else {
      // Si no hay conexión a Internet, mostrar el widget de No Internet
      return const Scaffold(
        body: Center(
          child: NoInternet(), // Usar el widget NoInternetWidget
        ),
      );
    } */
  }

  void mostrarFotoEnGrande(XFile image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          // Establecer el color de fondo transparente
          child: Stack(
            children: [
              PhotoView(
                imageProvider: FileImage(File(image.path)),
                backgroundDecoration: const BoxDecoration(
                  color: Colors
                      .transparent, // Establece el color de fondo transparente
                ),
                loadingBuilder: (context, event) {
                  if (event == null || event.expectedTotalBytes == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: event.cumulativeBytesLoaded /
                          event.expectedTotalBytes!,
                    ),
                  );
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child:
                        const Icon(Icons.cancel_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//permitir al usuario ver la imagen en grande
  Widget buildThumbnailWithCancel(XFile image, int index) {
    return GestureDetector(
      onTap: () {
        mostrarFotoEnGrande(image);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(.0),
            child: ClipRect(
              child: Align(
                alignment: Alignment.topLeft,
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Image.file(
                  File(image.path),
                  width: 100,
                  height: 70,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  images.removeAt(index); // Remueve la imagen de la lista
                });
                eliminarImagenDeFirebase(image);
              },
              child: const Icon(Icons.cancel_rounded), // Ícono para cancelar
            ),
          ),
        ],
      ),
    );
  }

  // Función para eliminar una foto
  Future<void> eliminarImagenDeFirebase(XFile imageUrl) async {
    try {
      String? imageURL =
          await FirebaseStorageService.uploadImage(File(imageUrl.path));
      // Obtener una referencia a la imagen en Firebase Storage
      Reference imagenRef = FirebaseStorage.instance.refFromURL(imageURL!);

      // Eliminar la imagen de Firebase Storage
      await imagenRef.delete();

      print('Imagen eliminada de Firebase Storage correctamente');
    } catch (e) {
      print('Error al eliminar la imagen de Firebase Storage: $e');
    }
  }
}

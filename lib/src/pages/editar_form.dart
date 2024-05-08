import 'dart:async';
import 'dart:io';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db.dart';
import 'package:app_inspections/services/functions.dart';
import 'package:app_inspections/src/pages/connection/no_internet.dart';
import 'package:app_inspections/src/pages/utils/check_internet_connection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditarForm extends StatelessWidget {
  final int idTienda;
  final Map<String, dynamic> data;
  final String nombreTienda;
  const EditarForm(
      {super.key,
      required this.idTienda,
      required this.data,
      required this.nombreTienda});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            // Puedes agregar código para manejar el evento de retroceso aquí
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        title: Text(
          nombreTienda,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
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
      body: EditMyForm(
        idTienda: idTienda,
        context: context,
        data: data,
        nombreTienda: nombreTienda,
      ),
    );
  }
}

class EditMyForm extends StatefulWidget {
  final int idTienda;
  final BuildContext context;
  final Map<String, dynamic> data;
  final String nombreTienda;

  const EditMyForm(
      {super.key,
      required this.idTienda,
      required this.context,
      required this.data,
      required this.nombreTienda});

  @override
  State<EditMyForm> createState() =>
      // ignore: no_logic_in_create_state
      _EditMyFormState(idTienda: idTienda, context: context);
}

class _EditMyFormState extends State<EditMyForm> {
  //verificar la conexion a internet
  late final CheckInternetConnection _internetConnection;
  late StreamSubscription<ConnectionStatus> _connectionSubscription;
  ConnectionStatus _currentStatus = ConnectionStatus.online;

  final int idTienda;
  String idTien = '';
  String nombreTienda = '';

  final BuildContext context;
  bool _isLoading = true;

  bool _isButtonDisabled = true;
  List<String> fotos = [];

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
    selectedFormato = widget.data['formato'];
    _departamentoController.text = widget.data['nom_dep'];
    _ubicacionController.text = widget.data['clave_ubi'];
    idProbl = widget.data['id_probl'];
    idMat = widget.data['id_mat'];
    idObra = widget.data['id_obr'];
    _cantmatController.text = widget.data['cant_mat'].toString();
    _cantobraController.text = widget.data['cant_obr'].toString();
    fotos = widget.data['foto'] as List<String>;
    _cargarDatosAsync();
  }

  //campos de la base de datos
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _cantmatController = TextEditingController();
  final TextEditingController _cantobraController = TextEditingController();
  final TextEditingController _otroMPController = TextEditingController();
  final TextEditingController _otroObraController = TextEditingController();

  int idTiend = 0;
  int idProbl = 0;
  int idMat = 0;
  int idObra = 0;
  String idReporte = "";
  String selectedFormato = "F1";

  _EditMyFormState({required this.idTienda, required this.context});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<XFile> images = []; // Lista para almacenar las rutas de las imágenes
  int maxPhotos = 6;

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

  final FocusNode _cantidadFocus = FocusNode();
  final FocusNode _focusOtO = FocusNode();

  Future<void> editarDefecto() async {
    try {
      // Llama al método para obtener el defecto por su ID
      Map<String, dynamic> defecto =
          await DatabaseHelper().obtenerDefectoPorId(idProbl);
      if (defecto.isNotEmpty) {
        // Accede a los datos del defecto
        _textEditingControllerProblema.text = defecto['nom_probl'];

        // Usa los datos como necesites
      } else {
        // Manejo si no se encontró el defecto
        if (kDebugMode) {
          print("NO HAY DATOS");
        }
      }
    } catch (error) {
      // Maneja cualquier error que ocurra durante la ejecución
      if (kDebugMode) {
        print('Error en editarDefecto: $error');
      }
    }
  }

  Future<void> editarMaterial() async {
    try {
      // Llama al método para obtener el defecto por su ID
      Map<String, dynamic> material =
          await DatabaseHelper().obtenerMaterialPorId(idMat);
      // Verifica si se encontró el defecto
      if (material.isNotEmpty) {
        // Accede a los datos del defecto
        _textEditingControllerMaterial.text = material['nom_mat'];

        // Usa los datos como necesites
      } else {
        // Manejo si no se encontró el defecto
        if (kDebugMode) {
          print("NO HAY DATOS");
        }
      }
    } catch (error) {
      // Maneja cualquier error que ocurra durante la ejecución
      if (kDebugMode) {
        print('Error en editarDefecto: $error');
      }
    }
  }

  Future<void> editarManoObra() async {
    try {
      // Llama al método para obtener el defecto por su ID
      Map<String, dynamic> obra =
          await DatabaseHelper().obtenerObraPorId(idObra);
      // Verifica si se encontró el defecto
      if (obra.isNotEmpty) {
        // Accede a los datos del defecto
        _textEditingControllerObra.text = obra['nom_obr'];

        // Usa los datos como necesites
      } else {
        // Manejo si no se encontró el defecto
        if (kDebugMode) {
          print("NO HAY DATOS");
        }
      }
    } catch (error) {
      // Maneja cualquier error que ocurra durante la ejecución
      if (kDebugMode) {
        print('Error en editarDefecto: $error');
      }
    }
  }

  Future<void> _cargarDatosAsync() async {
    try {
      // Realiza las operaciones asíncronas para cargar los datos
      await editarDefecto();
      await editarMaterial();
      await editarManoObra();

      // Una vez que las operaciones están completas, actualiza el estado para ocultar el indicador de carga
      setState(() {
        _isLoading = true;
      });

      // Inicia un temporizador para ocultar el indicador de carga después de un tiempo determinado
      Timer(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      // Manejo de errores
      Text('Error al cargar los datos: $e');
      // Aquí puedes mostrar un mensaje al usuario informándole sobre el error
    }
  }

  void handleSelectionMaterial(
      String selectedOptionMaterial, int idMaterialSeleccionado) {
    setState(() {
      _textEditingControllerMaterial.text = selectedOptionMaterial;
      showListMaterial = false; // Ocultar la lista después de la selección
      isMaterialSelected = true;
      //_idmatController.text = idMat.toString();
      idMat = idMaterialSeleccionado;
      if (kDebugMode) {
        print('ID del material seleccionado: $idMat');
      }
    });
  }

  void handleSelectionProblem(
      String selectedOptionProblem, int idProblemaSeleccionado) {
    setState(() {
      _textEditingControllerProblema.text = selectedOptionProblem;
      showListProblemas = false;
      isProblemSelected = true;
      //_idproblController.text = idProbl.toString();
      idProbl = idProblemaSeleccionado;
      //print('ID del problema seleccionado: $idProbl');
    });
  }

  void handleSelectionObra(String selectedOptionObra, int idObraSeleccionado) {
    setState(() {
      _textEditingControllerObra.text = selectedOptionObra;
      showListObra = false; // Ocultar la lista después de la selección
      isObraSelected = true;
      //_idobraController.text = idObra.toString();
      idObra = idObraSeleccionado;
      //print('OBRAA SELECCIONADO: $idObra');
    });
  }

  // Función para guardar datos con confirmación
  void guardarDatosConConfirmacion(BuildContext context) async {
    bool confirmacion = await mostrarDialogoConfirmacionEditar(context);
    if (confirmacion == true) {
      // Ejecutar la función _guardarDatos si el usuario acepta
      _editarDatos();
    } else {
      // No hacer nada si el usuario  cancela
    }
  }

  void _editarDatos() {
    if (formKey.currentState!.validate()) {
      String valorDepartamento = _departamentoController.text;
      String valorUbicacion = _ubicacionController.text;
      String valorCanMate = _cantmatController.text;
      String valorCanObra = _cantobraController.text;
      String nomProbl = _textEditingControllerProblema.text;
      String nomMat = _textEditingControllerMaterial.text;
      String nomObra = _textEditingControllerObra.text;
      String otro = _otroMPController.text;
      String otroO = _otroObraController.text;
      int cantM = widget.data['cant_mat'];
      int cantO = widget.data['cant_obr'];
      idReporte = widget.data['id_rep'];

      try {
        if (valorCanMate.isNotEmpty) {
          cantM = int.parse(valorCanMate);
        }
        if (valorCanObra.isNotEmpty) {
          cantO = int.parse(valorCanObra);
        }
        DatabaseHelper.editarReporte(
          idReporte,
          selectedFormato,
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
          idTiend,
        );

        // Muestra una alerta de "Edición terminada"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            nombreTienda = widget.nombreTienda;
            return AlertDialog(
              title: const Text('Edición terminada'),
              content: const Text('¡Los datos han sido editados con éxito!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra la alerta
                    Navigator.pushNamed(
                      context,
                      'inspectienda',
                      arguments: {
                        'idTienda': idTiend,
                        'nombreTienda': nombreTienda
                      },
                    );
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Manejo de errores
        // Muestra una alerta de "Edición terminada"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            nombreTienda = widget.nombreTienda;
            return AlertDialog(
              title: const Text('Error al Editar'),
              content: const Text('¡Intenta nuevamente!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra la alerta
                    Navigator.pushNamed(
                      context,
                      'inspectienda',
                      arguments: {
                        'idTienda': idTiend,
                        'nombreTienda': nombreTienda
                      },
                    );
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
        // Puedes mostrar un mensaje de error al usuario si lo deseas
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _buildLoadingIndicator() : _buildForm(context);
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForm(BuildContext context) {
    idTiend = idTienda;
    List<Map<String, dynamic>> resultadosP = [];
    List<Map<String, dynamic>> resultadosM = [];
    List<Map<String, dynamic>> resultadosO = [];

    if (_currentStatus == ConnectionStatus.online) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Editar Inspección',
                      style: Theme.of(context).textTheme.headlineMedium),
                  /* DropdownButtonFormField(
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
                ), */
                  TextFormField(
                    controller: _departamentoController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (_departamentoController.text.isEmpty &&
                          _departamentoController.text.isNotEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Departamento'),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _textEditingControllerProblema,
                    onChanged: (String value) async {
                      resultadosP =
                          await DatabaseHelper.mostrarProblemas(value);
                      setState(() {
                        showListProblemas = value.isNotEmpty;
                        // Utiliza la variable resultados directamente
                        filteredOptionsProblema = resultadosP
                            .where((opcion) =>
                                opcion['cod_probl']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                opcion['nom_probl']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .map((opcion) {
                          // Guarda el ID en la variable externa
                          idProbl = opcion['id_probl'];
                          // Retorna el texto para mostrar en la lista
                          String textoProblema =
                              '${opcion['nom_probl']} ${opcion['formato']}';
                          return '$textoProblema|id:$idProbl';
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
                      visible: showListProblemas &&
                          filteredOptionsProblema.isNotEmpty,
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: filteredOptionsProblema.length,
                          itemBuilder: (context, index) {
                            // Divide el texto del problema y el ID del problema
                            List<String> partes =
                                filteredOptionsProblema[index].split('|id:');
                            String textoProblema = partes[0];
                            int idProblema = int.parse(partes[1]);
                            return ListTile(
                              title: Text(textoProblema),
                              onTap: () {
                                // Puedes acceder al ID del problema seleccionado aquí
                                int idProblemaSeleccionado = idProblema;
                                handleSelectionProblem(
                                    textoProblema, idProblemaSeleccionado);
                                showListProblemas = false;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _textEditingControllerMaterial,
                    onChanged: (String value) async {
                      resultadosM =
                          await DatabaseHelper.mostrarMateriales(value);
                      setState(() {
                        showListMaterial = value.isNotEmpty;
                        // Utiliza la variable resultados directamente
                        filteredOptionsMaterial = resultadosM
                            .where((opcion) => opcion['nom_mat']
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .map((opcion) {
                          // Guarda el ID en la variable externa
                          idMat = opcion['id_mat'];
                          // Retorna el texto para mostrar en la lista
                          String textoMaterial =
                              '${opcion['nom_mat']} ${opcion['formato']}';
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
                      visible: showListMaterial &&
                          filteredOptionsMaterial.isNotEmpty,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _cantmatController,
                    decoration: const InputDecoration(
                        labelText: 'Cantidad de Material'),
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
                    height: 80,
                    //width: 200,
                    child: SizedBox(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: fotos.map<Widget>((url) {
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: InkWell(
                              onTap: () {
                                // Muestra la imagen en una vista modal o un diálogo
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Image.network(
                                      url,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Manejar el error y mostrar una imagen de respaldo
                                        return Image.asset(
                                            'assets/no_image.png');
                                      },
                                      fit: BoxFit
                                          .contain, // Ajusta la imagen al tamaño del contenedor
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                url,
                                errorBuilder: (context, error, stackTrace) {
                                  CachedNetworkImage(
                                    imageUrl: url,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  );
                                  // Manejar el error y mostrar una imagen de respaldo
                                  return Image.asset('assets/no_image.png',
                                      width: 70, height: 70);
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _textEditingControllerObra,
                    onChanged: (String value) async {
                      resultadosO = await DatabaseHelper.mostrarObra(value);
                      setState(() {
                        showListObra = value.isNotEmpty;
                        filteredOptionsObra = resultadosO
                            .where((opcion) => opcion['nom_obr']
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .map((opcion) {
                          // Guarda el ID en la variable externa
                          idObra = opcion['id_obr'];
                          // Retorna el texto para mostrar en la lista
                          String textoObra =
                              '${opcion['nom_obr']} ${opcion['formato']}';
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
                    focusNode: _cantidadFocus,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centra los elementos horizontalmente
                    children: [
                      Flexible(
                        flex: 1,
                        child: ElevatedButton.icon(
                          onPressed: () => {},
                          icon: const Icon(Icons.camera),
                          label: const Text('Tomar fotografía'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      guardarDatosConConfirmacion(context);
                    },
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
                    child: const Text('Finalizar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Si no hay conexión a Internet, mostrar el widget de No Internet
      return const Scaffold(
        body: Center(
          child: NoInternet(), // Usar el widget NoInternetWidget
        ),
      );
    }
  }

  void _mostrarFotoEnGrande(XFile image) {
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
  Widget _buildThumbnailWithCancel(XFile image, int index) {
    return GestureDetector(
      onTap: () {
        _mostrarFotoEnGrande(image);
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
              },
              child: const Icon(Icons.cancel_rounded), // Ícono para cancelar
            ),
          ),
        ],
      ),
    );
  }
}

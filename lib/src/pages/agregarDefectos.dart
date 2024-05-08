import 'package:app_inspections/models/mano_obra.dart';
import 'package:app_inspections/models/materiales.dart';
import 'package:app_inspections/models/problemas.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Defectos extends StatelessWidget {
  const Defectos({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AgregarDefecto());
  }
}

class AgregarDefecto extends StatefulWidget {
  const AgregarDefecto({super.key});

  @override
  State<AgregarDefecto> createState() => _AgregarDefectoState();
}

class _AgregarDefectoState extends State<AgregarDefecto> {
  //listas de los modelos
  List<Problemas> problemas = [];
  List<Materiales> materiales = [];
  List<Obra> obra = [];

  int idProbl = 0;
  int idMat = 0;
  int idObra = 0;

  String formato = "";

  //controller del formulario
  final TextEditingController _idproblController = TextEditingController();
  final TextEditingController _idmatController = TextEditingController();
  final TextEditingController _cantmatController = TextEditingController();
  final TextEditingController _idobraController = TextEditingController();
  final TextEditingController _cantobraController = TextEditingController();
  final TextEditingController _otroMPController = TextEditingController();
  final TextEditingController _otroObraController = TextEditingController();

  //Desactivar campos
  final FocusNode _focusNodeProbl = FocusNode();
  final FocusNode _focusNodeMat = FocusNode();
  final FocusNode _focusNodeObr = FocusNode();
  final FocusNode _cantidadFocus = FocusNode();
  final FocusNode _focusOtO = FocusNode();

  //variables para lista problemas
  final TextEditingController _textEditingControllerProblema =
      TextEditingController();
  bool showListProblemas = false;
  List<String> opcionesProblemas = [];
  List<String> filteredOptionsProblema = [];
  bool isProblemSelected = false;

  //variables para lista materiales
  final TextEditingController _textEditingControllerMaterial =
      TextEditingController();
  bool showListMaterial = false;
  List<String> opcionesMaterial = [];
  List<String> filteredOptionsMaterial = [];
  bool isMaterialSelected = false;

  //variable para lista mano de obra
  final TextEditingController _textEditingControllerObra =
      TextEditingController();
  bool showListObra = false;
  List<String> opcionesObra = [];
  List<String> filteredOptionsObra = [];
  bool isObraSelected = false;

  //método para cargar la lista de problemas desde la bd local
  cargaProblemas() async {
    List<Problemas> auxProblema = await DatabaseProvider.showProblemas();

    setState(() {
      problemas = auxProblema;
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

  void handleSelectionObra(String selectedOptionObra, int idObraSeleccionado) {
    setState(() {
      _textEditingControllerObra.text = selectedOptionObra;
      showListObra = false; // Ocultar la lista después de la selección
      isObraSelected = true;
      _idobraController.text = idObra.toString();
      idObra = idObraSeleccionado;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Problemas> resultadosP;
    List<Materiales> resultadosM;
    List<Obra> resultadosO;

    return Dialog(
      // Configura la forma y el tamaño del diálogo según tus necesidades
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Información del Defecto',
                      style: Theme.of(context).textTheme.headlineMedium),
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
                      visible: showListProblemas &&
                          filteredOptionsProblema.isNotEmpty,
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
                    height: 30,
                  ),
                  const Text('Mano de Obra',
                      style: TextStyle(
                        fontSize: 25,
                      )),
                  TextFormField(
                    focusNode: _focusNodeObr,
                    //enabled: activarCampos,
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
                    //enabled: activarCampos,
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
                    //enabled: activarCampos,
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
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                    child: const Text('Agregar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

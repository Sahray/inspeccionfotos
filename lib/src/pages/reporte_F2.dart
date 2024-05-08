import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db_online.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class ReporteF2Screen extends StatelessWidget {
  final int idTienda;
  final String nomTienda;

  const ReporteF2Screen(
      {Key? key, required this.idTienda, required this.nomTienda})
      : super(key: key);

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return databaseHelper.mostrarReporteF2(idTienda);
  }

  void _descargarPDF(BuildContext context, String? user) async {
    // Obtener los datos del informe
    List<Map<String, dynamic>> datos = await _cargarReporte(idTienda);
    print("DATOS DE REPORTEE $datos");

    // Generar el PDF
    File pdfFile = await generatePDF(datos, nomTienda, user);

    // Abrir el diálogo de compartir para compartir o guardar el PDF
    // ignore: deprecated_member_use
    Share.shareFiles([pdfFile.path], text: 'Descarga tu reporte en PDF');
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    String? user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        title: const Text(
          "REPORTE",
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              _descargarPDF(context, user);
            },
          ),
        ],
      ),
      body: ReporteF2Widget(idTienda: idTienda),
    );
  }
}

class ReporteF2Widget extends StatefulWidget {
  final int idTienda;

  const ReporteF2Widget({Key? key, required this.idTienda}) : super(key: key);

  @override
  State<ReporteF2Widget> createState() => _ReporteWidgetState();
}

Future<File> generatePDF(
    List<Map<String, dynamic>> data, String nomTiend, String? user) async {
  final pdfWidgets.Font customFont = pdfWidgets.Font.ttf(
    await rootBundle.load('assets/fonts/OpenSans-Italic.ttf'),
  );
  final dateFormatter = DateFormat('yyyy-MM-dd');
  final formattedDate = dateFormatter.format(DateTime.now());

  final pdf = pdfWidgets.Document();
  // Carga la imagen de forma asíncrona
  final Uint8List imageData = await _loadImageData('assets/logoconexsa.png');

  const int itemsPerPage = 20; // Número de elementos por página

  // Calcular el número total de páginas
  final int totalPages = (data.length / itemsPerPage).ceil();

  for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
    // Calcular los índices de inicio y fin para la página actual
    final int startIndex = pageIndex * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage < data.length)
        ? startIndex + itemsPerPage
        : data.length;
    // Obtener los datos de la página actual
    final List<Map<String, dynamic>> pageData =
        data.sublist(startIndex, endIndex);

    final Uint8List backgroundImageData =
        await _loadImageData('assets/portada1.png');

    pdf.addPage(
      pdfWidgets.Page(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginLeft: 0, // Margen izquierdo reducido
          marginRight: -60, // Margen derecho reducido
          marginTop: 0, // Margen superior reducido
          marginBottom: 0,
        ),
        build: (context) {
          return pdfWidgets.Stack(
            alignment: pdfWidgets.Alignment.center,
            children: [
              // Fondo de la página (imagen)
              pdfWidgets.Positioned.fill(
                child: pdfWidgets.Image(
                  pdfWidgets.MemoryImage(backgroundImageData),
                  fit: pdfWidgets.BoxFit
                      .cover, // Adaptar la imagen para cubrir toda el área
                ),
              ),

              pdfWidgets.Center(
                child: pdfWidgets.Column(
                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.center,
                  children: [
                    // Logo
                    pdfWidgets.Positioned(
                      right: 0,
                      top: 0,
                      child: pdfWidgets.Container(
                        margin: const pdfWidgets.EdgeInsets.all(5),
                        child:
                            pdfWidgets.Image(pdfWidgets.MemoryImage(imageData)),
                        width: 250, // Ancho de la imagen
                      ),
                    ),
                    pdfWidgets.SizedBox(
                        height:
                            20), // Espacio entre el logo y el texto siguiente

                    pdfWidgets.Text(
                      'Reporte de Contrastista',
                      style: pdfWidgets.TextStyle(
                        font: customFont,
                        fontSize: 30,
                        fontWeight: pdfWidgets.FontWeight.bold,
                        color: PdfColors.blueGrey500,
                      ),
                    ),
                    pdfWidgets.Text(
                      'Fecha: $formattedDate',
                      style: pdfWidgets.TextStyle(
                        font: customFont,
                        fontSize: 18,
                        color: PdfColors.black,
                      ),
                    ),
                    pdfWidgets.Text(
                      'Tienda: $nomTiend',
                      style: pdfWidgets.TextStyle(
                        font: customFont,
                        fontSize: 18,
                        color: PdfColors.black,
                      ),
                    ),
                    pdfWidgets.Text(
                      'Nombre de Inspector: $user',
                      style: pdfWidgets.TextStyle(
                        font: customFont,
                        fontSize: 18,
                        color: PdfColors.black,
                      ),
                    ),
                    // Agrega más datos de la portada según tus necesidades
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pdfWidgets.MultiPage(
        orientation: pdfWidgets.PageOrientation.landscape,
        build: (context) {
          List<pdfWidgets.Widget> widgets = [
            // ignore: deprecated_member_use
            pdfWidgets.Table.fromTextArray(
              context: context,
              data: [
                [
                  'Departamento',
                  'Ubicación',
                  'Problema',
                  'Material',
                  'Cantidad',
                  'Mano de Obra',
                  'Cantidad',
                ],
                for (var row in pageData)
                  [
                    row['nom_dep'].toString(),
                    row['clave_ubi'].toString(),
                    pdfWidgets.Text(
                      row['nom_probl'].toString(),
                      style: pdfWidgets.TextStyle(
                        font: customFont, // Usa la fuente personalizada aquí
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                    pdfWidgets.Text(
                      row['nom_mat'].toString(),
                      style: pdfWidgets.TextStyle(
                        font: customFont, // Usa la fuente personalizada aquí
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                    row['cant_mat'].toString(),
                    row['nom_obr'].toString(),
                    row['cant_obr'].toString(),
                  ]
              ],
              border: pdfWidgets.TableBorder.all(
                color: PdfColors.black,
                width: 1,
              ),
              cellAlignment: pdfWidgets.Alignment.center,
              cellStyle: const pdfWidgets.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
              headerStyle: pdfWidgets.TextStyle(
                fontWeight: pdfWidgets.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pdfWidgets.BoxDecoration(
                color: PdfColors.blueGrey700,
              ),
            ),
          ];
          return widgets;
        },
      ),
    );
  }

  // Guarda el PDF en un archivo
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/reporteContratista.pdf';
  final File file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  return file;
}

Future<Uint8List> _loadImageData(String imagePath) async {
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}

class _ReporteWidgetState extends State<ReporteF2Widget> {
  late Future<List<Map<String, dynamic>>> _futureReporte;
  String datounico = "";

  @override
  void initState() {
    super.initState();
    _futureReporte = _cargarReporte(widget.idTienda);
  }

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return databaseHelper.mostrarReporteF2(widget.idTienda);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FutureBuilder(
        future: _futureReporte,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> datos = snapshot.data!;
            return ListView(children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                  // ignore: deprecated_member_use
                  dataRowHeight: 100,
                  columns: const [
                    DataColumn(
                        label: Center(
                      child: Text(
                        'Departamento',
                        softWrap: true,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'Ubicación',
                      softWrap: true,
                    )),
                    DataColumn(
                      label: Text(
                        'Problema',
                        softWrap: true,
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      'Material',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Especifique (Otro)',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Cantidad',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Mano de Obra',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Especifique (Otro)',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Cantidad',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'URL FOTO',
                      softWrap: true,
                    )),
                  ],
                  rows: datos.map((dato) {
                    datounico = dato['dato_unico'];
                    return DataRow(
                      cells: [
                        DataCell(
                          Text('${dato['nom_dep']}'),
                        ),
                        DataCell(
                          Text('${dato['clave_ubi']}'),
                        ),
                        DataCell(
                          Container(
                            width: (MediaQuery.of(context).size.width / 10) * 3,
                            padding: const EdgeInsets.all(3),
                            child: Center(child: Text('${dato['nom_probl']}')),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: (MediaQuery.of(context).size.width / 10) * 3,
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['nom_mat']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Center(child: Text('${dato['otro']}')),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['cant_mat']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['nom_obr']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['otro_obr']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['cant_obr']}'),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 500,
                            child: Row(
                              children: dato['foto'].map<Widget>((url) {
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Manejar el error y mostrar una imagen de respaldo
                                        return Image.asset(
                                            'assets/no_image.png',
                                            width: 70,
                                            height: 70);
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ]);
          }
        },
      ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final File image;

  const ImageViewScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image')),
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}

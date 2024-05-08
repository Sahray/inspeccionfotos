import 'package:app_inspections/services/db_offline.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Tiendas {
  int? id;
  int codigo;
  String nombre;
  String distrito;

  Tiendas(
      {required this.id,
      required this.codigo,
      required this.nombre,
      required this.distrito});

  Map<String, dynamic> toMap() {
    return {
      'id_tienda': id,
      'cod_tienda': codigo,
      'nom_tienda': nombre,
      'dist_tienda': distrito
    };
  }
}

void insertInitialDataT() async {
  getDatabasesPath().then((databasePath) async {
    join(databasePath, 'conexsa.db');

    final List<Tiendas> tiendas = [
      Tiendas(id: null, codigo: 1162, nombre: 'Delicias', distrito: 'FRONTERA'),
      Tiendas(
          id: null,
          codigo: 1174,
          nombre: '	Chihuahua Norte',
          distrito: 'FRONTERA'),
      Tiendas(id: null, codigo: 8713, nombre: 'Henequen', distrito: 'FRONTERA'),
      Tiendas(
          id: null, codigo: 8714, nombre: 'López Mateos', distrito: 'FRONTERA'),
      Tiendas(
          id: null, codigo: 8719, nombre: 'Chihuahua', distrito: 'FRONTERA'),
      Tiendas(
          id: null, codigo: 8723, nombre: 'Tecnológico', distrito: 'FRONTERA'),
      Tiendas(id: null, codigo: 8728, nombre: 'Torreón', distrito: 'FRONTERA'),
      Tiendas(id: null, codigo: 8733, nombre: 'Durango', distrito: 'FRONTERA'),
      Tiendas(
          id: null,
          codigo: 1327,
          nombre: 'Gomez Palacios',
          distrito: 'FRONTERA'),
      Tiendas(
          id: null,
          codigo: 1168,
          nombre: 'Tijuana El Soler',
          distrito: 'BAJA NORTE'),
      Tiendas(
          id: null, codigo: 8082, nombre: 'Rosarito', distrito: 'BAJA NORTE'),
      Tiendas(
          id: null, codigo: 8651, nombre: 'Nogales', distrito: 'BAJA NORTE'),
      Tiendas(
          id: null, codigo: 8654, nombre: 'Guaymas', distrito: 'BAJA NORTE'),
      Tiendas(
          id: null, codigo: 8705, nombre: 'Mexicali', distrito: 'BAJA NORTE'),
      Tiendas(
          id: null, codigo: 8706, nombre: 'Tijuana', distrito: 'BAJA NORTE'),
      Tiendas(
          id: null, codigo: 8720, nombre: 'Hermosillo', distrito: 'BAJA NORTE'),
      Tiendas(
          id: null, codigo: 8775, nombre: 'Ensenada', distrito: 'BAJA NORTE'),
      Tiendas(
          id: null,
          codigo: 8854,
          nombre: 'Tijuana Este',
          distrito: 'BAJA NORTE'),
      Tiendas(
          id: null,
          codigo: 8638,
          nombre: 'Piedras Negras',
          distrito: 'NORESTE'),
      Tiendas(id: null, codigo: 8644, nombre: 'Matamoros', distrito: 'NORESTE'),
      Tiendas(id: null, codigo: 8653, nombre: 'Monclova', distrito: 'NORESTE'),
      Tiendas(id: null, codigo: 8729, nombre: 'Saltillo', distrito: 'NORESTE'),
      Tiendas(id: null, codigo: 8730, nombre: 'Tampico', distrito: 'NORESTE'),
      Tiendas(id: null, codigo: 8734, nombre: 'Reynosa', distrito: 'NORESTE'),
      Tiendas(
          id: null, codigo: 8757, nombre: 'Cd. Victoria', distrito: 'NORESTE'),
      Tiendas(
          id: null, codigo: 8796, nombre: 'Nuevo Laredo', distrito: 'NORESTE'),
      Tiendas(
          id: null,
          codigo: 8797,
          nombre: 'Saltillo Nogalera',
          distrito: 'NORESTE'),
      Tiendas(
          id: null, codigo: 8752, nombre: 'Santa Catarina', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 8703, nombre: 'Revolución', distrito: 'NORTE'),
      Tiendas(
          id: null, codigo: 8789, nombre: 'Miguel Aleman', distrito: 'NORTE'),
      Tiendas(
          id: null, codigo: 8751, nombre: 'Eloy Cavazos', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 8652, nombre: 'Fundadores', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 1175, nombre: 'Gonzalitos', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 8710, nombre: 'Nogalar', distrito: 'NORTE'),
      Tiendas(
          id: null, codigo: 1169, nombre: 'Cumbres oeste', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 8704, nombre: 'Cumbres', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 8094, nombre: 'Sendero', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 8701, nombre: 'Torres', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 8676, nombre: 'La Rioja', distrito: 'NORTE'),
      Tiendas(id: null, codigo: 1333, nombre: 'Concordia', distrito: 'NORTE'),
      Tiendas(
          id: null,
          codigo: 1176,
          nombre: 'San Anita , GDJ',
          distrito: 'OCCIDENTE'),
      Tiendas(
          id: null,
          codigo: 8636,
          nombre: 'GDJ Tlaquepaque',
          distrito: 'OCCIDENTE'),
      Tiendas(
          id: null,
          codigo: 8643,
          nombre: 'Circunvalacion',
          distrito: 'OCCIDENTE'),
      Tiendas(
          id: null, codigo: 8657, nombre: 'Manzanillo', distrito: 'OCCIDENTE'),
      Tiendas(
          id: null,
          codigo: 8659,
          nombre: 'Independencia',
          distrito: 'OCCIDENTE'),
      Tiendas(
          id: null,
          codigo: 8662,
          nombre: 'Tepic Centro',
          distrito: 'OCCIDENTE'),
      Tiendas(
          id: null, codigo: 8727, nombre: '	I.T.E.S.O.', distrito: 'OCCIDENTE'),
      Tiendas(
          id: null, codigo: 8742, nombre: 'Cordilleras', distrito: 'OCCIDENTE'),
      Tiendas(
          id: null, codigo: 8772, nombre: 'Acueducto', distrito: 'OCCIDENTE'),
      Tiendas(
          id: null,
          codigo: 8785,
          nombre: '	Puerto Vallarta',
          distrito: 'OCCIDENTE'),
      Tiendas(id: null, codigo: 8852, nombre: 'Colima', distrito: 'OCCIDENTE'),
      Tiendas(
          id: null,
          codigo: 1328,
          nombre: 'Lazaro Cardenas',
          distrito: 'OCCIDENTE'),
      Tiendas(
          id: null,
          codigo: 8771,
          nombre: 'Los Mochis',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 8708,
          nombre: 'Culiacán',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 8759,
          nombre: 'Obregón',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 8628,
          nombre: 'La Paz, B.C.S.',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 8766,
          nombre: 'Los Cabos',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 8664,
          nombre: 'Culiacán Tres Ríos',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 8784,
          nombre: 'Mazatlán',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 8682,
          nombre: 'Guasave',
          distrito: 'PACIFICO NORTE'),
      Tiendas(
          id: null,
          codigo: 1161,
          nombre: 'San Luis Potosí II',
          distrito: 'BAJIO'),
      Tiendas(
          id: null, codigo: 8707, nombre: 'San Luis Potosí', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8642, nombre: 'Uruapan', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8656, nombre: 'Zamora', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8677, nombre: 'Zacatecas', distrito: 'BAJIO'),
      Tiendas(
          id: null,
          codigo: 1163,
          nombre: 'Aguascalientes SUR',
          distrito: 'BAJIO'),
      Tiendas(
          id: null, codigo: 8769, nombre: 'Aguascalientes', distrito: 'BAJIO'),
      Tiendas(
          id: null, codigo: 8672, nombre: 'Morelia Este', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8741, nombre: 'Morelia', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8777, nombre: 'Irapuato', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8778, nombre: 'Celaya', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8694, nombre: 'Salamanca', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8740, nombre: 'León', distrito: 'BAJIO'),
      Tiendas(
          id: null, codigo: 8716, nombre: 'Campestre, León', distrito: 'BAJIO'),
      Tiendas(id: null, codigo: 8626, nombre: 'Tlaxcala', distrito: 'CENTRO'),
      Tiendas(
          id: null,
          codigo: 8635,
          nombre: 'Puebla Este Villa Verde',
          distrito: 'CENTRO'),
      Tiendas(
          id: null,
          codigo: 8639,
          nombre: 'Puebla Periférico',
          distrito: 'CENTRO'),
      Tiendas(id: null, codigo: 8658, nombre: 'Cordoba', distrito: 'CENTRO'),
      Tiendas(
          id: null,
          codigo: 8698,
          nombre: 'Tehuacan Puebla',
          distrito: 'CENTRO'),
      Tiendas(
          id: null,
          codigo: 8735,
          nombre: 'Puebla Angelopolis',
          distrito: 'CENTRO'),
      Tiendas(id: null, codigo: 8767, nombre: 'Xalapa', distrito: 'CENTRO'),
      Tiendas(
          id: null,
          codigo: 8768,
          nombre: 'Puebla del Norte',
          distrito: 'CENTRO'),
      Tiendas(id: null, codigo: 8774, nombre: 'Pachuca', distrito: 'CENTRO'),
      Tiendas(id: null, codigo: 8776, nombre: 'Veracruz', distrito: 'CENTRO'),
      Tiendas(id: null, codigo: 8793, nombre: 'Poza Rica', distrito: 'CENTRO'),
      Tiendas(
          id: null, codigo: 8798, nombre: 'Puerta Texcoco', distrito: 'CENTRO'),
      Tiendas(id: null, codigo: 1165, nombre: 'Neza', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8648, nombre: 'Los Reyes', distrito: 'CDMX'),
      Tiendas(
          id: null, codigo: 8661, nombre: 'Santa Fe - Mx', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8691, nombre: 'Copilco DF', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8692, nombre: 'Lindavista', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8702, nombre: 'Coapa', distrito: 'CDMX'),
      Tiendas(
          id: null,
          codigo: 8744,
          nombre: 'Coapa (Miramontes)',
          distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8746, nombre: 'San Jerónimo', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8747, nombre: 'Iztapalapa', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8748, nombre: 'Mixcoac', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8763, nombre: 'Tlatilco', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 8860, nombre: 'Centro', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 1123, nombre: 'Polanco', distrito: 'CDMX'),
      Tiendas(id: null, codigo: 1167, nombre: 'Atizapan', distrito: 'EDO MEX'),
      //datossss
      Tiendas(
          id: null,
          codigo: 8086,
          nombre: 'Toluca (Centro)',
          distrito: 'EDO MEX'),
      Tiendas(id: null, codigo: 8637, nombre: 'Ecatepec', distrito: 'EDO MEX'),
      Tiendas(id: null, codigo: 8645, nombre: 'Tecamac', distrito: 'EDO MEX'),
      Tiendas(id: null, codigo: 8647, nombre: 'Aragon', distrito: 'EDO MEX'),
      Tiendas(
          id: null, codigo: 8724, nombre: 'Tlalnepantla', distrito: 'EDO MEX'),
      Tiendas(id: null, codigo: 8725, nombre: 'Naucalpan', distrito: 'EDO MEX'),
      Tiendas(
          id: null, codigo: 8745, nombre: 'Lomas Verdes', distrito: 'EDO MEX'),
      Tiendas(id: null, codigo: 8760, nombre: 'Coacalco', distrito: 'EDO MEX'),
      Tiendas(id: null, codigo: 8761, nombre: 'Perinorte', distrito: 'EDO MEX'),
      Tiendas(
          id: null, codigo: 8762, nombre: 'Interlomas', distrito: 'EDO MEX'),
      Tiendas(
          id: null,
          codigo: 8765,
          nombre: 'Cuatitlan Izcali',
          distrito: 'EDO MEX'),
      Tiendas(
          id: null,
          codigo: 8788,
          nombre: 'Metepec, Toluca',
          distrito: 'EDO MEX'),
      Tiendas(
          id: null, codigo: 8085, nombre: 'Coatzacoalcos', distrito: 'GOLFO'),
      Tiendas(id: null, codigo: 8663, nombre: 'Campeche', distrito: 'GOLFO'),
      Tiendas(
          id: null,
          codigo: 8673,
          nombre: 'Playa del Carmen',
          distrito: 'EDO MEX'),
      Tiendas(id: null, codigo: 8675, nombre: 'Chetumal', distrito: 'GOLFO'),
      Tiendas(
          id: null,
          codigo: 8693,
          nombre: 'Ciudad del Carmen',
          distrito: 'GOLFO'),
      Tiendas(
          id: null, codigo: 8696, nombre: 'Merida Canek', distrito: 'GOLFO'),
      Tiendas(
          id: null, codigo: 8739, nombre: 'Villahermosa', distrito: 'GOLFO'),
      Tiendas(
          id: null, codigo: 8743, nombre: 'Mérida, Yucatán', distrito: 'GOLFO'),
      Tiendas(id: null, codigo: 8795, nombre: 'Cancún', distrito: 'GOLFO'),
      Tiendas(
          id: null,
          codigo: 1164,
          nombre: 'Cuernavaca Juitepec',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 1166,
          nombre: 'Juriquilla',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8088,
          nombre: 'Querétaro Sur',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null, codigo: 8646, nombre: 'Cuautla', distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8649,
          nombre: 'San Juan del Rio',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8674,
          nombre: 'Oaxaca Candiani',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8726,
          nombre: 'Cuernavaca',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null, codigo: 8736, nombre: 'Acapulco', distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8738,
          nombre: 'Querétaro',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8754,
          nombre: 'Tapachula',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8781,
          nombre: 'Tuxtla Gutierrez',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 8857,
          nombre: '	Acapulco Diamante',
          distrito: 'PACIFICO SUR'),
      Tiendas(
          id: null,
          codigo: 1170,
          nombre: 'Queretaro Corregidora',
          distrito: 'PACIFICO SUR'),
    ];

    // Verificar si ya existen datos en la base de datos
    final List<Tiendas> existingTienda = await DatabaseProvider.showTiendas();
    if (existingTienda.isEmpty) {
      // Insertar solo si la base de datos está vacía
      for (final tienda in tiendas) {
        DatabaseProvider.insertTiendas(tienda);
      }
      print('Datos insertados correctamente.');
    } else {
      print(
          'Los datos de tiendas ya existen en la base de datos. No se realizaron inserciones.');
    }
  });
}

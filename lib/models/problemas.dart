import 'package:app_inspections/services/db_offline.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Problemas {
  int? id;
  String nombre;
  String codigo;
  String formato;

  Problemas(
      {required this.id,
      required this.nombre,
      required this.codigo,
      required this.formato});

  Map<String, dynamic> toMap() {
    return {
      'id_probl': id,
      'nom_probl': nombre,
      'cod_probl': codigo,
      'formato': formato
    };
  }
}

void insertInitialDataP() async {
  getDatabasesPath().then((databasePath) async {
    final dbFilePath = join(databasePath, 'conexsa.db');
    print('Ruta de la base de datos: $dbFilePath');

    final List<Problemas> problemas = [
      Problemas(
          id: null,
          nombre:
              'Marco dañado (Modificaciones o Alteriaciones de los refuerzos diagonales u horizontales de ls Rack Hy Z cabrillas)',
          codigo: 'U1',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Marco dañado (Perforaciones en Marco que no cumpla el NRS)',
          codigo: 'U2',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Marco con daño Substancial',
          codigo: 'U3',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre:
              'Marco dañado (Abolladura en cualquiera de sus lados de mas de 3/8” de profundidad y mas de 2” de diametro)',
          codigo: 'U25',
          formato: 'F1'),
      Problemas(
          id: null, nombre: 'Marco Retorcido', codigo: 'U26', formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Marco Oxidado que no cumpla los espesificaciones del NRS',
          codigo: 'U27',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre:
              'Marco con daño en las cabrillas con grieta o rotura visible en la soldadura',
          codigo: 'U28',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Marco con daño en las cabrillas (refurezos ” H” y ” Z”)',
          codigo: 'U29',
          formato: 'F1'),
      Problemas(
          id: null, nombre: 'Espaciador faltante', codigo: 'U4', formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Marcos "NO" ARU cargando productos de peso extra',
          codigo: 'S1',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Rack gutless cargando tarima',
          codigo: 'U10',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Marcos NO ARU galvanizados en exterior',
          codigo: 'U11',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Rack NO sobre concreto',
          codigo: 'U12',
          formato: 'F1'),
      Problemas(
          id: null, nombre: 'Marco desnivelado', codigo: 'U13', formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Calzas múltiples de mas de 2” de altura',
          codigo: 'U14',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre:
              'Calzas múltiples de mas de 3/4” de altura no soldadas entre si',
          codigo: 'U14',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Insertos galvanizados con menos de 4 tornillos grado 5',
          codigo: 'U15',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Protector de columna faltante',
          codigo: 'U16, U17, U18',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Extensiones soportando productos de peso extra',
          codigo: 'U19',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Extensiones en marcos gutless',
          codigo: 'U20',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Extensiones más allá de 16”-0” de altura total',
          codigo: 'U21',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Extensiones en marcos de uso ligero',
          codigo: 'U22',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Extensiones mal instaladas',
          codigo: 'U23, U24',
          formato: 'F1'),
      Problemas(
          id: null, nombre: '	Ancla faltante', codigo: 'A2', formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Anclas flojas',
          codigo: 'Anclas flojas',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Faltante de tuerca en ancla',
          codigo: 'A2(T)',
          formato: 'F1'),
      Problemas(id: null, nombre: 'Ancla dañada', codigo: 'A5', formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Concreto dañado en anclaje',
          codigo: 'A6',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Vigas de menos de 5” de peralte soportando tarimas',
          codigo: 'B2',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre:
              'Vigas de menos de 5” de peralte en top stock (no aplica en vigas de 51”)',
          codigo: 'B4',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre:
              'Faltante de viga atrás a 18”, si el nivel de viga más bajo es mayor a 52”',
          codigo: 'B12',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Vigas de 126” de largo con menos de 6” de peralte',
          codigo: 'B14',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Vigas de 156” cargando categorías de peso extra',
          codigo: 'B15',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Viga Perforada que no cumpla las espesificacion del NRS',
          codigo: 'B19',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Viga con pin de seguridad dañado',
          codigo: 'B21',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Vigas perforadas con montacargas',
          codigo: 'B28',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Viga golpeado con flexiones hacia abajo o al interior',
          codigo: 'B29',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Viga Oxidada que no cumpla los espesificaciones del NRS',
          codigo: 'B31',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Vigas pintadas en exterior',
          codigo: 'B17',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Tornillo de seguridad faltante',
          codigo: 'B23, B24',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre:
              'Vigas indep. de menos de 5” con acc. que carguen peso y se ext. mas 30”',
          codigo: 'B27',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Pallet stope faltante',
          codigo: 'P1',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Pallet stope dañado',
          codigo: 'P1(D)',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: '	Pallet stope fuera de su posición',
          codigo: 'P2',
          formato: 'F1'),
      Problemas(
          id: null, nombre: 'Pallet stope suelto', codigo: 'P4', formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Wire deck dañado',
          codigo: 'D18(R)',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Wire deck dañado',
          codigo: 'D18(G)',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Racks conectados o fijados a la estructura del edificio',
          codigo: 'S5',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Cantilever "NO" sobre concreto',
          codigo: 'C2',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Tuerca de cantilever faltante',
          codigo: 'A2(T)',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Faltante de ancla en cantilever',
          codigo: 'C3',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Refuerzo de cantilever faltante',
          codigo: 'C4',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Tornillo de cantilever faltante',
          codigo: 'C6, C7',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Brazo de cantilever mal instalado',
          codigo: 'C9, C10',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Columna de cantilever desnivelada',
          codigo: 'C11',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre:
              'Calzas múltiples de mas de 1 1/4” de altura no soldadas entre si',
          codigo: 'C12',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Calzas múltiples de mas de 3” de altura',
          codigo: 'C13',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Columna de cantilever dañada',
          codigo: 'C18, C19',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Columna de cantilever desalineada',
          codigo: 'C20',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Base de cantilever dañada',
          codigo: 'C21, C23',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Brazo de cantilever dañado',
          codigo: '	C25, C-26',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Nube de ilumiacion insegura',
          codigo: 'Nube de ilumiacion insegura',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Movimiento de Mercancia (reemplazo de bahia)',
          codigo: 'Movimiento de Mercancia (reemplazo de bahia)',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: '	Viga safada',
          codigo: '	Viga safada',
          formato: 'F1'),
      Problemas(
          id: null,
          nombre: 'Rack gutless cargando tarima',
          codigo: 'U10',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Extensiones soportando productos de peso extra',
          codigo: 'U19',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre:
              'Bahías con un solo nivel de viga (o 2 con menos de 24” de distancia)',
          codigo: 'B3',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre:
              'Distancia entre niveles de más de 36” con viga en nivel inf. de menos de 5”',
          codigo: 'B5',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre:
              'Marcos de 16” con el nivel de viga más bajo a una altura mayor a 120”',
          codigo: 'B13',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Vigas de 156” cargando categorías de peso extra',
          codigo: 'B15',
          formato: 'F2'),
      Problemas(
          id: null, nombre: 'Wire deck faltante', codigo: 'D1', formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Faltante de rejilla en tarimas con producto pesado',
          codigo: 'D7',
          formato: 'F2'),
      Problemas(
          id: null, nombre: 'Rejilla inadecuada', codigo: 'D15', formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Superficie sólida utilizada como decking',
          codigo: 'D17',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Tablón con separador faltante',
          codigo: 'D2',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Wire deck galvanizado faltante',
          codigo: 'D14',
          formato: 'F2'),
      Problemas(
          id: null, nombre: 'Wire deck dañado', codigo: 'D18', formato: 'F2'),
      Problemas(
          id: null,
          nombre:
              'Productos en tarima almacenados en cantilever sin crossbeams y decking',
          codigo: 'C15',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Tablaroca o acero de refuerzo almacenado en cantilever',
          codigo: 'C16',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre:
              'Atados que excedan los 8" que no estén contra rack, alguna pared o Cantilever',
          codigo: 'C17',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Marcos de 24", 36" y GU cargando tarimas',
          codigo: 'NOTA 1',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Faltante de tornillo box bolt en marcos ARU y GU',
          codigo: 'NOTA 2',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Tablones de madera a la interperie',
          codigo: 'NOTA 3',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Nivel de viga arriba de 144” con tarimas',
          codigo: 'NOTA 4',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Rejilla con inicio de oxidacón',
          codigo: 'Rejilla con inicio de oxidación',
          formato: 'F2'),
      Problemas(
          id: null,
          nombre: 'Rejila pintada en exterior',
          codigo: 'RP',
          formato: 'F2'),
      Problemas(id: null, nombre: '', codigo: '', formato: ''),
    ];

// Verificar si ya existen datos en la base de datos
    final List<Problemas> existingProblemas =
        await DatabaseProvider.showProblemas();
    if (existingProblemas.isEmpty) {
      // Insertar solo si la base de datos está vacía
      for (final problema in problemas) {
        DatabaseProvider.insertProblem(problema);
      }
      print('Datos insertados correctamente.');
    } else {
      print(
          'Los datos de problemas ya existen en la base de datos. No se realizaron inserciones.');
    }
  });
}

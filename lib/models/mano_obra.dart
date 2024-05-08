import 'package:app_inspections/services/db_offline.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Obra {
  int? id;
  String nombre;

  Obra({
    required this.id,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_obra': id,
      'nom_obra': nombre,
    };
  }
}

void insertInitialDataO() async {
  getDatabasesPath().then((databasePath) async {
    join(databasePath, 'conexsa.db');
    final List<Obra> obra = [
      Obra(id: null, nombre: 'Instalación de Marco'),
      Obra(id: null, nombre: 'Instalación de Viga'),
      Obra(id: null, nombre: 'Instalación de Bahía'),
      Obra(id: null, nombre: 'Instalación de base y Cantilever'),
      Obra(id: null, nombre: 'Instalación de Brazo de Cantilever'),
      Obra(id: null, nombre: 'Instalación de Ancla en Rack'),
      Obra(id: null, nombre: 'Instalación de Ancla en Cantilever'),
      Obra(id: null, nombre: 'Instalación de tornillo de seguridad'),
      Obra(id: null, nombre: 'Instalación de un Protector de Columna'),
      Obra(id: null, nombre: 'Instalación de Separador'),
      Obra(id: null, nombre: 'Instalación de Pallet Stope'),
      Obra(id: null, nombre: 'Instalación de Cross Bar'),
      Obra(id: null, nombre: 'Instalación de Red de Seguridad'),
      Obra(id: null, nombre: 'Instalación de Máquina de Cable o Alfo'),
      Obra(id: null, nombre: 'Viáticos'),
      Obra(id: null, nombre: 'Desmontaje de Marco'),
      Obra(id: null, nombre: 'Desmontaje de Viga'),
      Obra(id: null, nombre: 'Desmontaje de Bahía'),
      Obra(id: null, nombre: 'Desmontaje de base y Cantiliver'),
      Obra(id: null, nombre: 'Desmontaje de Brazo de Cantilever'),
      Obra(id: null, nombre: 'Apretar Ancla en Rack'),
      Obra(id: null, nombre: 'Apretar Ancla en Cantilever'),
      Obra(id: null, nombre: 'Desmontaje de Máquina de Cable o Alfi'),
      Obra(id: null, nombre: 'Enderezar Cabrilla de Marco'),
      Obra(id: null, nombre: 'Retiro / acomodo de Mercancía en bahia'),
      Obra(id: null, nombre: 'Girar rejilla 180°'),
      Obra(id: null, nombre: 'Desmontaje de rejilla'),
      Obra(id: null, nombre: 'Instalación de rejilla'),
      Obra(id: null, nombre: 'Desmontaje de protector de columna'),
      Obra(id: null, nombre: 'Desmontaje de Pallet Stop'),
      Obra(id: null, nombre: 'Recorrer y/o alinear bahía'),
      Obra(id: null, nombre: 'Recorrer y/o alinear marco'),
      Obra(id: null, nombre: 'Acomodar Pallet Stope'),
      Obra(id: null, nombre: 'Instalar tuerca en ancla'),
      Obra(id: null, nombre: 'Instalar tuerca en cantilever'),
      Obra(id: null, nombre: 'Otro MO'),
      Obra(id: null, nombre: 'Lijar y pintar'),
      Obra(id: null, nombre: 'Se recomienda bajar tarimas'),
      Obra(id: null, nombre: 'Se recomienda bajar nivel de viga'),
      Obra(id: null, nombre: 'Rejilla con inicio de oxidación'),
      Obra(id: null, nombre: 'Superficie solida utilizada como decking'),
      Obra(id: null, nombre: 'Instalar tuerca en cantilever'),
      Obra(id: null, nombre: 'Marcos de 24", 36" y GU cargando tarimas'),
      Obra(
          id: null, nombre: 'Faltante de tornillo box bolt en marcos ARU y GU'),
      Obra(id: null, nombre: 'Tabblones de madera a la interperie'),
    ];

    // Verificar si ya existen datos en la base de datos
    final List<Obra> existingObra = await DatabaseProvider.showObra();
    if (existingObra.isEmpty) {
      // Insertar solo si la base de datos está vacía
      for (final obr in obra) {
        DatabaseProvider.insertManoObra(obr);
      }
      print('Datos insertados correctamente.');
    } else {
      print(
          'Los datos de obra ya existen en la base de datos. No se realizaron inserciones.');
    }
  });
}

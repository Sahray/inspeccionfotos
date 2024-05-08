import 'package:app_inspections/services/db_offline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

enum AuthState { authenticated, unauthenticated }

class AuthService extends ChangeNotifier {
  AuthState _authState = AuthState.unauthenticated;
  AuthState get authState => _authState;

  String? _currentUser;
  String? get currentUser => _currentUser;

  final storage = const FlutterSecureStorage();

  // Método para establecer el nombre de usuario actual
  void setCurrentUser(String username) {
    _currentUser = username;
    notifyListeners(); // Notificar a los listeners que el estado ha cambiado
  }

/*   Future<String?> createUser(
      String name, String email, String contrasena) async {
    try {
      final connection = await openConnection();
      await connection.query(
          'INSERT INTO usuarios (nombre, email, password) VALUES (@name, @email, @contrasena)',
          substitutionValues: {
            'name': name,
            'email': email,
            'contrasena': contrasena
          });
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error al registrar usuario: $e');
      }
      return e.toString();
    }
  } */

  Future<String?> login(String nomUsu, String contrasena) async {
    try {
      Database database = await DatabaseProvider.openDB();
      final List<Map<String, dynamic>> results = await database.rawQuery(
        'SELECT nombre FROM usuarios WHERE nom_usu LIKE ? AND password LIKE ?',
        ['%$nomUsu%', '%$contrasena%'],
      );
      if (results.isNotEmpty) {
        final nombreCompleto = results[0]['nombre'] as String;
        setCurrentUser(nombreCompleto);
        _authState = AuthState.authenticated;
        notifyListeners();
        return null;
      } else {
        return 'Credenciales incorrectas';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al iniciar sesión: $e');
      }
      return e.toString();
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    _authState = AuthState.unauthenticated;
    notifyListeners();
    if (kDebugMode) {
      print('Usuario desconectado');
    }
  }
}

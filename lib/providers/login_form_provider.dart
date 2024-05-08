import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String name = '';
  String usuario = '';
  String password = '';
// Agregar campo para el nombre

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    if (kDebugMode) {
      print(formkey.currentState?.validate());
    }

    if (kDebugMode) {
      print('$usuario - $password');
    }

    //para ver si es formulario es valido
    return formkey.currentState?.validate() ?? false;
  }
}

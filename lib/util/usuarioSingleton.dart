import 'package:appsupreagro/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UsuarioSingleton extends ChangeNotifier {
  static final UsuarioSingleton _singleton = UsuarioSingleton._internal();
  Usuario? usuario;
  factory UsuarioSingleton() {
    return _singleton;
  }

  UsuarioSingleton._internal();
  void updateState() {
    try {
      notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }
}

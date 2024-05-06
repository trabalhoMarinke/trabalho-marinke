import 'dart:convert';

import 'package:appsupreagro/models/empresa.dart';
import 'package:appsupreagro/models/vendedor.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/dataStorageWrapper.dart';
import 'package:appsupreagro/util/usuarioSingleton.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Usuario {
  final int? id;
  final Vendedor? vendedor;
  final Empresa? empresa;
  final String nomeUsuario;
  final String senha;
  final String login;
  String? token;

  Usuario(
      {this.id,
      this.vendedor,
      this.empresa,
      required this.nomeUsuario,
      required this.senha,
      required this.login,
      this.token});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int?,
      vendedor: Vendedor.fromJson(json['vendedor']),
      empresa: Empresa.fromJson(json['empresa']),
      nomeUsuario: json['nomeUsuario'] as String,
      senha: json['senha'] as String,
      login: json['login'] as String,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendedor': vendedor?.toJson(),
      'empresa': empresa?.toJson(),
      'nomeUsuario': nomeUsuario,
      'senha': senha,
      'login': login,
      'token': token ?? ""
    };
  }

  Map<String, dynamic> toLoginJson() {
    return {
      'username': login,
      'password': senha,
    };
  }
}

Future<bool> login(Usuario usuario) async {
  final response = await http.post(
    Uri.parse('http://$address:8080/api/auth/login'),
    body: usuario.toLoginJson(),
  );

  if (response.statusCode == 200) {
    //retorna o token
    final Map<String, dynamic> body = json.decode(response.body);
    UsuarioSingleton().usuario = Usuario.fromJson(body["usuario"]);
    UsuarioSingleton().usuario?.token = body["accessToken"];
    Logger().i(UsuarioSingleton().usuario);
    return true;
  } else {
    return false;
  }
}

logout(DataStorageWrapper dataStorageWrapper) {
  UsuarioSingleton().usuario = null;
  dataStorageWrapper.clearUsuario();
  UsuarioSingleton().updateState();
}

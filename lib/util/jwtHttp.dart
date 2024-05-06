import 'dart:convert';

import 'package:appsupreagro/util/usuarioSingleton.dart';
import 'package:http/http.dart' as http0;

class http {
  static Future<http0.Response> get(Uri url) async {
    final response = await http0.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${UsuarioSingleton().usuario?.token}"
    });
    return response;
  }

  static Future<http0.Response> post(
      String url, Map<String, dynamic> body) async {
    final response = await http0.post(
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${UsuarioSingleton().usuario?.token}"
        },
        encoding: Encoding.getByName("utf-8"),
        Uri.parse(url));
    return response;
  }

  static Future<http0.Response> put(
      String url, Map<String, String> body) async {
    final response = await http0.put(Uri.parse(url), body: body);
    return response;
  }

  static Future<http0.Response> delete(String url) async {
    final response = await http0.delete(Uri.parse(url));
    return response;
  }
}

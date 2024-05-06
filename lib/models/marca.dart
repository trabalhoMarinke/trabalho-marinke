import 'package:appsupreagro/util/const.dart';
import 'dart:convert';

import 'package:appsupreagro/util/jwtHttp.dart';

class Marca {
  int id;
  String nomeMarca;
  int referencia;

  Marca({
    required this.id,
    required this.nomeMarca,
    this.referencia = 0,
  });
  @override
  String toString() {
    return nomeMarca;
  }

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id'],
      nomeMarca: json['nomeMarca'],
      referencia: json['referencia'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeMarca': nomeMarca,
      'referencia': referencia,
    };
  }
}

Future<List<Marca>> carregarMarcas() async {
  //carregar lista de marcas da api em http://localhost:8080/marca
  final response = await http.get(Uri.parse('http://$address:8080/marca'));
  if (response.statusCode == 200) {
    final List<dynamic> marcasJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<Marca> marcas =
        marcasJson.map((json) => Marca.fromJson(json)).toList();
    return marcas;
  } else {
    throw Exception('Falha ao carregar os produtos');
  }
}

Future<List<Marca>> carregarMarcasPorNome(String nome) async {
  //carregar lista de marcas da api em http://localhost:8080/marca
  final response =
      await http.get(Uri.parse('http://$address:8080/marca/nome/$nome'));
  if (response.statusCode == 200) {
    final List<dynamic> marcasJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<Marca> marcas =
        marcasJson.map((json) => Marca.fromJson(json)).toList();
    return marcas;
  } else {
    throw Exception('Falha ao carregar os produtos');
  }
}

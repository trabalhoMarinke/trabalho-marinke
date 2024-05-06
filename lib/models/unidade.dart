import 'package:appsupreagro/util/const.dart';


import 'dart:convert';

import 'package:appsupreagro/util/jwtHttp.dart';

class Unidade {
  int id;
  String nome;
  String codigo;
  int casasDecimais;
  int tipo;

  Unidade({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.casasDecimais,
    required this.tipo,
  });

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      id: json['id'],
      nome: json['nome'],
      codigo: json['codigo'],
      casasDecimais: json['casasDecimais'] ?? 0,
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'codigo': codigo,
      'casasDecimais': casasDecimais,
      'tipo': tipo,
    };
  }
}

Future<List<Unidade>> carregarUnidade() async {
  final response = await http.get(Uri.parse('http://$address:8080/unidade'));
  if (response.statusCode == 200) {
    final List<dynamic> unidadeJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<Unidade> unidades =
        unidadeJson.map((json) => Unidade.fromJson(json)).toList();
    return unidades;
  } else {
    throw Exception('Falha ao carregar as unidades');
  }
}

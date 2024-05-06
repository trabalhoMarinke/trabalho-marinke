import 'package:appsupreagro/util/const.dart';

import 'dart:convert';

import 'package:appsupreagro/util/jwtHttp.dart';

class TipoProduto {
  int? id;
  String nome;
  int? tipoGrupo;
  int? referencia;

  TipoProduto({
    required this.id,
    required this.nome,
    this.tipoGrupo,
    this.referencia,
  });

  factory TipoProduto.fromJson(Map<String, dynamic> json) {
    return TipoProduto(
      id: json['id'],
      nome: json['nome'],
      tipoGrupo: json['tipoGrupo'],
      referencia: json['referencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipoGrupo': tipoGrupo,
      'referencia': referencia,
    };
  }
}

Future<List<TipoProduto>> carregarTipoProduto() async {
  final response =
      await http.get(Uri.parse('http://$address:8080/tipoproduto'));
  if (response.statusCode == 200) {
    final List<dynamic> tiposProdutoJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<TipoProduto> tiposProduto =
        tiposProdutoJson.map((json) => TipoProduto.fromJson(json)).toList();
    return tiposProduto;
  } else {
    throw Exception('Falha ao carregar os tipos de produto');
  }
}

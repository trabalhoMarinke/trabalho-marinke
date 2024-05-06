import 'dart:convert';

import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/jwtHttp.dart';

class FormaPagamento {
  final int? id;
  final String descricao;

  FormaPagamento({
    this.id,
    required this.descricao,
  });

  factory FormaPagamento.fromJson(Map<String, dynamic> json) {
    return FormaPagamento(
      id: json['id'] as int?,
      descricao: json['descricao'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }
}
//Carregar formas de pagamento
Future<List<FormaPagamento>> carregarFormasPagamento() async {
  //carregar lista de marcas da api em http://localhost:8080/marca
  final response =
      await http.get(Uri.parse('http://$address:8080/formapagamento'));
  if (response.statusCode == 200) {
    final List<dynamic> formasPagamentoJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<FormaPagamento> formasPagamento = formasPagamentoJson
        .map((json) => FormaPagamento.fromJson(json))
        .toList();
    return formasPagamento;
  } else {
    throw Exception('Falha ao carregar as formas de pagamento');
  }
}
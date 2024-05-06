import 'package:appsupreagro/util/const.dart';
import 'dart:convert';

import 'package:appsupreagro/util/jwtHttp.dart';

class Vendedor {
  int id;
  String nome;
  // final Empresa empresa;

  Vendedor({required this.id, required this.nome});

  factory Vendedor.fromJson(Map<String, dynamic> json) => Vendedor(
        id: json['id'],
        nome: json['nome'],
        // empresa: Empresa.fromJson(json['empresa'])
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        // 'empresa': empresa.toJson(),
      };
}

Future<List<Vendedor>> carregarVendedores() async {
  final response = await http.get(Uri.parse('http://$address:8080/vendedor'));

  if (response.statusCode == 200) {
    final List<dynamic> vendedoresJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<Vendedor> vendedores =
        vendedoresJson.map((json) => Vendedor.fromJson(json)).toList();
    return vendedores;
  } else {
    throw Exception('Falha ao carregar os vendedores');
  }
}

Future<List<Vendedor>> buscarPorNome(String nomeVendedor) async {
  final response = await http
      .get(Uri.parse('http://$address:8080/vendedor/nome/$nomeVendedor'));

  if (response.statusCode == 200) {
    final List<dynamic> vendedoresJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<Vendedor> vendedores =
        vendedoresJson.map((json) => Vendedor.fromJson(json)).toList();
    return vendedores;
  } else {
    throw Exception('Falha ao carregar os vendedores');
  }
}

import 'package:appsupreagro/models/vendedor.dart';
import 'package:appsupreagro/util/const.dart';


import 'dart:convert';

import 'package:appsupreagro/util/jwtHttp.dart';

class Rota {
  int? id;
  Vendedor? vendedor;
  String? dsRota;

  Rota({
    this.id,
    this.vendedor,
    this.dsRota,
  });

  factory Rota.fromJson(Map<String, dynamic> json) {
    return Rota(
      id: json['id'],
      vendedor: (json['vendedo'] != null)
          ? Vendedor.fromJson(json['vendedor'])
          : null,
      dsRota: json['dsRota'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendedor': vendedor?.toJson(),
      'dsRota': dsRota,
    };
  }
}

Future<List<Rota>> carregarRotas() async {
  final response = await http.get(Uri.parse('http://$address:8080/rota'));
  if (response.statusCode == 200) {
    final List<dynamic> rotasJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<Rota> rotas =
        rotasJson.map((json) => Rota.fromJson(json)).toList();
    return rotas;
  } else {
    throw Exception('Falha ao carregar os produtos');
  }
}

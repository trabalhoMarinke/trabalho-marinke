import 'package:appsupreagro/models/cidade.dart';
import 'package:appsupreagro/models/rota.dart';
import 'package:appsupreagro/models/vendedor.dart';
import 'package:appsupreagro/util/const.dart';

import 'dart:convert';

import 'package:appsupreagro/util/jwtHttp.dart';

class Cliente {
  int? id;
  Cidade? cidade;
  Vendedor? vendedor;
  Rota? rota;
  String? nome;
  String? nomeFantasia;
  String? ruaEndereco;
  String? numeroEndereco;
  String? complemento;
  String? bairro;
  String? nmrCpfCnpj;
  String? observacao;

  Cliente({
    this.id,
    this.cidade,
    this.vendedor,
    this.rota,
    this.nome,
    this.nomeFantasia,
    this.ruaEndereco,
    this.numeroEndereco,
    this.complemento,
    this.bairro,
    this.nmrCpfCnpj,
    this.observacao,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      cidade: Cidade.fromJson(json['cidade']),
      vendedor: Vendedor.fromJson(json['vendedor']),
      rota: (json["rota"] != null) ? Rota.fromJson(json['rota']) : null,
      nome: json['nome'],
      nomeFantasia: json['nomeFantasia'],
      ruaEndereco: json['ruaEndereco'],
      numeroEndereco: json['numeroEndereco'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      nmrCpfCnpj: json['nmrCpfCnpj'],
      observacao: json['observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cidade': cidade?.toJson(),
      'vendedor': vendedor?.toJson(),
      'rota': rota?.toJson(),
      'nome': nome,
      'nomeFantasia': nomeFantasia,
      'ruaEndereco': ruaEndereco,
      'numeroEndereco': numeroEndereco,
      'complemento': complemento,
      'bairro': bairro,
      'nmrCpfCnpj': nmrCpfCnpj,
      'observacao': observacao,
    };
  }
}

Future<List<Cliente>> carregarClientes(Vendedor vendedor) async {
  final response = await http.get(Uri.parse('http://$address:8080/cliente/vendedor/${vendedor.id}'));
  if (response.statusCode == 200) {
    final List<dynamic> clientesJson =
        json.decode(utf8.decode(response.bodyBytes));
    final List<Cliente> clientes =
        clientesJson.map((json) => Cliente.fromJson(json)).toList();
    return clientes;
  } else {
    throw Exception('Falha ao carregar os clientes');
  }
}

import 'package:appsupreagro/models/cliente.dart';
import 'package:appsupreagro/models/empresa.dart';
import 'package:appsupreagro/models/forma_pagamento.dart';
import 'package:appsupreagro/models/produto.dart';
import 'package:appsupreagro/models/produto_saida.dart';
import 'package:appsupreagro/models/usuario.dart';
import 'package:appsupreagro/util/jwtHttp.dart';
import 'package:logger/logger.dart';

import '../util/const.dart';

class Pedido {
  String id;
  Cliente? cliente;
  Usuario usuario;
  Empresa empresa;
  Map<dynamic, int> produtos;
  DateTime dataPedido;
  DateTime dataEntrega;
  String observacao;
  FormaPagamento formaPagamento;
  DateTime dataPagamento;
  String? cpfClienteNovo;
  String? nomeClienteNovo;
  String? enderecoClienteNovo;
  String? numeroClienteNovo;
  bool? sincronizado;
  //SaidaStatus saidaStatus;

  Pedido({
    required this.id,
    required this.dataEntrega,
    this.cliente,
    required this.usuario,
    required this.empresa,
    required this.produtos,
    required this.dataPedido,
    required this.observacao,
    required this.formaPagamento,
    required this.dataPagamento,
    this.cpfClienteNovo,
    this.nomeClienteNovo,
    this.enderecoClienteNovo,
    this.numeroClienteNovo,
    this.sincronizado = false,
    //required this.saidaStatus,
  });
  // toJson
  Map<String, dynamic> toJson() {
    List<Produto> produtosList = [];
    produtos.forEach((key, value) {
      for (var i = 0; i < value; i++) {
        produtosList.add(key);
      }
    });
    return {
      'id': id,
      'cliente': (cliente != null) ? cliente?.toJson() : null,
      'usuario': usuario.toJson(),
      'empresa': empresa.toJson(),
      'produtos': produtosList.map((e) => e.toJson()).toList(),
      'dataPedido': dataPedido.toIso8601String(),
      'dataEntrega': dataEntrega.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento.toJson(),
      'dataPagamento': dataPagamento.toIso8601String(),
      'cpfClienteNovo': cpfClienteNovo ?? '',
      'nomeClienteNovo': nomeClienteNovo ?? '',
      'enderecoClienteNovo': enderecoClienteNovo ?? '',
      'numeroClienteNovo': numeroClienteNovo ?? '',
      'sincronizado': sincronizado,
      //'saidaStatus': saidaStatus.toJson(),
    };
  }

  Map<String, dynamic> toSyncJson() {
    List<ProdutoSaida> produtosList = [];
    produtos.forEach((key, value) {
      produtosList.add(ProdutoSaida.fromProduto(key, value.toDouble()));
    });
    return {
      'id': id,
      'cliente': (cliente != null) ? cliente?.toJson() : null,
      'usuario': usuario.toJson(),
      'empresa': empresa.toJson(),
      'produtos': produtosList.map((e) => e.toJson()).toList(),
      'dataPedido': dataPedido.toIso8601String(),
      'dataEntrega': dataEntrega.toIso8601String(),
      'observacao': observacao,
      'formaPagamento': formaPagamento.toJson(),
      'dataPagamento': dataPagamento.toIso8601String(),
      'cpfClienteNovo': cpfClienteNovo!.replaceAll(".", "").replaceAll("-", ""),
      'nomeClienteNovo': nomeClienteNovo ?? '',
      'enderecoClienteNovo': enderecoClienteNovo ?? '',
      'numeroClienteNovo': numeroClienteNovo ?? '',
      'sincronizado': sincronizado,
    };
  }

  // fromJson
  factory Pedido.fromJson(Map<String, dynamic> json) {
    final List<Produto> produtosList = (json['produtos'] as List<dynamic>)
        .map((produtoJson) => Produto.fromJson(produtoJson))
        .toList();

    final Map<int, int> produtos =
        {}; // Usar int como chave para o ID do produto
    for (var produto in produtosList) {
      final produtoId = produto.id;
      produtos.update(produtoId, (value) => (value) + 1, ifAbsent: () => 1);
    }
    final Map<Produto, int> produtosQuantidades = {};
    produtos.forEach((produtoId, quantidade) {
      final produto = produtosList.firstWhere((p) => p.id == produtoId);
      produtosQuantidades[produto] = quantidade;
    });

    return Pedido(
      id: json['id'] ?? "",
      cliente: (json['cliente'] != null && json['cliente']['id'] != null)
          ? Cliente.fromJson(json['cliente'])
          : null,

      usuario: Usuario.fromJson(json['usuario']),
      empresa: Empresa.fromJson(json['empresa']),

      produtos: produtosQuantidades,
      dataPedido: DateTime.parse(json['dataPedido']),
      dataEntrega: DateTime.parse(json['dataEntrega']),
      observacao: json['observacao'],
      formaPagamento: FormaPagamento.fromJson(json['formaPagamento']),
      dataPagamento: DateTime.parse(json['dataPagamento']),
      cpfClienteNovo: json['cpfClienteNovo'] ?? '',
      nomeClienteNovo: json['nomeClienteNovo'] ?? '',
      enderecoClienteNovo: json['enderecoClienteNovo'] ?? '',
      numeroClienteNovo: json['numeroClienteNovo'] ?? '',
      sincronizado: json['sincronizado'] ?? false,
      //saidaStatus: SaidaStatus.fromJson(json['saidaStatus']),
    );
  }

  double getValorPedido() {
    double valorPedido = 0.0;
    produtos.forEach((key, value) {
      double valorproduto = (key.valorSelecionado != null)
          ? key.valorSelecionado!
          : key.valorCheio;
      valorPedido += valorproduto * value;
    });
    return valorPedido;
  }
}

//enviar pedido para o servidor em http://localhost:8080/pedido
Future<bool> enviarPedido(Pedido pedido) async {
  Logger().i(pedido.toSyncJson());
  final response =
      await http.post('http://$address:8080/pedido', pedido.toSyncJson());
  if (response.statusCode == 200) {
    Logger().i('Pedido enviado com sucesso');
  } else {
    Logger().e('Erro ao enviar pedido');
    Logger().e(response.body);
    return false;
  }
  return true;
}

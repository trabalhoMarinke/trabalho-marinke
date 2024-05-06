import 'package:appsupreagro/models/produto.dart';

class ProdutoSaida {
  int id;
  Produto produto;
  double qtVenda;
  double valorUnitario;
  double pcDesconto;
  double valorDesconto;
  double valorTotalLiquido;
  double valorTotalBruto;
  double pcComissao;
  double valorComissao;

  ProdutoSaida({
    required this.id,
    required this.produto,
    required this.qtVenda,
    required this.valorUnitario,
    required this.pcDesconto,
    required this.valorDesconto,
    required this.valorTotalLiquido,
    required this.valorTotalBruto,
    required this.pcComissao,
    required this.valorComissao,
  });

  factory ProdutoSaida.fromProduto(Produto produto, double qtVenda) {
    double valorSelecionado = produto.valorSelecionado ?? produto.valorCheio;

    double pcDesconto =
        ((produto.valorCheio - valorSelecionado) / produto.valorCheio) * 100;

    double valorDesconto = produto.valorCheio - valorSelecionado;

    double pcComissao = 1.0; // 1% de comissão

    double valorComissao = (produto.valorCheio * pcComissao) / 100;

    double valorTotalBruto = qtVenda * valorSelecionado;
    double valorTotalLiquido = valorTotalBruto - valorDesconto;

    return ProdutoSaida(
      id: produto.id,
      produto: produto,
      qtVenda: qtVenda,
      valorUnitario: valorSelecionado,
      pcDesconto: pcDesconto,
      valorDesconto: valorDesconto,
      valorTotalLiquido: valorTotalLiquido,
      valorTotalBruto: valorTotalBruto,
      pcComissao: pcComissao,
      valorComissao: valorComissao,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produto': produto.toJson(), // Converte o produto para JSON
      'qtVenda': qtVenda,
      'valorUnitario': valorUnitario,
      'pcDesconto': pcDesconto,
      'valorDesconto': valorDesconto,
      'valorTotalLiquido': valorTotalLiquido,
      'valorTotalBruto': valorTotalBruto,
      'pcComissao': pcComissao,
      'valorComissao': valorComissao,
    };
  }

  factory ProdutoSaida.fromJson(Map<String, dynamic> json) {
    return ProdutoSaida(
      id: json['id'],
      produto:
          Produto.fromJson(json['produto']), // Converte o JSON para Produto
      qtVenda: json['qtVenda'],
      valorUnitario: json['valorUnitario'],
      pcDesconto: json['pcDesconto'],
      valorDesconto: json['valorDesconto'],
      valorTotalLiquido: json['valorTotalLiquido'],
      valorTotalBruto: json['valorTotalBruto'],
      pcComissao: json['pcComissao'],
      valorComissao: json['valorComissao'],
    );
  }
}

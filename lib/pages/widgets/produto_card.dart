import 'package:appsupreagro/models/produto.dart';
import 'package:appsupreagro/pages/widgets/dialog_valor_editar.dart';
import 'package:flutter/material.dart';

class ProdutoCard extends StatefulWidget {
  final Produto produto;
  final Function()? function;
  final int? quantidade;
  final TextEditingController? controller;
  const ProdutoCard(
      {super.key,
      required this.produto,
      required this.function,
      this.controller,
      this.quantidade});

  @override
  _ProdutoCardState createState() => _ProdutoCardState();
}

class _ProdutoCardState extends State<ProdutoCard> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Produto produto = widget.produto;
    return GestureDetector(
      onTap: widget.function,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 3, // Sombreamento do card
        margin: const EdgeInsets.all(10), // Margem ao redor do card
        child: Padding(
          padding: const EdgeInsets.all(10), // Preenchimento interno do card
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${produto.nome}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5), // Espaçamento entre os elementos

                  Text('Tipo: ${produto.tipoProduto.nome}',
                      style: const TextStyle(fontSize: 16)),
                  Text(
                    'Marca: ${produto.marca.nomeMarca}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text('Unidade: ${produto.unidade.nome}',
                      style: const TextStyle(fontSize: 16)),

                  Text("Contém: ${produto.unidades}",
                      style: const TextStyle(fontSize: 16)),
                  Text(
                    'Preço cheio: R\$${produto.valorCheio.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  (produto.valorDesconto < produto.valorCheio)
                      ? Text(
                          'Preço com Desconto: R\$${produto.valorDesconto.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        )
                      : Container(),
                  (produto.valorDesconto != 0.0 &&
                          widget.quantidade != null &&
                          (produto.valorCheio - produto.valorDesconto) > 0)
                      ? Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Valor selecionado: R\$${produto.valorSelecionado}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditarValorDialog(
                                        produto: produto, callback: callback);
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit_rounded),
                            )
                          ],
                        )
                      : Container(),
                  widget.quantidade != null
                      ? Text(
                          'Quantidade: ${widget.quantidade.toString()}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      : Container(),
                ],
              )),
              //quantidade em caso de ser um pedido
            ],
          ),
        ),
      ),
    );
  }
}

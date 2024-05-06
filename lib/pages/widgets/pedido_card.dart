import 'package:flutter/material.dart';
import 'package:appsupreagro/models/pedido.dart';
import 'package:intl/intl.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;

  const PedidoCard({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    String nome = (pedido.cliente != null)
        ? '- ${pedido.cliente!.nome}'
        : '- ${pedido.nomeClienteNovo}';
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido # ${DateFormat("dd/MM/yyyy").format(pedido.dataPedido)} $nome',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (pedido.cliente != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cliente: ${pedido.cliente!.nome}'),
                  Text('Rota: ${pedido.cliente!.rota?.dsRota}'),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cliente: ${pedido.nomeClienteNovo}'),
                  Text('Endereço: ${pedido.enderecoClienteNovo}'),
                ],
              ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black),
            // Text(
            // 'Data do Pedido: ${DateFormat("dd/MM/yyyy").format(pedido.dataPedido)}'),
            Text(
                'Data de Entrega: ${DateFormat("dd/MM/yyyy").format(pedido.dataEntrega)}'),
            Text('Vendedor: ${pedido.usuario.vendedor?.nome}'),
            Text(
              'Valor Total: R\$${pedido.getValorPedido().toStringAsFixed(2)}',
            ),
            Text('Sincronizado loja: ${pedido.sincronizado}'),
          ],
        ),
      ),
    );
  }
}

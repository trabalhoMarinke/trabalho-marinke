import 'package:flutter/material.dart';
import 'package:appsupreagro/models/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback function;

  const ClienteCard({
    super.key,
    required this.cliente,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cliente.nome ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Text(
                'Cidade: ${cliente.cidade?.nome ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Vendedor: ${cliente.vendedor?.nome ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Rota: ${cliente.rota?.dsRota ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              (cliente.ruaEndereco!=null)?Text(
                'Endereço: ${cliente.ruaEndereco ?? ''}, ${cliente.numeroEndereco ?? ''}',
                style: const TextStyle(fontSize: 16),
              ): Container(),
              Text(
                'Bairro: ${cliente.bairro ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

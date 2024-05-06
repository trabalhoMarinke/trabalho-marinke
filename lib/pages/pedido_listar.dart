import 'package:appsupreagro/pages/widgets/pedido_card.dart';
import 'package:appsupreagro/models/pedido.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/dataStorageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../util/reusable.dart';

class ListarPedidos extends StatefulWidget {
  final DataStorageWrapper dataStorageWrapper;
  const ListarPedidos({super.key, required this.dataStorageWrapper});

  @override
  State<ListarPedidos> createState() => _ListarPedidosState();
}

class _ListarPedidosState extends State<ListarPedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pedidos')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<List<Pedido>>(
                future: widget.dataStorageWrapper.getPedidos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Enquanto os dados estão sendo carregados
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro
                    Logger().e(snapshot.stackTrace);
                    return Center(
                      child: Text(
                          'Erro ao carregar os pedidos: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Se não houver dados ou a lista estiver vazia
                    return const Center(
                      child: Text('Nenhum pedido encontrado.'),
                    );
                  } else {
                    // Se os dados foram carregados com sucesso
                    final pedidos = snapshot.data;

                    return Column(children: [
                      Text('Total de pedidos - mês atual: ${pedidos!.length}'),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pedidos.length,
                          itemBuilder: (context, index) {
                            final pedido = pedidos[index];
                            return Row(children: [
                              Expanded(
                                  child: Column(
                                      children: [PedidoCard(pedido: pedido)])),

                              //ações
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      //pedir confirmação
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Confirmação'),
                                              content: const Text(
                                                  'Deseja realmente excluir o pedido?'),
                                              actions: [
                                                OutlinedButton(
                                                    style: outlineButtonStyle,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Não')),
                                                OutlinedButton(
                                                    style: outlineButtonStyle,
                                                    onPressed: () async {
                                                      await widget
                                                          .dataStorageWrapper
                                                          .deletePedido(pedido);
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                    child: const Text('Sim')),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                          context, '/fazerPedido',
                                          arguments: pedido);
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Icon(
                                    Icons.check_circle,
                                    color: pedido.sincronizado!
                                        ? Colors.green
                                        : Colors.grey,
                                  )
                                ],
                              )
                            ]);
                          },
                        ),
                      )
                    ]);
                  }
                },
              )),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                    style: outlineButtonStyle,
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/fazerPedido');
                      setState(() {});
                    },
                    child: const Text('Novo Pedido'),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton.icon(
                    style: outlineButtonStyle,
                    onPressed: () async {
                      await widget.dataStorageWrapper
                          .sendPedidos()
                          .then((value) => {
                                if (value == true)
                                  {
                                    showSnack(
                                        'Pedido sincronizado com sucesso!',
                                        context)
                                  }
                                else
                                  {
                                    showSnack(
                                        'Erro ao sincronizar pedido, tente sair e fazer login novamente. Nenhum pedido será perdido!',
                                        context)
                                  }
                              });
                      setState(() {});
                    },
                    label: const Text('Sincronizar pedido'),
                    icon: const Icon(Icons.sync),
                  ))
                ],
              )
            ],
          ),
        ));
  }
}

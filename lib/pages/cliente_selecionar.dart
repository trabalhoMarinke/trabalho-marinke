import 'package:appsupreagro/models/cliente.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/dataStorageWrapper.dart';
import 'package:appsupreagro/pages/widgets/cliente_card.dart';
import 'package:appsupreagro/util/sync.dart';
import 'package:flutter/material.dart';

class SelecaoCliente extends StatefulWidget {
  DataStorageWrapper dataStorageWrapper;
  SelecaoCliente({super.key, required this.dataStorageWrapper});

  @override
  State<SelecaoCliente> createState() => _SelecaoClienteState();
}

class _SelecaoClienteState extends State<SelecaoCliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Seleção de Cliente'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //limpar selecao
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: outlineButtonStyle,
                          onPressed: () async {
                            syncClientes();
                            Navigator.pop(context, null);
                          },
                          child: const Text("Atualizar lista clientes")),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: outlineButtonStyle,
                          onPressed: () {
                            Navigator.pop(context, null);
                          },
                          child: const Text("Limpar seleção")),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: FutureBuilder(
                  future: widget.dataStorageWrapper.getClientes(),
                  builder: (context, AsyncSnapshot<List<Cliente>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ClienteCard(
                            cliente: snapshot.data![index],
                            function: () {
                              Navigator.pop(context, snapshot.data![index]);
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )),
              ],
            )));
  }
}

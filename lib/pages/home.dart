import 'package:appsupreagro/main.dart';
import 'package:appsupreagro/models/usuario.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  // final DataStorageWrapper dataStorageWrapper;
  // const Home({super.key, required this.dataStorageWrapper});
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 15,
          actions: [
            IconButton(
                onPressed: () {
                  logout(dataStorageWrapper!);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout))
          ],
          title: Row(
            children: [
              Image.asset('lib/assets/images/launcher.png', height: 30),
              const SizedBox(width: 10),
              const Text('SupreAgro')
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                        style: outlineButtonStyle,
                        onPressed: () {
                          Navigator.pushNamed(context, '/fazerPedido');
                        },
                        child: const Text("Fazer pedido")))
              ]),
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                        style: outlineButtonStyle,
                        onPressed: () {
                          Navigator.pushNamed(context, '/listarPedidos');
                        },
                        child: const Text("Listar pedidos não sincronizados")))
              ])
            ],
          ),
        ));
  }
}

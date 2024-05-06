import 'package:appsupreagro/pages/home.dart';
import 'package:appsupreagro/pages/pedido_listar.dart';
import 'package:appsupreagro/pages/login.dart';
import 'package:appsupreagro/pages/cliente_selecionar.dart';
import 'package:appsupreagro/pages/produto_selecionar.dart';
import 'package:appsupreagro/repository/db.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/dataStorageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';

import 'pages/pedido_emitir.dart';

DataStorageWrapper? dataStorageWrapper;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Conexao.instance.initDB();

  // sync();
  try {
    runApp(const MyApp());
  } catch (e) {
    Logger().e(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          title: 'SupreAgro',
          debugShowCheckedModeBanner: false,
          routes: {
            '/login': (context) => const Login(),
            '/home': (context) => const Home(),
            '/fazerPedido': (context) => CadastroPedidos(
                  dataStorageWrapper: dataStorageWrapper!,
                ),
            '/selecaoProduto': (context) => SelecaoProduto(
                  dataStorageWrapper: dataStorageWrapper!,
                ),
            '/selecaoCliente': (context) => SelecaoCliente(
                  dataStorageWrapper: dataStorageWrapper!,
                ),
            '/listarPedidos': (context) => ListarPedidos(
                  dataStorageWrapper: dataStorageWrapper!,
                ),
          },
          theme: ThemeData(
            colorSchemeSeed: supreAgro,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
                foregroundColor: supreAgro,
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(color: supreAgro, fontSize: 20)),
          ),
          initialRoute: "/login",
        ));
  }
}

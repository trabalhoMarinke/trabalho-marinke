import 'package:appsupreagro/models/cliente.dart';
import 'package:appsupreagro/models/forma_pagamento.dart';
import 'package:appsupreagro/models/marca.dart';
import 'package:appsupreagro/models/produto.dart';
import 'package:appsupreagro/models/rota.dart';
import 'package:appsupreagro/models/produto_tipo.dart';
import 'package:appsupreagro/models/unidade.dart';
import 'package:appsupreagro/models/usuario.dart';
import 'package:appsupreagro/models/vendedor.dart';
import 'package:appsupreagro/util/dataStorageWrapper.dart';
import 'package:appsupreagro/util/sharedPreferencesHelper.dart';
import 'package:appsupreagro/util/usuarioSingleton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

void sync() async {
  var logger = Logger();
  final connectivityResult = await (Connectivity().checkConnectivity());

  SharedPreferencesHelper sharedPreferencesHelper =
      await SharedPreferencesHelper.getInstance();
  final dataStorageWrapper = DataStorageWrapper(sharedPreferencesHelper);
  //a sincronização so pode ser feita se o usuário estiver logado, ou seja se o token existir
  UsuarioSingleton().usuario = await dataStorageWrapper.getUsuario();
  if (UsuarioSingleton().usuario?.token == null) {
    logger.i("não sincronizou, usuário não logado!");
    UsuarioSingleton().updateState();
    return;
  } else {
    Logger().i("sincronizou, usuário logado!");
    try {
      // FlutterNativeSplash.remove();
      UsuarioSingleton().updateState();
    } catch (e) {
      logger.e(e);
    }
  }
  try {
    if (!sharedPreferencesHelper.hasRecentSync<Produto>("produtos") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza

      dataStorageWrapper.saveProdutos(await carregarProdutos());
      logger.i("Sincronizou produtos!");
    } else {
      // carrega do shared preferences

      logger.i(
          "carregou ${(await dataStorageWrapper.getProdutos()).length} produtos do shared preferences");
    }

    if (!sharedPreferencesHelper.hasRecentSync<Vendedor>("vendedores") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza
      dataStorageWrapper.saveVendedores(await carregarVendedores());
      logger.i("sincronizou vendedores");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou ${(await dataStorageWrapper.getVendedores()).length} vendedores do shared preferences");
    }

    //Sincronizar Marca

    if (!sharedPreferencesHelper.hasRecentSync<Marca>("marcas") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza
      dataStorageWrapper.saveMarcas(await carregarMarcas());
      logger.i("sincronizou marcas");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou ${(await dataStorageWrapper.getMarcas()).length} marcas do shared preferences");
    }

    //rotas
    if (!sharedPreferencesHelper.hasRecentSync<Marca>("rotas") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza
      dataStorageWrapper.saveRotas(await carregarRotas());
      logger.i("sincronizou rotas");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou ${(await dataStorageWrapper.getRotas()).length} rotas do shared preferences");
    }

    //clientes
    if (!sharedPreferencesHelper.hasRecentSync<Marca>("clientes") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza
      dataStorageWrapper.saveClientes(
          await carregarClientes(UsuarioSingleton().usuario!.vendedor!));
      logger.i("sincronizou clientes");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou ${(await dataStorageWrapper.getClientes()).length} clientes do shared preferences");
    }

    //tipoProdutos
    if (!sharedPreferencesHelper.hasRecentSync<Marca>("tipoProdutos") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza
      dataStorageWrapper.saveTipoProdutos(await carregarTipoProduto());
      logger.i("sincronizou tipoProdutos");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou ${(await dataStorageWrapper.getTipoProdutos()).length} tipoProdutos do shared preferences");
    }

    //unidades
    if (!sharedPreferencesHelper.hasRecentSync<Marca>("unidades") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza
      dataStorageWrapper.saveUnidades(await carregarUnidade());
      logger.i("sincronizou unidades");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou ${(await dataStorageWrapper.getUnidades()).length} unidades do shared preferences");
    }

    //UsuarioSingleton
    if (!sharedPreferencesHelper.hasRecentSync<Marca>("usuario") &&
        connectivityResult != ConnectivityResult.none &&
        UsuarioSingleton().usuario != null) {
      // sincroniza
      dataStorageWrapper.saveUsuario(UsuarioSingleton().usuario!);
      logger.i("sincronizou usuario");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou usuário ${(await dataStorageWrapper.getUsuario())?.token} do shared preferences");
    }

    //formas de pagamento
    if (!sharedPreferencesHelper.hasRecentSync<Marca>("formasPagamento") &&
        connectivityResult != ConnectivityResult.none) {
      // sincroniza
      dataStorageWrapper.saveFormasPagamento(await carregarFormasPagamento());
      logger.i("sincronizou formasPagamento");
    } else {
      // carrega do shared preferences
      logger.i(
          "carregou ${(await dataStorageWrapper.getFormasPagamento()).length} formasPagamento do shared preferences");
    }
  } catch (e) {
    logger.e(e);
    if (connectivityResult != ConnectivityResult.none) {
      logout(dataStorageWrapper);
    }
  }

  //saidaStatus
  /* if (!sharedPreferencesHelper.hasRecentSync<Marca>("saidaStatus") &&
      connectivityResult != ConnectivityResult.none) {
    // sincroniza
    dataStorageWrapper.saveSaidaStatus(await carregarSaidaStatus());
    logger.i("sincronizou saidaStatus");
  } else {
    // carrega do shared preferences
    logger.i(
        "carregou ${(await dataStorageWrapper.getSaidaStatus()).length} saidaStatus do shared preferences");
  }*/
}

void syncClientes() async {
  var logger = Logger();
  SharedPreferencesHelper sharedPreferencesHelper =
      await SharedPreferencesHelper.getInstance();
  final dataStorageWrapper = DataStorageWrapper(sharedPreferencesHelper);
  // //a sincronização so pode ser feita se o usuário estiver logado, ou seja se o token existir
  // UsuarioSingleton().usuario = await dataStorageWrapper.getUsuario();
  // if (UsuarioSingleton().usuario?.token == null) {
  //   logger.i("não sincronizou, usuário não logado!");
  //   UsuarioSingleton().updateState();
  // }
  await sharedPreferencesHelper.clear('clientes');
  dataStorageWrapper.saveClientes(
      await carregarClientes(UsuarioSingleton().usuario!.vendedor!));
  logger.i("sincronizou clientes");
}

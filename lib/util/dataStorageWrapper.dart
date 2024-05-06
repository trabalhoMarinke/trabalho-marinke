import 'package:appsupreagro/models/cliente.dart';
import 'package:appsupreagro/models/forma_pagamento.dart';
import 'package:appsupreagro/models/marca.dart';
import 'package:appsupreagro/models/produto.dart';
import 'package:appsupreagro/models/rota.dart';
import 'package:appsupreagro/models/saida_status.dart';
import 'package:appsupreagro/models/produto_tipo.dart';
import 'package:appsupreagro/models/unidade.dart';
import 'package:appsupreagro/models/usuario.dart';
import 'package:appsupreagro/models/vendedor.dart';
import 'package:appsupreagro/models/pedido.dart';
import 'package:appsupreagro/util/sharedPreferencesHelper.dart';
import 'package:logger/logger.dart';

class DataStorageWrapper {
  final SharedPreferencesHelper _prefsHelper;

  DataStorageWrapper(this._prefsHelper);

  Future<void> saveProdutos(List<Produto> produtos) async {
    _prefsHelper.registerLastSyncTime<Produto>("produtos");
    await _prefsHelper.saveList('produtos', produtos);
  }

  Future<List<Produto>> getProdutos() async {
    return _prefsHelper.getList('produtos', (json) => Produto.fromJson(json));
  }

  Future<void> saveClientes(List<Cliente> clientes) async {
    _prefsHelper.registerLastSyncTime<Cliente>("clientes");
    await _prefsHelper.saveList('clientes', clientes);
  }

  Future<List<Cliente>> getClientes() async {
    return _prefsHelper.getList('clientes', (json) => Cliente.fromJson(json));
  }

  //rotas
  Future<void> saveRotas(List<Rota> rotas) async {
    _prefsHelper.registerLastSyncTime<Rota>("rotas");
    await _prefsHelper.saveList('rotas', rotas);
  }

  Future<List<Rota>> getRotas() async {
    return _prefsHelper.getList('rotas', (json) => Rota.fromJson(json));
  }

  Future<void> saveVendedores(List<Vendedor> vendedores) async {
    _prefsHelper.registerLastSyncTime<Vendedor>("vendedores");
    await _prefsHelper.saveList('vendedores', vendedores);
  }

  Future<List<Vendedor>> getVendedores() async {
    return _prefsHelper.getList(
        'vendedores', (json) => Vendedor.fromJson(json));
  }

  Future<void> saveMarcas(List<Marca> marcas) async {
    _prefsHelper.registerLastSyncTime<Marca>("marcas");
    await _prefsHelper.saveList('marcas', marcas);
  }

  Future<List<Marca>> getMarcas() async {
    return _prefsHelper.getList('marcas', (json) => Marca.fromJson(json));
  }

  Future<void> saveTipoProdutos(List<TipoProduto> tipoProdutos) async {
    _prefsHelper.registerLastSyncTime<TipoProduto>("tipoProdutos");
    await _prefsHelper.saveList('tipoProdutos', tipoProdutos);
  }

  Future<List<TipoProduto>> getTipoProdutos() async {
    return _prefsHelper.getList(
        'tipoProdutos', (json) => TipoProduto.fromJson(json));
  }

  //unidade
  Future<void> saveUnidades(List<Unidade> unidades) async {
    _prefsHelper.registerLastSyncTime<Unidade>("unidades");
    await _prefsHelper.saveList('unidades', unidades);
  }

  Future<List<Unidade>> getUnidades() async {
    return _prefsHelper.getList('unidades', (json) => Unidade.fromJson(json));
  }

  Future<List<Produto>> getProdutosFiltradosPorNome(String nome) async {
    final produtos = await getProdutos();
    if (nome.isEmpty) {
      return produtos;
    } else {
      final nomeFiltrado = nome.toLowerCase(); // Converter para minúsculas
      return produtos
          .where((produto) => produto.nome.toLowerCase().contains(nomeFiltrado))
          .toList();
    }
  }

  Future<List<Produto>> getProdutosFiltradosPorMarca(String marcaNome) async {
    final produtos = await getProdutos();
    if (marcaNome.isEmpty) {
      return produtos;
    } else {
      final marcaNomeFiltrado =
          marcaNome.toLowerCase(); // Converter para minúsculas
      return produtos
          .where((produto) =>
              produto.marca.nomeMarca.toLowerCase().contains(marcaNomeFiltrado))
          .toList();
    }
  }

  //Usuario
  Future<void> saveUsuario(Usuario usuario) async {
    _prefsHelper.registerLastSyncTime<Usuario>("usuario");
    await _prefsHelper.saveMap('usuario', usuario.toJson());
  }

  Future<Usuario?> getUsuario() async {
    try {
      return Usuario.fromJson(await _prefsHelper.getMap('usuario'));
    } catch (e) {
      return null;
    }
  }

  //limpar usuário
  Future<void> clearUsuario() async {
    await _prefsHelper.clear('usuario');
  }

  //limpar tudo
  Future<void> clearAll() async {
    await _prefsHelper.clearAll(); //excluir todos os dados
    // await _prefsHelper.clear('produtos');
    // await _prefsHelper.clear('marcas');
    // await _prefsHelper.clear('rotas');
    // await _prefsHelper.clear('clientes');
    // await _prefsHelper.clear('tipoProdutos');
    // await _prefsHelper.clear('unidades');
    // await _prefsHelper.clear('formasPagamento');
  }

  //formas de pagamento
  Future<void> saveFormasPagamento(List<FormaPagamento> formasPagamento) async {
    _prefsHelper.registerLastSyncTime<FormaPagamento>("formasPagamento");
    await _prefsHelper.saveList('formasPagamento', formasPagamento);
  }

  Future<List<FormaPagamento>> getFormasPagamento() async {
    return _prefsHelper.getList(
        'formasPagamento', (json) => FormaPagamento.fromJson(json));
  }

  //salvar lista de pedidos
  Future<void> savePedidos(List<Pedido> pedidos) async {
    _prefsHelper.registerLastSyncTime<Pedido>("pedidos");
    await _prefsHelper.saveList('pedidos', pedidos);
  }

//salvar pedido
  Future<void> savePedido(Pedido pedido) async {
    // _prefsHelper.registerLastSyncTime<Pedido>("pedido");
    pedido.sincronizado = true;
    await _prefsHelper.saveMap('pedido', pedido.toJson());
  }

  //recuperar lista de pedidos
  Future<List<Pedido>> getPedidos() async {
    return _prefsHelper.getList('pedidos', (json) => Pedido.fromJson(json));
  }

  //deletar pedido
  Future<void> deletePedido(Pedido pedido) async {
    final pedidos = await getPedidos();
    pedidos.removeWhere((element) => element.id == pedido.id);
    await savePedidos(pedidos);
  }

  //enviar pedidos
  Future<bool> sendPedidos() async {
    final pedidos = await getPedidos();
    for (var pedido in pedidos) {
      if (pedido.sincronizado == false) {
        pedido.sincronizado = true;
        var result = await enviarPedido(pedido);
        Logger().i(result);
        if (result) {
          //_removerPedidoLocal();
          if (pedidos.any((element) => element.id == pedido.id)) {
            pedidos.removeWhere((element) => element.id == pedido.id);
          }
          await savePedidos(pedidos);
          //
        }
        return result;
      }
    }
    //for
    // savePedidos(pedidos);
    return false;
  }

  //status saida
  Future<void> saveSaidaStatus(List<SaidaStatus> saidaStatus) async {
    _prefsHelper.registerLastSyncTime<SaidaStatus>("saidaStatus");
    await _prefsHelper.saveList('saidaStatus', saidaStatus);
  }

  Future<List<SaidaStatus>> getSaidaStatus() async {
    return _prefsHelper.getList(
        'saidaStatus', (json) => SaidaStatus.fromJson(json));
  }
}

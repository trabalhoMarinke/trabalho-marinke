import 'package:appsupreagro/models/produto.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/dataStorageWrapper.dart';
import 'package:appsupreagro/pages/widgets/dialog_filtro.dart';
import 'package:appsupreagro/pages/widgets/produto_card.dart';
import 'package:flutter/material.dart';

class SelecaoProduto extends StatefulWidget {
  final DataStorageWrapper dataStorageWrapper;
  const SelecaoProduto({super.key, required this.dataStorageWrapper});

  @override
  State<SelecaoProduto> createState() => _SelecaoProdutoState();
}

class _SelecaoProdutoState extends State<SelecaoProduto> {
  String selectedEmpresa = "Todas";
  bool filtrar = false;
  String filtroNome = "";
  bool filtroMarca = false;
  bool filtroTipoProduto = false;
  String tipoProdutoSelecionado = "Todos";
  bool filtroUnidade = false;
  String unidadeSelecionada = "Todas";

  @override
  void initState() {
    super.initState();
  }

  Future<List<Produto>> getProdutos() async {
    Future<List<Produto>> produtos;
    if (filtrar && filtroNome.isNotEmpty) {
      produtos =
          widget.dataStorageWrapper.getProdutosFiltradosPorNome(filtroNome);
    } else {
      produtos = widget.dataStorageWrapper.getProdutos();
    }
    if (filtroMarca && selectedEmpresa.isNotEmpty) {
      // Filtrar por marca
      produtos = produtos.then((produtos) => produtos
          .where((produto) => produto.marca.nomeMarca == selectedEmpresa)
          .toList());
    }
    if (filtroTipoProduto && tipoProdutoSelecionado.isNotEmpty) {
      // Filtrar por tipo de produto
      produtos = produtos.then((produtos) => produtos
          .where(
              (produto) => produto.tipoProduto.nome == tipoProdutoSelecionado)
          .toList());
    }
    if (filtroUnidade && unidadeSelecionada.isNotEmpty) {
      // Filtrar por unidade
      produtos = produtos.then((produtos) => produtos
          .where((produto) => produto.unidade.nome == unidadeSelecionada)
          .toList());
    }
    return produtos;
  }

  void _showFiltroDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FiltroDialog(
          dataStorageWrapper: widget.dataStorageWrapper,
          onEmpresaChanged: (String newValue) {
            if (selectedEmpresa == "Todas" && newValue == "Todas") {
              return;
            } else if (newValue == "Todas") {
              setState(() {
                filtroMarca = false;
                selectedEmpresa = "";
              });
            } else {
              setState(() {
                selectedEmpresa = newValue; // Atualize a empresa selecionada
                filtroMarca = true;
              });
            }
          },
          onTipoProdutoChanged: (String newValue) {
            setState(() {
              if (tipoProdutoSelecionado == "Todos" && newValue == "Todos") {
                return;
              } else if (newValue == "Todos") {
                setState(() {
                  filtroTipoProduto = false;
                  tipoProdutoSelecionado = "";
                });
              } else {
                setState(() {
                  filtroTipoProduto = true;
                  tipoProdutoSelecionado = newValue;
                });
              }
            });
          },
          onUnidadeChanged: (String newValue) {
            setState(() {
              if (unidadeSelecionada == "Todas" && newValue == "Todas") {
                return;
              } else if (newValue == "Todas") {
                setState(() {
                  filtroUnidade = false;
                  unidadeSelecionada = "";
                });
              } else {
                setState(() {
                  filtroUnidade = true;
                  unidadeSelecionada = newValue;
                });
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //listar produtos e retornar o item selecionado
      appBar: AppBar(
        title: const Text("Produto"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campos de busca por nome ou nome de marca
              Padding(
                padding: const EdgeInsets.all(8),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height:
                              48, // Defina a altura do container conforme necessário
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Pesquisar',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                filtroNome = value;
                                filtrar = false;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          style: outlineButtonStyle,
                          onPressed: () {
                            if (filtroNome.isNotEmpty) {
                              setState(() {
                                filtrar = true;
                              });
                            }
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Pesquisar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Row(
                      children: [
                        OutlinedButton.icon(
                            style: outlineButtonStyle,
                            onPressed: _showFiltroDialog,
                            icon: const Icon(Icons.filter_alt_outlined),
                            label: const Text("Filtrar")),
                        const SizedBox(
                          width: 10,
                        ),
                        OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                filtroNome = "";
                                filtrar = false;
                                filtroMarca = false;
                                selectedEmpresa = "Todas";
                                filtroTipoProduto = false;
                                tipoProdutoSelecionado = "Todos";
                                filtroUnidade = false;
                                unidadeSelecionada = "Todas";
                              });
                            },
                            style: outlineButtonStyle,
                            icon: const Icon(Icons.clear, color: Colors.red),
                            label: const Text("Limpar filtros")),
                      ],
                    ),
                  )),

              // Lista de produtos
              FutureBuilder<List<Produto>>(
                future: getProdutos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data?.isEmpty == false) {
                    return Column(
                      children: [
                        Text('${snapshot.data?.length} Produtos encontrados'),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          key: UniqueKey(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return ProdutoCard(
                              produto: snapshot.data![index],
                              function: () {
                                Navigator.pop(context, snapshot.data![index]);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.data?.isEmpty ?? false) {
                    return const Text("Nenhum produto encontrado");
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:appsupreagro/models/marca.dart';
import 'package:appsupreagro/models/produto_tipo.dart';
import 'package:appsupreagro/models/unidade.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/dataStorageWrapper.dart';
import 'package:flutter/material.dart';

class FiltroDialog extends StatefulWidget {
  final DataStorageWrapper dataStorageWrapper;
  final Function(String) onEmpresaChanged;
  final Function(String) onTipoProdutoChanged;
  final Function(String) onUnidadeChanged;

  const FiltroDialog(
      {super.key,
      required this.onEmpresaChanged,
      required this.dataStorageWrapper,
      required this.onTipoProdutoChanged,
      required this.onUnidadeChanged});

  @override
  _FiltroDialogState createState() => _FiltroDialogState();
}

class _FiltroDialogState extends State<FiltroDialog> {
  String? marcaSelecionada = "";
  String? tipoProdutoSelecionado = "";
  String? unidadeSelecionada = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dropdown para selecionar a empresa

          FutureBuilder<List<Marca>>(
            future: widget.dataStorageWrapper.getMarcas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Aguarde enquanto os dados estão sendo carregados
              } else if (snapshot.hasError) {
                return const Text(
                    'Erro ao carregar as marcas'); // Trate erros, se houver
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                    'Nenhuma marca disponível'); // Lida com o caso de nenhuma marca estar disponível
              } else {
                final marcas = snapshot.data!;
                //adicionar uma marca na posição 0
                marcas.insert(0, Marca(nomeMarca: "Todas", id: 0));
                if (marcaSelecionada == "") {
                  marcaSelecionada = marcas[0].nomeMarca;
                }

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                  value: marcaSelecionada,
                  onChanged: (String? newValue) {
                    setState(() {
                      marcaSelecionada = newValue;
                    });
                  },
                  items: marcas.map((Marca marca) {
                    return DropdownMenuItem<String>(
                      value: marca.nomeMarca,
                      child: Text(marca.nomeMarca),
                    );
                  }).toList(),
                );
              }
            },
          ),
          Row(
            children: [
              Expanded(
                  child: FutureBuilder<List<TipoProduto>>(
                future: widget.dataStorageWrapper.getTipoProdutos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Aguarde enquanto os dados estão sendo carregados
                  } else if (snapshot.hasError) {
                    return const Text(
                        'Erro ao carregar os tipos de produto'); // Trate erros, se houver
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                        'Nenhum tipo de produto disponível'); // Lida com o caso de nenhum tipo de produto estar disponível
                  } else {
                    List<TipoProduto> tiposProduto = snapshot.data!;
                    tiposProduto.insert(
                        0, TipoProduto(id: null, nome: "Todos"));
                    if (tipoProdutoSelecionado == "") {
                      tipoProdutoSelecionado = tiposProduto[0].nome;
                    }

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Produto',
                        labelStyle: TextStyle(fontSize: 16),
                      ),
                      value: tipoProdutoSelecionado,
                      onChanged: (String? newValue) {
                        setState(() {
                          tipoProdutoSelecionado = newValue;
                        });
                      },
                      items: tiposProduto.map((TipoProduto tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo.nome,
                          child: Text(
                              tipo.nome.length > 18
                                  ? '${tipo.nome.substring(0, 18)}...'
                                  : tipo.nome,
                              overflow: TextOverflow.fade),
                        );
                      }).toList(),
                    );
                  }
                },
              ))
            ],
          ),
          FutureBuilder<List<Unidade>>(
            future: widget.dataStorageWrapper.getUnidades(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Aguarde enquanto os dados estão sendo carregados
              } else if (snapshot.hasError) {
                return const Text(
                    'Erro ao carregar as unidades'); // Trate erros, se houver
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                    'Nenhuma unidade disponível'); // Lida com o caso de nenhuma unidade estar disponível
              } else {
                List<Unidade> unidades = snapshot.data!;
                unidades.insert(
                    0,
                    Unidade(
                        nome: "Todas",
                        id: 0,
                        casasDecimais: 0,
                        codigo: '',
                        tipo: 0));
                if (unidadeSelecionada == "") {
                  unidadeSelecionada = unidades[0].nome;
                }

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Unidade',
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                  value: unidadeSelecionada,
                  onChanged: (String? newValue) {
                    setState(() {
                      unidadeSelecionada = newValue;
                    });
                  },
                  items: unidades.map((Unidade unidade) {
                    return DropdownMenuItem<String>(
                      value: unidade.nome,
                      child: Text(unidade.nome),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        OutlinedButton.icon(
          style: outlineButtonStyle,
          onPressed: () {
            Navigator.of(context).pop(); // Feche o diálogo
          },
          icon: const Icon(Icons.close),
          label: const Text('Fechar'),
        ),
        OutlinedButton.icon(
          style: outlineButtonStyle,
          onPressed: () {
            widget.onEmpresaChanged(marcaSelecionada!);
            widget.onTipoProdutoChanged(tipoProdutoSelecionado!);
            widget.onUnidadeChanged(unidadeSelecionada!);
            Navigator.of(context).pop(); // Feche o diálogo
          },
          icon: const Icon(Icons.filter_alt_outlined),
          label: const Text('Filtrar'),
        ),
      ],
    );
  }
}

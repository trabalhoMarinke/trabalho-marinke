import 'package:appsupreagro/models/cliente.dart';
import 'package:appsupreagro/models/forma_pagamento.dart';
import 'package:appsupreagro/models/pedido.dart';
import 'package:appsupreagro/models/produto.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/usuarioSingleton.dart';
import 'package:appsupreagro/pages/widgets/produto_card.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../util/dataStorageWrapper.dart';

class CadastroPedidos extends StatefulWidget {
  final DataStorageWrapper dataStorageWrapper;

  const CadastroPedidos({super.key, required this.dataStorageWrapper});

  @override
  State<CadastroPedidos> createState() => _CadastroPedidosState();
}

class _CadastroPedidosState extends State<CadastroPedidos> {
  Map<Produto, int> produtos = <Produto, int>{};
  Cliente? cliente;
  FormaPagamento? formaPagamento;
  List<FormaPagamento>? formasPagamento;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dataPagamento = DateTime.now();
  int pagina = 0;
  //controllers para os campos de texto
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerCPF = TextEditingController();
  final TextEditingController _controllerEndereco = TextEditingController();
  final TextEditingController _controllerNumero = TextEditingController();
  final TextEditingController _controllerObservacao = TextEditingController();
  final uuid = const Uuid();
  Pedido? pedido;

  @override
  void didChangeDependencies() {
    //Logger().i("didChangeDependencies");
    super.didChangeDependencies();
    setState(() {
      pedido = ModalRoute.of(context)!.settings.arguments as Pedido?;
      if (pedido != null) {
        produtos = pedido!.produtos as Map<Produto, int>;
        cliente = pedido!.cliente;
        formaPagamento = pedido!.formaPagamento;
        dataPagamento = pedido!.dataPagamento;
        //atualizar controllers
        _controllerNome.text = pedido!.nomeClienteNovo ?? "";
        _controllerCPF.text = pedido!.cpfClienteNovo ?? "";
        _controllerEndereco.text = pedido!.enderecoClienteNovo ?? "";
        _controllerNumero.text = pedido!.numeroClienteNovo ?? "";
        _controllerObservacao.text = pedido!.observacao;
      }
    });
  }

  Future<void> _selectDatePagamento(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 380)));

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        dataPagamento = pickedDate;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  DateTime combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    // SaidaStatus? saidaStatus;
    widget.dataStorageWrapper
        .getFormasPagamento()
        .then((value) => formasPagamento = value);
    Future<void> openSelecaoProdutoForResult(BuildContext context) async {
      try {
        final Produto result =
            await Navigator.of(context).pushNamed("/selecaoProduto") as Produto;
        if (!mounted) return;
        setState(() {
          produtos[result] = 1;
        });
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(result.nome)));
      } catch (e) {
        print("erro, usuário não selecionou produto");
      }
    }

    Future<void> openSelecaoClienteForResult(BuildContext context) async {
      try {
        final Cliente result =
            await Navigator.of(context).pushNamed("/selecaoCliente") as Cliente;
        if (!mounted) return;
        setState(() {
          cliente = result;
        });
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(result.nome ?? '')));
      } catch (e) {
        setState(() {
          cliente = null;
        });
      }
    }

    criarPedido() {
      if (pedido == null) {
        pedido = Pedido(
          // empresa: UsuarioSingleton().usuario!.vendedor!.empresa!,
          empresa: UsuarioSingleton().usuario!.empresa!,
          id: uuid.v4(),
          cliente: cliente ?? Cliente(),
          produtos: produtos,
          usuario: UsuarioSingleton().usuario!,
          dataPedido: DateTime.now(),
          dataEntrega: combineDateTime(selectedDate, selectedTime),
          formaPagamento: formaPagamento!,
          dataPagamento: dataPagamento,
          observacao: _controllerObservacao.text,
          cpfClienteNovo: _controllerCPF.text,
          enderecoClienteNovo: _controllerEndereco.text,
          nomeClienteNovo: _controllerNome.text,
          numeroClienteNovo: _controllerNumero.text,
          sincronizado: false,
          //saidaStatus: saidaStatus!
        );
        return;
      } else {
        // if (saidaStatus != pedido?.saidaStatus) {
        //   pedido?.saidaStatus = saidaStatus!;
        // }
        pedido = Pedido(
          id: pedido!.id,
          cliente: cliente ?? Cliente(),
          empresa: UsuarioSingleton().usuario!.empresa!,

          produtos: produtos,
          usuario: UsuarioSingleton().usuario!,
          dataPedido: DateTime.now(),
          dataEntrega: combineDateTime(selectedDate, selectedTime),
          formaPagamento: formaPagamento!,
          dataPagamento: dataPagamento,
          observacao: _controllerObservacao.text,
          cpfClienteNovo: _controllerCPF.text,
          enderecoClienteNovo: _controllerEndereco.text,
          nomeClienteNovo: _controllerNome.text,
          numeroClienteNovo: _controllerNumero.text,
          sincronizado: false,
          //saidaStatus: (pedido?.saidaStatus)!
        );
        return;
      }
    }

    void salvarPedido() async {
      //verificar se cliente não for selecionado, exigir que o usuário preencha os dados
      if (cliente == null) {
        if (_controllerNome.text == "" ||
            _controllerCPF.text == "" ||
            _controllerEndereco.text == "" ||
            _controllerNumero.text == "") {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text(
                    "Preencha todos os campos para cadastrar um novo cliente")));
          return;
        }
      }

      if (formaPagamento != null) {
        List<Pedido> pedidos = await widget.dataStorageWrapper.getPedidos();
        criarPedido();
        //substituir pedido, se já existir
        if (pedidos.any((element) => element.id == pedido!.id)) {
          pedidos.removeWhere((element) => element.id == pedido!.id);
        }
        pedidos.add(pedido!);
        Logger().i(pedidos);
        Logger().i(pedido!.toJson());
        widget.dataStorageWrapper.savePedidos(pedidos);

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Selecione uma forma de pagamento")));
      }
    }

    final PageController pageController = PageController();
    final tela1 = Column(children: [
      //seleção de clientes
      Row(children: [
        Expanded(
            child: OutlinedButton.icon(
                style: outlineButtonStyle,
                onPressed: () {
                  openSelecaoClienteForResult(context);
                },
                icon: const Icon(Icons.person),
                label: Text(
                  cliente?.nome ?? "Selecione um cliente",
                ))),
      ]),
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Expanded(
              child: OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  style: outlineButtonStyle,
                  onPressed: () {
                    openSelecaoProdutoForResult(context);
                  },
                  label: const Text("Adicionar produto")))
        ],
      ),
      (produtos.isNotEmpty)
          ? const Text("Produtos:", style: TextStyle(fontSize: 20))
          : Container(),
      Expanded(
        child: ListView.builder(
            controller: controller,
            itemCount: produtos.length,
            itemBuilder: (BuildContext context, int index) {
              Produto produto = produtos.keys.elementAt(index);
              final valorSelecionadoController = TextEditingController(
                  text: produto.valorSelecionado?.toStringAsFixed(2));
              return Row(
                children: [
                  Expanded(
                      child: Column(children: [
                    Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          produtos.remove(produto);
                        });
                      },
                      child: ProdutoCard(
                          controller: valorSelecionadoController,
                          produto: produto,
                          function: () {
                            setState(() {
                              produto.valorSelecionado = double.tryParse(
                                  valorSelecionadoController.text);
                              produtos = produtos;
                              //atualizar valor total
                            });
                          },
                          quantidade: produtos[produto]),
                    )
                  ])),
                  Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              produtos.remove(produto);
                            });
                          },
                          child: const Icon(Icons.delete)),
                      TextButton(
                          //aumentar quantidade
                          onPressed: () {
                            setState(() {
                              produtos[produto] = produtos[produto]! + 1;
                            });
                          },
                          child: const Icon(Icons.add)),
                      TextButton(
                          //diminuir quantidade
                          onPressed: () {
                            if (produtos[produto]! > 1) {
                              setState(() {
                                produtos[produto] = produtos[produto]! - 1;
                              });
                            }
                          },
                          child: const Icon(Icons.remove)),
                    ],
                  )
                ],
              );
            }),
      ),
    ]);
    final tela2 = SingleChildScrollView(
        child: Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Forma de Pagamento',
          ),
          value:
              (formasPagamento != null) ? formaPagamento?.id.toString() : "1",
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                formaPagamento = formasPagamento?.firstWhere(
                    (element) => element.id.toString() == newValue);
              });
            }
          },
          items: formasPagamento
              ?.map<DropdownMenuItem<String>>((FormaPagamento value) {
            return DropdownMenuItem<String>(
              value: value.id.toString(),
              child: Text(value.descricao),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            OutlinedButton.icon(
                style: outlineButtonStyle,
                onPressed: () {
                  _selectDatePagamento(context);
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  "Data de Vencimento: ${dataPagamento.day}/${dataPagamento.month}/${dataPagamento.year}",
                ))
          ],
        ),
        Row(
          //data de entrega
          children: [
            Expanded(
                child: OutlinedButton.icon(
                    style: outlineButtonStyle,
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      "Data de entrega: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    ))),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: OutlinedButton.icon(
                    style: outlineButtonStyle,
                    onPressed: () {
                      _selectTime(context);
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      "Horário de entrega: ${selectedTime.hour}:${selectedTime.minute}",
                    ))),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        (cliente == null)
            ? Column(
                children: [
                  TextFormField(
                    controller: _controllerNome,
                    decoration: const InputDecoration(
                      labelText: 'Nome do cliente',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CPF do cliente',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    controller: _controllerCPF,
                  ),
                  TextFormField(
                    controller: _controllerEndereco,
                    decoration: const InputDecoration(
                      labelText: 'Endereço do cliente',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Número do cliente',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    controller: _controllerNumero,
                  ),
                ],
              )
            : Container(),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Observação',
          ),
          controller: _controllerObservacao,
        ),
      ],
    ));
    return Scaffold(
        appBar: AppBar(
          elevation: 15,
          title: const Text('Cadastro de Pedido'),
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Expanded(
                        child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [tela1, tela2],
                    )),
                  ]))),
          (produtos.isNotEmpty)
              ? Card(
                  elevation: 5,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                              "Valor: R\$ ${produtos.keys.map((e) => e.valorSelecionado! * produtos[e]!).reduce((value, element) => value + element).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20,
                                color: supreAgro,
                                fontWeight: FontWeight.bold,
                              )),
                          (pagina == 0)
                              ? OutlinedButton(
                                  style: outlineButtonStyle,
                                  onPressed: () {
                                    Logger().i(produtos);
                                    //ir para proxima tela

                                    setState(() {
                                      pagina = 1;
                                    });
                                    pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeIn);
                                  },
                                  child: const Center(
                                      child: Row(
                                    children: [
                                      Text("Finalizar pedido"),
                                      Spacer(),
                                      Icon(Icons.navigate_next)
                                    ],
                                  )))
                              : OutlinedButton(
                                  style: outlineButtonStyle,
                                  onPressed: () {
                                    salvarPedido();
                                  },
                                  child: const Row(
                                    children: [
                                      Text("Salvar pedido"),
                                      Spacer(),
                                      Icon(Icons.save)
                                    ],
                                  )),
                          //botão de voltar caso esteja na segunda tela
                          (pagina == 1)
                              ? OutlinedButton(
                                  style: outlineButtonStyle,
                                  onPressed: () {
                                    setState(() {
                                      pagina = 0;
                                    });
                                    pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeIn);
                                  },
                                  child: const Center(
                                      child: Row(
                                    children: [
                                      Icon(Icons.navigate_before),
                                      Text("Voltar"),
                                    ],
                                  )))
                              : Container(),
                        ],
                      )),
                )
              : Container()
        ]));
  }
}

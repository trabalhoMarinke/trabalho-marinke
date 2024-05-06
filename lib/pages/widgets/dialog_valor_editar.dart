import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/produto.dart';

class EditarValorDialog extends StatefulWidget {
  final Produto produto;
  final Function? callback;

  const EditarValorDialog({super.key, required this.produto, this.callback});

  @override
  _EditarValorDialogState createState() => _EditarValorDialogState();
}

class _EditarValorDialogState extends State<EditarValorDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.produto.valorSelecionado!.toStringAsFixed(2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Valor Selecionado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Valor máximo: ${widget.produto.valorCheio.toStringAsFixed(2)}"),
          Text(
              "Valor mínimo: ${widget.produto.valorDesconto.toStringAsFixed(2)}"),
          TextFormField(
            controller: _controller,
            decoration:
                const InputDecoration(labelText: 'Novo Valor Selecionado'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^(\d+)?(\.\d{0,2})?$')),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final newValue = double.tryParse(_controller.text);
            if (newValue != null &&
                newValue <= widget.produto.valorCheio &&
                newValue >= widget.produto.valorDesconto) {
              setState(() {
                widget.produto.valorSelecionado = newValue;
              });
              widget.callback!();
              Navigator.of(context).pop(); // Fecha o Dialog após salvar
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

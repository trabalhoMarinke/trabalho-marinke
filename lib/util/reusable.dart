import 'package:flutter/material.dart';

void showSnack(String mensagem, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(mensagem), duration:  const Duration(milliseconds: 1000)));
}

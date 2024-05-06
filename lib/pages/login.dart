import 'package:appsupreagro/main.dart';
import 'package:appsupreagro/models/usuario.dart';
import 'package:appsupreagro/util/const.dart';
import 'package:appsupreagro/util/reusable.dart';
import 'package:appsupreagro/util/sync.dart';
import 'package:appsupreagro/util/usuarioSingleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UsuarioSingleton usuarioSingleton = UsuarioSingleton();

  //controllers
  final TextEditingController _controllerLogin = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  IconData iconeVisibilidade = Icons.visibility;
  bool showText = false;

  @override
  void initState() {
    super.initState();
    _controllerLogin.addListener(() {
      final String text = _controllerLogin.text.toLowerCase();
      _controllerLogin.value = _controllerLogin.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _controllerSenha.addListener(() {
      final String text = _controllerSenha.text.toLowerCase();
      _controllerSenha.value = _controllerSenha.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    if (usuarioSingleton.usuario != null &&
        usuarioSingleton.usuario?.token != null) {
      Logger().i(usuarioSingleton.usuario?.token);
      navegar();
    }
  }

  void navegar() {
    Navigator.pushReplacementNamed(context, '/fazerPedido');
  }

  //verificar se os inputs são validos e fazer login. Caso não, mostrar mensagem de erro
  void fazerLogin() async {
    if (_controllerLogin.text != "" && _controllerSenha.text != "") {
      await login(Usuario(
              nomeUsuario: "",
              senha: _controllerSenha.text,
              login: _controllerLogin.text))
          .then((value) => {
                if (value == true)
                  {
                    // sync(),
                    // dataStorageWrapper?.saveUsuario(usuarioSingleton.usuario!),
                    navegar(),
                  }
                else
                  {showSnack("Usuário ou senha incorretos.", context)}
              });
    } else {
      showSnack("Preencha todos os campos!", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    /*
    UsuarioSingleton().addListener(() {
      Logger().i("Iniciando verificação de credenciais...");
      try {
        if (UsuarioSingleton().usuario != null &&
            UsuarioSingleton().usuario?.token != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
        FlutterNativeSplash.remove();
      } catch (e) {
        Navigator.pushReplacementNamed(context, '/login');
        FlutterNativeSplash.remove();
      }
    });
    */

    //tela de login
    return Scaffold(
        appBar: AppBar(
          title: const Text('SupreAgro'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: Column(children: [
            Image.asset('lib/assets/images/logo.png', width: 200, height: 200),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login',
              ),
              controller: _controllerLogin,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showText = !showText;
                        if (showText) {
                          iconeVisibilidade = Icons.visibility_off;
                        } else {
                          iconeVisibilidade = Icons.visibility;
                        }
                      });
                    },
                    icon: Icon(iconeVisibilidade)),
                labelText: 'Senha',
              ),
              obscureText: !showText,
              controller: _controllerSenha,
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Logger().i("ZAP");
                    fazerLogin();
                  },
                  style: outlineButtonStyle.copyWith(
                      elevation: MaterialStateProperty.all<double>(2),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(supreAgro),
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                          fontSize: 20,
                          foreground: Paint()..color = Colors.white))),
                  child: const Text("Entrar"),
                ),
              )
            ])
          ])),
        ));
  }
}

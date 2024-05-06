import 'package:appsupreagro/util/const.dart';
import 'dart:convert';
import 'package:appsupreagro/util/jwtHttp.dart';

class SaidaStatus {
  int id;
  String dsStatus;

  SaidaStatus({
    required this.id,
    required this.dsStatus,
  });

  factory SaidaStatus.fromJson(Map<String, dynamic> json) {
    return SaidaStatus(
      id: json['id'],
      dsStatus: json['dsStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dsStatus': dsStatus,
    };
  }
}

Future<List<SaidaStatus>> carregarSaidaStatus() async {
  final response =
      await http.get(Uri.parse('http://$address:8080/saidaStatus'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((saidaStatus) => SaidaStatus.fromJson(saidaStatus))
        .toList();
  } else {
    throw Exception('Falha ao carregar lista de saidaStatus da API');
  }
}

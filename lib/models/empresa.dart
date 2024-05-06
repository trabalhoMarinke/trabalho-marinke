

class Empresa {
  final int? id;
  final String nome;

  Empresa({this.id, required this.nome});

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'] as int?,
      nome: json['nome'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }
}

class Cidade {
  int? id;
  String? nome;
  String? estado;

  Cidade({
    this.id,
    this.nome,
    this.estado,
  });

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      id: json['id'],
      nome: json['nome'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'estado': estado,
    };
  }
}

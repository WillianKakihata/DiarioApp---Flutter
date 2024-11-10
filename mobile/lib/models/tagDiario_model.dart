class tagDiario {
  String nomeTag;
  String descricaoTag;

  tagDiario({required this.nomeTag, required this.descricaoTag});

  factory tagDiario.fromJson(Map<String, dynamic> json) {
    return tagDiario(
      nomeTag: json['nome_tag'] ?? '',
      descricaoTag: json['descricaoTag'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_tag': nomeTag,
      'descricaoTag': descricaoTag,
    };
  }
}
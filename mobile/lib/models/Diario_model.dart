import 'package:mobile/models/tagDiario_model.dart';

class DiarioModel {
  final String id;
  final DateTime data;
  final String titulo;
  final String conteudo;
  final tagDiario tag;

  DiarioModel({
    required this.id,
    required this.data,
    required this.titulo,
    required this.conteudo,
    required this.tag,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'titulo': titulo,
      'conteudo': conteudo,
      'tag': tag.toJson(),
    };
  }

  factory DiarioModel.fromJson(Map<String, dynamic> json) {
    return DiarioModel(
      id: json['id'],
      data: DateTime.parse(json['data']),
      titulo: json['titulo'],
      conteudo: json['conteudo'],
      tag: tagDiario.fromJson(json['tag']),
    );
  }
}

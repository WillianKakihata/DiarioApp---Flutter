import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/Diario_model.dart';

const baseUrl = "http://localhost:3000";

abstract class AbstractApi {
  final String recurso;
  final http.Client https;

  AbstractApi(this.recurso, this.https);

  Future<List<dynamic>> getAll() async {
    var resposta = await https.get(Uri.parse(baseUrl + '/$recurso'));
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('[Problema] Erro ao buscar: $recurso');
    }
  }

  Future<dynamic> posts(DiarioModel diario) async {
    var resposta = await https.post(
      Uri.parse(baseUrl + '/$recurso'),
      body: jsonEncode(diario.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (resposta.statusCode == 201) {
      print("Processo concluído");
    } else {
      throw Exception("[PROBLEMA] Erro ao adicionar: $recurso");
    }
  }

  Future<dynamic> update(String id, DiarioModel diario) async {
    var resposta = await https.put(
      Uri.parse(baseUrl + '/$recurso/$id'),
      body: jsonEncode(diario.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (resposta.statusCode == 200) {
      print("Processo atualizado");
    } else {
      throw Exception("[Problema] Erro ao atualizar: $recurso");
    }
  }

  Future<dynamic> delete(String id) async {
    var resposta =
        await https.delete(Uri.parse(baseUrl + '/$recurso/$id'));
    if (resposta.statusCode == 200) {
      print("Registro excluído com sucesso");
    } else {
      throw Exception("Erro ao excluir: $recurso");
    }
  }
}

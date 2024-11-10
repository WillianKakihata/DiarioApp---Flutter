import 'package:mobile/models/Diario_model.dart';
import 'package:mobile/service/abstract_api.dart';
import 'package:http/http.dart' as http;

class DiarioService extends AbstractApi {
  DiarioService({http.Client? client})
      : super('RegistroDiario', client ?? http.Client());

  @override
  Future<List<DiarioModel>> getAll() async {
    final response = await super.getAll();
    return response.map((diarioJson) => DiarioModel.fromJson(diarioJson)).toList();
  }

  Future<void> postDiario(DiarioModel diario) async {
    await posts(diario);
  }

  Future<void> updateDiario(String id, DiarioModel diario) async {
    await update(id, diario);
  }

  Future<void> deleteDiario(String id) async {
    await delete(id);
  }
}

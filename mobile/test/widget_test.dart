import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'package:mobile/service/Diario_service.dart';
import 'package:mobile/models/Diario_model.dart';
import 'package:mobile/models/tagDiario_model.dart';

@GenerateMocks([http.Client])

import 'widget_test.mocks.dart';

void main() {
  group('DiarioService', () {
    late DiarioService diarioService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      diarioService = DiarioService(client: mockClient);
    });

    test('getAll should return a list of DiarioModel objects', () async {
      final mockResponse = jsonEncode([
        {
          'id': '1',
          'data': '2024-11-09T00:00:00.000',
          'titulo': 'Meu Diário',
          'conteudo': 'Conteúdo do diário',
          'tag': {'nome_tag': 'importante', 'descricaoTag': 'Tag de importância'}
        }
      ]);

      when(mockClient.get(Uri.parse('http://localhost:3000/RegistroDiario')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await diarioService.getAll();

      expect(result, isA<List<DiarioModel>>());
      expect(result.length, 1);
      expect(result[0].titulo, 'Meu Diário');
    });

    test('postDiario should call posts with correct data', () async {
      final diario = DiarioModel(
        id: '1',
        data: DateTime.parse('2024-11-09T00:00:00.000'),
        titulo: 'Meu Diário',
        conteudo: 'Conteúdo do diário',
        tag: tagDiario(nomeTag: 'importante', descricaoTag: 'Tag de importância'),
      );

      final mockResponse = http.Response('{"message": "success"}', 201);

      when(mockClient.post(
        Uri.parse('http://localhost:3000/RegistroDiario'),
        body: jsonEncode(diario.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => mockResponse);

      await diarioService.postDiario(diario);

      verify(mockClient.post(
        Uri.parse('http://localhost:3000/RegistroDiario'),
        body: jsonEncode(diario.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).called(1);
    });

    test('deleteDiario should delete a diario by id', () async {
      final mockResponse = http.Response('{"message": "success"}', 200);

      when(mockClient.delete(Uri.parse('http://localhost:3000/RegistroDiario/1')))
          .thenAnswer((_) async => mockResponse);

      await diarioService.deleteDiario('1');

      verify(mockClient.delete(Uri.parse('http://localhost:3000/RegistroDiario/1')))
          .called(1);
    });
  });
}

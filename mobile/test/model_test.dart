import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/diario_model.dart';
import 'package:mobile/models/tagDiario_model.dart';

void main() {
  group('DiarioModel', () {
    test('Deve criar uma instância de DiarioModel corretamente', () {
      final tag = tagDiario(nomeTag: 'Importante', descricaoTag: 'Descrição importante');
      final diario = DiarioModel(
        id: '1',
        data: DateTime(2024, 11, 9),
        titulo: 'Meu Diário',
        conteudo: 'Conteúdo do diário',
        tag: tag,
      );

      expect(diario.id, '1');
      expect(diario.data, DateTime(2024, 11, 9));
      expect(diario.titulo, 'Meu Diário');
      expect(diario.conteudo, 'Conteúdo do diário');
      expect(diario.tag.nomeTag, 'Importante');
    });

    test('Deve converter DiarioModel para JSON corretamente', () {
      final tag = tagDiario(nomeTag: 'Importante', descricaoTag: 'Descrição importante');
      final diario = DiarioModel(
        id: '1',
        data: DateTime(2024, 11, 9),
        titulo: 'Meu Diário',
        conteudo: 'Conteúdo do diário',
        tag: tag,
      );

      final json = diario.toJson();

      expect(json['id'], '1');
      expect(json['data'], '2024-11-09T00:00:00.000');
      expect(json['titulo'], 'Meu Diário');
      expect(json['conteudo'], 'Conteúdo do diário');
      expect(json['tag']['nome_tag'], 'Importante');
    });
  });
}

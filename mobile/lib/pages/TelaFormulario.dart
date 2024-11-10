import 'package:flutter/material.dart';
import 'package:mobile/models/Diario_model.dart';
import 'package:mobile/models/tagDiario_model.dart';
import 'package:mobile/service/Diario_service.dart';

class TelaFormulario extends StatefulWidget {
  final DiarioModel? diario;
  final Function onDiarioAdded;

  TelaFormulario({super.key, this.diario, required this.onDiarioAdded});

  @override
  _TelaFormularioState createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _conteudoController = TextEditingController();
  String _nomeTag = '';
  String _descricaoTag = '';

  @override
  void initState() {
    super.initState();
    if (widget.diario != null) {
      _tituloController.text = widget.diario!.titulo;
      _conteudoController.text = widget.diario!.conteudo;
      _nomeTag = widget.diario!.tag.nomeTag;
      _descricaoTag = widget.diario!.tag.descricaoTag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diario == null ? 'Adicionar Novo Diário' : 'Editar Diário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _conteudoController,
              decoration: InputDecoration(labelText: 'Conteúdo'),
            ),
            TextField(
              onChanged: (value) {
                _nomeTag = value;
              },
              decoration: InputDecoration(labelText: 'Nome da Tag'),
              controller: TextEditingController(text: _nomeTag),
            ),
            TextField(
              onChanged: (value) {
                _descricaoTag = value;
              },
              decoration: InputDecoration(labelText: 'Descrição da Tag'),
              controller: TextEditingController(text: _descricaoTag),
            ),
            ElevatedButton(
              onPressed: () {
                _salvarDiario();
              },
              child: Text(widget.diario == null ? 'Salvar Diário' : 'Atualizar Diário'),
            ),
          ],
        ),
      ),
    );
  }

  void _salvarDiario() {
    if (_tituloController.text.isNotEmpty && _conteudoController.text.isNotEmpty) {
      tagDiario tag = tagDiario(
        nomeTag: _nomeTag.isNotEmpty ? _nomeTag : 'Sem Tag',
        descricaoTag: _descricaoTag.isNotEmpty ? _descricaoTag : 'Sem descrição',
      );

      DiarioModel novoDiario = DiarioModel(
        id: widget.diario?.id ?? '1',
        data: DateTime.now(),
        titulo: _tituloController.text,
        conteudo: _conteudoController.text,
        tag: tag,
      );

      if (widget.diario == null) {
        DiarioService().postDiario(novoDiario).then((_) {
          widget.onDiarioAdded();
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar diário: $error')),
          );
        });
      } else {
        DiarioService().updateDiario(widget.diario!.id, novoDiario).then((_) {
          widget.onDiarioAdded();
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar diário: $error')),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }
}

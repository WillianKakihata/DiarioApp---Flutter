import 'package:flutter/material.dart';
import 'package:mobile/models/Diario_model.dart';
import 'package:mobile/service/Diario_service.dart';
import 'package:mobile/pages/TelaFormulario.dart';

class TelaListagem extends StatefulWidget {
  final Future<List<DiarioModel>> futureDiarios;

  const TelaListagem({Key? key, required this.futureDiarios}) : super(key: key);

  @override
  _TelaListagemState createState() => _TelaListagemState();
}

class _TelaListagemState extends State<TelaListagem> {
  late Future<List<DiarioModel>> _futureDiarios;

  @override
  void initState() {
    super.initState();
    _futureDiarios = widget.futureDiarios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Diários'),
      ),
      body: FutureBuilder<List<DiarioModel>>(
        future: _futureDiarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum diário registrado.'));
          } else {
            final diarios = snapshot.data!;
            return ListView.builder(
              itemCount: diarios.length,
              itemBuilder: (context, index) {
                final diario = diarios[index];
                return Card(
                  child: ListTile(
                    title: Text(diario.titulo),
                    subtitle: Text(diario.conteudo),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editarDiario(context, diario);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _confirmarExclusao(context, diario.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _editarDiario(BuildContext context, DiarioModel diario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaFormulario(
          diario: diario,
          onDiarioAdded: _atualizarLista,
        ),
      ),
    );
  }

  void _atualizarLista() {
    setState(() {
      _futureDiarios = DiarioService().getAll();
    });
  }

  void _confirmarExclusao(BuildContext context, String diarioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Diário'),
          content: Text('Tem certeza que deseja excluir este diário?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _excluirDiario(context, diarioId);
                Navigator.pop(context);
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _excluirDiario(BuildContext context, String diarioId) async {
    try {
      await DiarioService().deleteDiario(diarioId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Diário excluído com sucesso.')));
      _atualizarLista();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir diário: $e')));
    }
  }
}

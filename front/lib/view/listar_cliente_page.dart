import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/cliente.dart';
import 'package:trab/repositories/cliente.repository.dart';
import 'package:trab/view/editar_cliente_page.dart';
import 'package:trab/widgets/drawer.dart';

class ListarClientePage extends StatefulWidget {
  static const String routeName = '/listCliente';
  @override
  State<StatefulWidget> createState() => _ListarClientePageState();
}

class _ListarClientePageState extends State<ListarClientePage> {
  List<Cliente> _lista = <Cliente>[];
  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshList() async {
    // carrega todos e repinta a tela
    List<Cliente> tempList = await _obterTodos();
    setState(() {
      _lista = tempList;
    });
  }

  Future<List<Cliente>> _obterTodos() async {
    List<Cliente> tempLista = <Cliente>[];
    try {
      ClienteRepository repository = ClienteRepository();
      tempLista = await repository.buscarTodos();
    } catch (exception) {
      showError(
          context, "Erro obtendo lista de clientes", exception.toString());
    }
    return tempLista;
  }

  void _removerCliente(int id) async {
    // dado um id, remove o cliente da base
    try {
      ClienteRepository repository = ClienteRepository();
      await repository.remover(id);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente $id removido com sucesso.')));
      this._refreshList();
    } catch (exception) {
      showError(context, "Erro removendo cliente", exception.toString());
    }
  }

  void _showItem(BuildContext context, int index) {
    // mostra um cliente na dialog
    Cliente cliente = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(cliente.nome),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    //Icon(Icons.create),
                    Text("Nome: ${cliente.nome}")
                  ]),
                  Row(children: [
                    //Icon(Icons.assistant_photo),
                    Text("Sobrenome: ${cliente.sobrenome}")
                  ]),
                  Row(children: [
                    //Icon(Icons.cake),
                    Text("CPF: ${cliente.cpf}")
                  ]),
                ],
              ),
              actions: [
                TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _editItem(BuildContext context, int index) {
    // chama tela de edição de cliente
    Cliente c = _lista[index];
    Navigator.pushNamed(
      context,
      EditarClientePage.routeName,
      arguments: <String, int>{"id": c.id!},
    );
  }

  void _removeItem(BuildContext context, int index) {
    // confirmação de remoção
    Cliente c = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Remover Cliente"),
              content: Text("Gostaria realmente de remover ${c.nome}?"),
              actions: [
                TextButton(
                  child: Text("Não"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Sim"),
                  onPressed: () {
                    _removerCliente(c.id!);
                    _refreshList();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    // mostra um cliente na lista
    Cliente c = _lista[index];
    return ListTile(
      leading: Icon(Icons.pets),
      title: Text(c.nome),
      subtitle: Text(c.sobrenome),
      onTap: () {
        _showItem(context, index);
      },
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(value: 'delete', child: Text('Remover'))
          ];
        },
        onSelected: (String value) {
          if (value == 'edit')
            _editItem(context, index);
          else
            _removeItem(context, index);
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    // constrói a tela
    return new Scaffold(
        appBar: AppBar(
          title: Text("Listagem de Clientes"),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemCount: _lista.length,
          itemBuilder: _buildItem,
        ));
  }
}

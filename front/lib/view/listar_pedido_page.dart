import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/itemPedido.dart';
import 'package:trab/model/pedido.dart';
import 'package:trab/repositories/pedido.repository.dart';
import 'package:trab/widgets/drawer.dart';

class ListarPedidoPage extends StatefulWidget {
  static const String routeName = '/listPedido';
  @override
  State<StatefulWidget> createState() => _ListarPedidoPageState();
}

class _ListarPedidoPageState extends State<ListarPedidoPage> {
  List<Pedido> _lista = <Pedido>[];
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
    List<Pedido> tempList = await _obterTodos();
    setState(() {
      _lista = tempList;
    });
  }

  Future<List<Pedido>> _obterTodos() async {
    List<Pedido> tempLista = <Pedido>[];
    try {
      PedidoRepository repository = PedidoRepository();
      tempLista = await repository.buscarTodos();
    } catch (exception) {
      showError(
          context, "Erro obtendo lista de pedidos", exception.toString());
    }
    return tempLista;
  }

  void _removerPedido(int id) async {
    // dado um id, remove o pedido da base
    try {
      PedidoRepository repository = PedidoRepository();
      await repository.remover(id);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido $id removido com sucesso.')));
      this._refreshList();
    } catch (exception) {
      showError(context, "Erro removendo pedido", exception.toString());
    }
  }

  void _showItem(BuildContext context, int index) {
    // mostra um pedido na dialog
    Pedido pedido = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Pedido N° ' + pedido.id.toString()),
              content: dialogItensPedido(pedido),
              actions: [
                TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  Widget dialogItensPedido(Pedido p) {
  return Container(
      height: 250.0,
      width: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: p.itensPedido.length,
        itemBuilder: (BuildContext context, int index) {
          ItemPedido i = p.itensPedido[index];
          return ListTile(
            title: Text('Item: ' + i.produto.descricao + ' / Quantidade: ' + i.quantidade.toString()),
          );
        },
      ),
    );
  }

  void _removeItem(BuildContext context, int index) {
    // confirmação de remoção
    Pedido p = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Remover Pedido"),
              content: Text("Gostaria realmente de remover o pedido número ${p.id}?"),
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
                    _removerPedido(p.id!);
                    _refreshList();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    // mostra um pedido na lista
    Pedido p = _lista[index];
    return ListTile(
      leading: Icon(Icons.attach_money),
      title: Text('N° ' + p.id.toString() + ' / Cliente ' + p.cliente.nome + ' (' + p.cliente.cpf + ')'),
      onTap: () {
        _showItem(context, index);
      },
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(value: 'delete', child: Text('Remover'))
          ];
        },
        onSelected: (String value) {
          if (value == 'delete')
            _removeItem(context, index);
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    // constrói a tela
    return new Scaffold(
        appBar: AppBar(
          title: Text("Listagem de Pedidos"),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemCount: _lista.length,
          itemBuilder: _buildItem,
        ));
  }
}

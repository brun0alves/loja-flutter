import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/produto.dart';
import 'package:trab/repositories/produto.repository.dart';
import 'package:trab/view/editar_produto_page.dart';
import 'package:trab/widgets/drawer.dart';
import 'dart:convert' show utf8;

class ListarProdutoPage extends StatefulWidget {
  static const String routeName = '/listProduto';
  @override
  State<StatefulWidget> createState() => _ListarProdutoPageState();
}

class _ListarProdutoPageState extends State<ListarProdutoPage> {
  List<Produto> _lista = <Produto>[];
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
    List<Produto> tempList = await _obterTodos();
    setState(() {
      _lista = tempList;
    });
  }

  Future<List<Produto>> _obterTodos() async {
    List<Produto> tempLista = <Produto>[];
    try {
      ProdutoRepository repository = ProdutoRepository();
      tempLista = await repository.buscarTodos();
    } catch (exception) {
      showError(
          context, "Erro obtendo lista de produtos", exception.toString());
    }
    return tempLista;
  }

  void _removerProduto(int id) async {
    // dado um id, remove o produto da base
    try {
      ProdutoRepository repository = ProdutoRepository();
      await repository.remover(id);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto $id removido com sucesso.')));
      this._refreshList();
    } catch (exception) {
      showError(context, "Erro removendo produto", exception.toString());
    }
  }

  void _showItem(BuildContext context, int index) {
    // mostra um produto na dialog
    Produto produto = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(produto.descricao),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    //Icon(Icons.create),
                    Text("Descrição: ${produto.descricao}")
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
    // chama tela de edição de produto
    Produto c = _lista[index];
    Navigator.pushNamed(
      context,
      EditarProdutoPage.routeName,
      arguments: <String, int>{"id": c.id!},
    );
  }

  void _removeItem(BuildContext context, int index) {
    // confirmação de remoção
    Produto p = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Remover Produto"),
              content: Text("Gostaria realmente de remover ${p.descricao}?"),
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
                    _removerProduto(p.id!);
                    _refreshList();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    // mostra um produto na lista
    Produto p = _lista[index];
    return ListTile(
      leading: Icon(Icons.local_grocery_store_sharp),
      title: Text(p.descricao),
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
          title: Text("Listagem de Produtos"),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemCount: _lista.length,
          itemBuilder: _buildItem,
        ));
  }
}

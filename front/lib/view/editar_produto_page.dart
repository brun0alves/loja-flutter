import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/produto.dart';
import 'package:trab/repositories/produto.repository.dart';
import 'package:trab/view/listar_produto_page.dart';
import 'package:trab/widgets/drawer.dart';

class EditarProdutoPage extends StatefulWidget {
  static const String routeName = '/editProduto';
  @override
  _EditarProdutoState createState() => _EditarProdutoState();
}

class _EditarProdutoState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  int _id = 0;
  Produto? _produto;

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _obterProduto() async {
    try {
      ProdutoRepository repository = ProdutoRepository();
      this._produto = await repository.buscar(this._id);
      _descricaoController.text = this._produto!.descricao;
    } catch (exception) {
      showError(context, "Erro recuperando produto", exception.toString());
      Navigator.pop(context);
    }
  }

  void _salvar() async {
    this._produto!.descricao = _descricaoController.text;
    try {
      ProdutoRepository repository = ProdutoRepository();
      await repository.alterar(this._produto!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto editado com sucesso.')));
      Navigator.pushNamed(
        context,
        ListarProdutoPage.routeName,
      );
    } catch (exception) {
      showError(context, "Erro editando produto", exception.toString());
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Descrição:"),
              Expanded(
                  child: TextFormField(
                controller: _descricaoController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvar();
                    }
                  },
                  child: Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ListarProdutoPage.routeName,
                    );
                  },
                  child: Text('Cancelar'),
                ),
              ],
            )
          ])) // Form
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Map m = ModalRoute.of(context)!.settings.arguments as Map;
    this._id = m["id"];
    _obterProduto();
    return new Scaffold(
      appBar: AppBar(
        title: Text("Editar Produto"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}

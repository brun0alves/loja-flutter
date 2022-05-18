import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/pedido.dart';
import 'package:trab/repositories/pedido.repository.dart';
import 'package:trab/view/listar_pedido_page.dart';
import 'package:trab/widgets/drawer.dart';

class EditarPedidoPage extends StatefulWidget {
  static const String routeName = '/editPedido';
  @override
  _EditarPedidoState createState() => _EditarPedidoState();
}

class _EditarPedidoState extends State<EditarPedidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _clienteController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _cpfController = TextEditingController();
  int _id = 0;
  Pedido? _pedido;

  @override
  void dispose() {
    _clienteController.dispose();
    super.dispose();
  }

  void _obterPedido() async {
    try {
      PedidoRepository repository = PedidoRepository();
      this._pedido = await repository.buscar(this._id);
      _clienteController.text = this._pedido!.cliente.cpf;
    } catch (exception) {
      showError(context, "Erro recuperando pedido", exception.toString());
      Navigator.pop(context);
    }
  }

  void _salvar() async {
    this._pedido!.cliente.id = int.parse(_clienteController.text);
    try {
      PedidoRepository repository = PedidoRepository();
      await repository.alterar(this._pedido!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido editado com sucesso.')));
      Navigator.pushNamed(
        context,
        ListarPedidoPage.routeName,
      );
    } catch (exception) {
      showError(context, "Erro editando pedido", exception.toString());
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Cliente:"),
              Expanded(
                  child: TextFormField(
                controller: _clienteController,
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
                    Navigator.pop(context);
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
    _obterPedido();
    return new Scaffold(
      appBar: AppBar(
        title: Text("Editar Pedido"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}

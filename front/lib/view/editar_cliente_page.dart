import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/cliente.dart';
import 'package:trab/repositories/cliente.repository.dart';
import 'package:trab/view/listar_cliente_page.dart';
import 'package:trab/widgets/drawer.dart';

class EditarClientePage extends StatefulWidget {
  static const String routeName = '/edit';
  @override
  _EditarClienteState createState() => _EditarClienteState();
}

class _EditarClienteState extends State<EditarClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _cpfController = TextEditingController();
  int _id = 0;
  Cliente? _cliente;

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _obterCliente() async {
    try {
      ClienteRepository repository = ClienteRepository();
      this._cliente = await repository.buscar(this._id);
      _nomeController.text = this._cliente!.nome;
      _sobrenomeController.text = this._cliente!.sobrenome;
      _cpfController.text = this._cliente!.cpf;
    } catch (exception) {
      showError(context, "Erro recuperando cliente", exception.toString());
      Navigator.pop(context);
    }
  }

  void _salvar() async {
    this._cliente!.nome = _nomeController.text;
    this._cliente!.sobrenome = _sobrenomeController.text;
    this._cliente!.cpf = _cpfController.text;
    try {
      ClienteRepository repository = ClienteRepository();
      await repository.alterar(this._cliente!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente editado com sucesso.')));
      Navigator.pushNamed(
        context,
        ListarClientePage.routeName,
      );
    } catch (exception) {
      showError(context, "Erro editando cliente", exception.toString());
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Nome:"),
              Expanded(
                  child: TextFormField(
                controller: _nomeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Sobrenome:"),
              Expanded(
                  child: TextFormField(
                controller: _sobrenomeController,
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
    _obterCliente();
    return new Scaffold(
      appBar: AppBar(
        title: Text("Editar Cliente"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}

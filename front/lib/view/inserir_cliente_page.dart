import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/cliente.dart';
import 'package:trab/repositories/cliente.repository.dart';
import 'package:trab/view/listar_cliente_page.dart';
import 'package:trab/widgets/drawer.dart';

class InserirClientePage extends StatefulWidget {
  static const String routeName = '/insertCliente';
  @override
  _InserirClienteState createState() => _InserirClienteState();
}

class _InserirClienteState extends State<InserirClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _salvar() async {
    Cliente cliente = Cliente.novo(_nomeController.text, _sobrenomeController.text, _cpfController.text);
    try {
      ClienteRepository repository = ClienteRepository();
      await repository.inserir(cliente);
      _nomeController.clear();
      _sobrenomeController.clear();
      _cpfController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cliente salvo com sucesso.')));
      Navigator.pushNamed(
        context,
        ListarClientePage.routeName,
      );
    } catch (exception) {
      showError(context, "Erro inserindo cliente", exception.toString());
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
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("CPF:"),
              Expanded(
                child: TextFormField(
                controller: _cpfController,
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
    return new Scaffold(
      appBar: AppBar(
        title: Text("Inserir Cliente"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}

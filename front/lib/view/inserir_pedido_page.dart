import 'package:flutter/material.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/cliente.dart';
import 'package:trab/model/itemPedido.dart';
import 'package:trab/model/pedido.dart';
import 'package:trab/model/produto.dart';
import 'package:trab/repositories/pedido.repository.dart';
import 'package:trab/view/listar_pedido_page.dart';
import 'package:trab/widgets/drawer.dart';

class InserirPedidoPage extends StatefulWidget {
  static const String routeName = '/insertPedido';
  @override
  _InserirPedidoState createState() => _InserirPedidoState();
}

class _InserirPedidoState extends State<InserirPedidoPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _dataSelecionada = DateTime.now();
  final _clienteController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _clienteController.dispose();
    _sobrenomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _salvar() async {
    Cliente cliente = new Cliente(1, 'Bruno', 'Alves', '08319314933');
    Produto produto = new Produto(1, 'TV');
    Produto produto2 = new Produto(2, 'TV2');
    ItemPedido item = new ItemPedido(1, produto);
    ItemPedido item2 = new ItemPedido(2, produto2);
    List<ItemPedido> itensPedido = [];
    itensPedido.add(item);
    itensPedido.add(item2);
    Pedido pedido = Pedido.novo(0, _dataSelecionada.toString(), cliente, itensPedido);
    try {
      PedidoRepository repository = PedidoRepository();
      await repository.inserir(pedido);
      _clienteController.clear();
      _sobrenomeController.clear();
      _cpfController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Pedido salvo com sucesso.')));
      Navigator.pushNamed(
        context,
        ListarPedidoPage.routeName,
      );
    } catch (exception) {
      showError(context, "Erro inserindo pedido", exception.toString());
    }
  }

  void _selecionarData() async {
    final DateTime? dataObtida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (dataObtida != null && dataObtida != _dataSelecionada) {
      setState(() {
        _dataSelecionada = dataObtida;
      });
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _selecionarData,
                  child: Text('Data'),
                ),
              ],
            ),
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
    return new Scaffold(
      appBar: AppBar(
        title: Text("Inserir Pedido"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}

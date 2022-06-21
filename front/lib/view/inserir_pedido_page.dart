import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trab/helper/error.dart';
import 'package:trab/model/cliente.dart';
import 'package:trab/model/itemPedido.dart';
import 'package:trab/model/pedido.dart';
import 'package:trab/model/produto.dart';
import 'package:trab/repositories/cliente.repository.dart';
import 'package:trab/repositories/pedido.repository.dart';
import 'package:trab/repositories/produto.repository.dart';
import 'package:trab/view/listar_pedido_page.dart';
import 'package:trab/widgets/drawer.dart';


class InserirPedidoPage extends StatefulWidget {
  static const String routeName = '/insertPedido';
  @override
  _InserirPedidoState createState() => _InserirPedidoState();
}

class _InserirPedidoState extends State<InserirPedidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _quantidadeItemController = TextEditingController();
  Cliente cliente = Cliente(null, '', '', '');
  String _dataSelecionadaLabel = '';
  DateTime _dataSelecionada = DateTime.now();
  List<ItemPedido> itensPedido = <ItemPedido>[];

  List<Produto> _listaProdutos = <Produto>[];
  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  void _loadProducts() async {
    // carrega todos e repinta a tela
    List<Produto> tempList = await _obterTodos();
    setState(() {
      _listaProdutos = tempList;
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

  void _salvarItem (ItemPedido item) {
    itensPedido.removeWhere((element) => element.produto.id == item.produto.id);
    if (item.quantidade! > 0) {
        itensPedido.add(item);
    }
    _quantidadeItemController.clear();
  }

  void _salvar() async {
    try {
      ClienteRepository clienteRepository = ClienteRepository();
      List<Cliente> clientes = await clienteRepository.buscarTodos();
      try {
        cliente = clientes.where((element) => element.cpf == _cpfController.text).single;
      } catch (exception) {
        throw (Exception('Cliente com o CPF ' +  _cpfController.text + ' não encontrado.'));
      }

      Pedido pedido = Pedido.novo(0, _dataSelecionada.toString(), cliente, itensPedido);
      PedidoRepository pedidoRepository = PedidoRepository();
      await pedidoRepository.inserir(pedido);
      
      _cpfController.clear();
      
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pedido salvo com sucesso.')));
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
        _dataSelecionadaLabel = "${dataObtida.day.toString().padLeft(2,'0')}-${dataObtida.month.toString().padLeft(2,'0')}-${dataObtida.year.toString()}";
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
                Text("Data: "),
                Text(_dataSelecionadaLabel),
                ElevatedButton(
                  onPressed: _selecionarData,
                  child: Text('Selecione a Data'),
                ),
              ],
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("CPF Cliente:"),
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
            Row(children: <Widget>[
              Text("Produtos:"),
              Expanded(child:  ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listaProdutos.length,
                  itemBuilder: (BuildContext context, int index) {
                    Produto p = _listaProdutos[index];
                    return ListTile(
                      title: Text(p.descricao),
                       onTap: () {
                        _showItem(context, index);
                      },
                    );
                  },
                ),)
              ],
            ),
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
                      ListarPedidoPage.routeName,
                    );
                  },
                  child: Text('Cancelar'),
                ),
              ],
            )
          ])) // Form
    ]);
  }

  void _showItem(BuildContext context, int index) {
    Produto produto = _listaProdutos[index];
    try {
      ItemPedido item = itensPedido.where((element) => element.produto.id == produto.id).single;
      _quantidadeItemController.text = item.quantidade.toString();
    } catch (exception) { }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Produto: ' + produto.descricao),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(child:                     
                      TextField(
                        controller: _quantidadeItemController,
                                decoration: new InputDecoration(labelText: "Informe a quantidade"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>
                                [FilteringTextInputFormatter.digitsOnly]
                      ),
                    ),
                  ]),
                ],
              ),
              actions: [
                TextButton(
                    child: Text("Salvar"),
                    onPressed: () {
                      _salvarItem(ItemPedido(int.parse(_quantidadeItemController.text), produto));
                      Navigator.of(context).pop();
                }),
                TextButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                })
              ]);
        });
  }
  @override
  Widget build(BuildContext context) {
    _loadProducts();
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Inserir Pedido"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}

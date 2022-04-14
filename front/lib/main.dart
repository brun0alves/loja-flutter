import 'package:flutter/material.dart';
import 'package:trab/routes/routes.dart';
import 'package:trab/view/editar_cliente_page.dart';
import 'package:trab/view/editar_produto_page.dart';
import 'package:trab/view/inserir_cliente_page.dart';
import 'package:trab/view/inserir_produto_page.dart';
import 'package:trab/view/listar_cliente_page.dart';
import 'package:trab/view/listar_produto_page.dart';
import 'package:trab/widgets/drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedidos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pedidos'),
      routes: {
        Routes.editCliente: (context) => EditarClientePage(),
        Routes.insertCliente: (context) => InserirClientePage(),
        Routes.listCliente: (context) => ListarClientePage(),
        Routes.editProduto: (context) => EditarProdutoPage(),
        Routes.insertProduto: (context) => InserirProdutoPage(),
        Routes.listProduto: (context) => ListarProdutoPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: AppDrawer(),
    );
  }
}

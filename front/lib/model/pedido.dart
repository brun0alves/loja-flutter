import 'dart:convert';

import 'package:trab/model/cliente.dart';
import 'package:trab/model/itemPedido.dart';
import 'package:trab/model/produto.dart';

class Pedido {
  int? id;
  String data;
  Cliente cliente;
  List<ItemPedido> itensPedido;
  Pedido(this.id, this.data, this.cliente, this.itensPedido);
  Pedido.novo(this.id, this.data, this.cliente, this.itensPedido);

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'data': this.data,
      'cliente': {
          'id': this.cliente.id,
          'nome': this.cliente.nome,
          'sobrenome': this.cliente.nome,
          'cpf': this.cliente.cpf 
      },
      'itensPedido': this.itensPedido.map((i) => {
                      'quantidade': i.quantidade, 
                      'item': i.produto.toMap()
                    }).toList()
    };
  }

  static Pedido fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> clienteMap = map['cliente'] as Map<String, dynamic>;
    Cliente cliente = Cliente(clienteMap['id'] as int, clienteMap['nome'] as String, clienteMap['sobrenome'] as String, clienteMap['cpf'] as String);

    List<ItemPedido> itensPedido = [];
    List itensPedidoMap = map['itensPedido'] as List;
    for (var item in itensPedidoMap) {
        Map<String, dynamic> itemMap = item as Map<String, dynamic>;
        Map<String, dynamic> produtoMap = itemMap['item'] as  Map<String, dynamic>;
        Produto produto = Produto(produtoMap['id'] as int, produtoMap['descricao'] as String);
        itensPedido.add(ItemPedido(itemMap['quantidade'] as int, produto));
    }
  
    return Pedido(
      map['id'] as int,
      map['data'] as String,
      cliente,
      itensPedido
    );
  }

  static List<Pedido> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Pedido.fromMap(maps[i]);
    });
  }

  static Pedido fromJson(String j) => Pedido.fromMap(jsonDecode(j));
  static List<Pedido> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<Pedido>((map) => Pedido.fromMap(map)).toList();
  }

  String toJson() => jsonEncode(toMap());
}

import 'dart:convert';

import 'package:trab/model/cliente.dart';
import 'package:trab/model/itemPedido.dart';

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
      'cliente': this.cliente.nome + ' ' + this.cliente.sobrenome,
    };
  }

  static Pedido fromMap(Map<String, dynamic> map) {
    return Pedido(
      map['id'],
      map['data'],
      map['cliente'],
      map['item']
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

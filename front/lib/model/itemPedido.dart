import 'dart:convert';

import 'package:trab/model/cliente.dart';
import 'package:trab/model/produto.dart';

class ItemPedido {
  int? quantidade;
  Produto produto;
  ItemPedido(this.quantidade, this.produto);
  ItemPedido.novo(this.quantidade, this.produto);

  Map<String, dynamic> toMap() {
    return {
      'quantidade': this.quantidade,
      'produto': this.produto,
    };
  }

  static ItemPedido fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      map['quantidade'],
      map['produto'],
    );
  }

  static List<ItemPedido> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return ItemPedido.fromMap(maps[i]);
    });
  }

  static ItemPedido fromJson(String j) => ItemPedido.fromMap(jsonDecode(j));
  static List<ItemPedido> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<ItemPedido>((map) => ItemPedido.fromMap(map)).toList();
  }

  String toJson() => jsonEncode(toMap());
}

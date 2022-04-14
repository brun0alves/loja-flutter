import 'package:trab/model/pedido.dart';
import 'package:trab/rest/pedido_rest.dart';

class PedidoRepository {
  final PedidoRest api = PedidoRest();
  Future<Pedido> buscar(int id) async {
    return await api.buscar(id);
  }

  Future<List<Pedido>> buscarTodos() async {
    return await api.buscarTodos();
  }

  Future<List<Pedido>> inserir(Pedido pedido) async {
    return await api.inserir(pedido);
  }

  Future<Pedido> alterar(Pedido pedido) async {
    return await api.alterar(pedido);
  }

  Future<List<Pedido>> remover(int id) async {
    return await api.remover(id);
  }
}

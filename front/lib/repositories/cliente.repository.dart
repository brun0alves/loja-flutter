import 'package:trab/model/cliente.dart';
import 'package:trab/rest/cliente_rest.dart';

class ClienteRepository {
  final ClienteRest api = ClienteRest();
  Future<Cliente> buscar(int id) async {
    return await api.buscar(id);
  }

  Future<List<Cliente>> buscarTodos() async {
    return await api.buscarTodos();
  }

  Future<List<Cliente>> inserir(Cliente cliente) async {
    return await api.inserir(cliente);
  }

  Future<Cliente> alterar(Cliente cliente) async {
    return await api.alterar(cliente);
  }

  Future<List<Cliente>> remover(int id) async {
    return await api.remover(id);
  }
}

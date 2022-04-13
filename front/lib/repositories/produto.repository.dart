import 'package:trab/model/produto.dart';
import 'package:trab/rest/produto_rest.dart';

class ProdutoRepository {
  final ProdutoRest api = ProdutoRest();
  Future<Produto> buscar(int id) async {
    return await api.buscar(id);
  }

  Future<List<Produto>> buscarTodos() async {
    return await api.buscarTodos();
  }

  Future<List<Produto>> inserir(Produto produto) async {
    return await api.inserir(produto);
  }

  Future<Produto> alterar(Produto produto) async {
    return await api.alterar(produto);
  }

  Future<List<Produto>> remover(int id) async {
    return await api.remover(id);
  }
}

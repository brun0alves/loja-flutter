import 'package:http/http.dart' as http;
import 'package:trab/model/produto.dart';
import 'package:trab/rest/api.dart';

class ProdutoRest {
  Future<Produto> buscar(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, '/produto/$id'));
    if (response.statusCode == 200) {
      return Produto.fromJson(response.body);
    } else {
      throw Exception(
          'Erro buscando produtos: ${id} [code: ${response.statusCode}]');
    }
  }

  Future<List<Produto>> buscarTodos() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "produto/"));
    if (response.statusCode == 200) {
      return Produto.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os produtos.');
    }
  }

  Future<List<Produto>> inserir(Produto produto) async {
    final http.Response response =
        await http.post(Uri.http(API.endpoint, 'produto'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: produto.toJson());
    if (response.statusCode == 201) {
      return this.buscarTodos();
    } else {
      throw Exception('Erro inserindo produto');
    }
  }

  Future<Produto> alterar(Produto produto) async {
    final http.Response response = await http.put(
      Uri.http(API.endpoint, 'produto/${produto.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: produto.toJson(),
    );
    if (response.statusCode == 200) {
      return produto;
    } else {
      throw Exception('Erro alterando produto ${produto.id}.');
    }
  }

  Future<List<Produto>> remover(int id) async {
    final http.Response response = await http.delete(
        Uri.http(API.endpoint, '/produto/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      return this.buscarTodos();
    } else {
      throw Exception('Erro removendo produto: $id.');
    }
  }
}

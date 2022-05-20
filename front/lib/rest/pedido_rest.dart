import 'package:http/http.dart' as http;
import 'package:trab/model/httpException.dart';
import 'package:trab/model/pedido.dart';
import 'package:trab/rest/api.dart';

class PedidoRest {
  Future<Pedido> buscar(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, '/pedido/$id'));
    if (response.statusCode == 200) {
      return Pedido.fromJson(response.body);
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<List<Pedido>> buscarTodos() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "pedido/"));
    if (response.statusCode == 200) {
      return Pedido.fromJsonList(response.body);
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<List<Pedido>> inserir(Pedido pedido) async {
    final http.Response response =
        await http.post(Uri.http(API.endpoint, 'pedido'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: pedido.toJson());
    if (response.statusCode == 201) {
      return this.buscarTodos();
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<Pedido> alterar(Pedido pedido) async {
    final http.Response response = await http.put(
      Uri.http(API.endpoint, 'pedido/${pedido.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: pedido.toJson(),
    );
    if (response.statusCode == 200) {
      return pedido;
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<List<Pedido>> remover(int id) async {
    final http.Response response = await http.delete(
        Uri.http(API.endpoint, '/pedido/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      return this.buscarTodos();
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }
}

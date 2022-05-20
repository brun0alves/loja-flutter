import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:trab/model/cliente.dart';
import 'package:trab/model/httpException.dart';
import 'package:trab/rest/api.dart';

class ClienteRest {
  Future<Cliente> buscar(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, '/cliente/$id'));
    if (response.statusCode == 200) {
      return Cliente.fromJson(response.body);
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<List<Cliente>> buscarTodos() async {
    final teste  = API.endpoint;
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "cliente/"));
    if (response.statusCode == 200) {
      return Cliente.fromJsonList(response.body);
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<List<Cliente>> inserir(Cliente cliente) async {
    final http.Response response =
        await http.post(Uri.http(API.endpoint, 'cliente'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: cliente.toJson());
    if (response.statusCode == 201) {
      return this.buscarTodos();
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<Cliente> alterar(Cliente cliente) async {
    final http.Response response = await http.put(
      Uri.http(API.endpoint, 'cliente/${cliente.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: cliente.toJson(),
    );
    if (response.statusCode == 200) {
      return cliente;
    } else {
      HttpException httpException = HttpException.fromJson(response.body);
      throw Exception(httpException.message);
    }
  }

  Future<List<Cliente>> remover(int id) async {
    final http.Response response = await http.delete(
        Uri.http(API.endpoint, '/cliente/$id'),
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

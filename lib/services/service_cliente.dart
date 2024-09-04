import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendCliente {
  static Future<List<Map<String, String>>> getCliente(String query) async {
    /*
    if (query.isEmpty && query.length < 1) {
      print('Query needs to be at least 1 chars');
      return Future.value([]);
    }*/
    /*
    var url = Uri.parse('http://172.168.60.33:500/movil/comercial',
        '/api/marca/listarMarcas?marca=$query'),headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },);

    var response = await http.get(url);
    */
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');

    final response = await http.post(
      Uri.parse(
          '${ApiConstant.url}/movil/comercial/api/cliente/buscarClienteVendedor'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, String>{
        'tipoDocumento': '',
      }),
    );

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response.body}');

    List<Cliente> cliente = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      cliente =
          List<Cliente>.from(json.map((model) => Cliente.fromJson(model)));
      cliente = List.from(
          cliente.where((x) => x.nombres.contains(query.toUpperCase())));

      print('Number of suggestion: ${cliente.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(cliente
        .map((e) => {
              'codigo': e.codigo.toString(),
              'tipoDocumento': e.tipoDocumento.toString(),
              'documento': e.documento.toString(),
              'nombres': e.nombres.toString()
            })
        .toList());
  }
}

class Cliente {
  final int codigo;
  final String tipoDocumento;
  final String documento;
  final String nombres;

  Cliente({
    required this.codigo,
    required this.tipoDocumento,
    required this.documento,
    required this.nombres,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      codigo: json['codigo'],
      tipoDocumento: json['tipoDocumento'],
      documento: json['documento'],
      nombres: json['nombres'],
    );
  }
}

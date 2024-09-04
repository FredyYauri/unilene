import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendSubAgrupador {
  static Future<List<Map<String, String>>> getSubAgrupador(
      String linea, String agrupador, String query) async {
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
          '${ApiConstant.url}/movil/comercial/api/SubAgrupador/ListaSubAgrupador'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, String>{
        'linea': linea,
        'agrupador': agrupador,
      }),
    );

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response.body}');

    List<SubAgrupador> subAgrupador = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      subAgrupador = List<SubAgrupador>.from(
          json.map((model) => SubAgrupador.fromJson(model)));
      subAgrupador = List.from(subAgrupador
          .where((x) => x.descripcion.contains(query.toUpperCase())));

      print('Number of suggestion: ${subAgrupador.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(subAgrupador
        .map((e) => {
              'linea': e.linea.toString(),
              'agrupador': e.agrupador.toString(),
              'codigo': e.codigo.toString(),
              'descripcion': e.descripcion.toString()
            })
        .toList());
  }
}

class SubAgrupador {
  final String linea;
  final String agrupador;
  final String codigo;
  final String descripcion;

  SubAgrupador({
    required this.linea,
    required this.agrupador,
    required this.codigo,
    required this.descripcion,
  });

  factory SubAgrupador.fromJson(Map<String, dynamic> json) {
    return SubAgrupador(
      linea: json['linea'],
      agrupador: json['agrupador'],
      codigo: json['codigo'],
      descripcion: (json['descripcion'] ?? ''),
    );
  }
}

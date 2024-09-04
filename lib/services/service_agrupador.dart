import 'dart:async';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendAgrupador {
  static Future<List<Map<String, String>>> getAgrupador(String query) async {
    /*
    if (query.isEmpty && query.length < 1) {
      print('Query needs to be at least 1 chars');
      return Future.value([]);
    }
    */
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

    final response = await http.get(
        Uri.parse(
            '${ApiConstant.url}/movil/comercial/api/Agrupador/ObtenerAgrupadores?Linea=P'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token,
        });

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response.body}');

    List<Agrupador> agrupador = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      agrupador =
          List<Agrupador>.from(json.map((model) => Agrupador.fromJson(model)));
      agrupador = List.from(
          agrupador.where((x) => x.descripcion.contains(query.toUpperCase())));

      print('Marca: ${agrupador}');

      print('Number of suggestion: ${agrupador.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(agrupador
        .map((e) => {
              'codigo': e.codigo.toString(),
              'descripcion': e.descripcion.toString()
            })
        .toList());
  }
}

class Agrupador {
  final String codigo;
  final String descripcion;

  Agrupador({
    required this.codigo,
    required this.descripcion,
  });

  factory Agrupador.fromJson(Map<String, dynamic> json) {
    return Agrupador(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
    );
  }
}

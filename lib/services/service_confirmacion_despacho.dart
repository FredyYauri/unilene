import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendConfirmarDespacho {
  static Future<String> registrarDespacho(
      String query, List<int> dataArray) async {
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
          '${ApiConstant.url}movil/almacen/api/despacho/registrarDetalleDespacho'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, dynamic>{
        'guiaDespacho': query,
        'detalle': dataArray,
      }),
    );

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');

    print('_query: ${query}');
    print('_array: ${dataArray}');

    print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Response body: ${response.body}');

    //List<Despacho> despacho = [];
    String rpta = '';
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      rpta = (json['content'] ?? '');
      print('Number of suggestion: ${json.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return rpta;
  }
}

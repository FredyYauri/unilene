import 'dart:async';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:unilene_app/model/ModelView.dart';
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendListadoCatalogo {
  static Future<List<Map<String, String>>> getListadoCatalogo(
      int tiporetorno) async {
    /*â
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

    final response = await http.get(
        Uri.parse(
            '${ApiConstant.url}/movil/comercial/api/cotizacion/ListadoCatalogo?tiporetorno=$tiporetorno'),
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

    List<ListadoCatalogo> catalogo = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      //Iterable json = convert.jsonDecode(response.body);
      catalogo = List<ListadoCatalogo>.from(
          json.map((model) => ListadoCatalogo.fromJson(model)));

      print('Number of suggestion: ${catalogo.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(catalogo
        .map((e) => {
              'codigo': e.codigo.toString(),
              'descripcion': e.descripcion.toString()
            })
        .toList());
  }
}

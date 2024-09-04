import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:unilene_app/model/ModelView.dart';
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendRegistroDetalle {
  static Future<List<Map<String, String>>> getRegistroDetalle(
      int gestionId,
      String numeroDocumento,
      String itemCodigo,
      String usuarioCreacion,
      String dispositivoId) async {
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
          '${ApiConstant.url}/movil/comercial/api/cotizacion/RegistroGestionDetalleCotizaciones'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, String>{
        'gestionId': gestionId.toString(),
        'numeroDocumento': numeroDocumento,
        'itemCodigo': itemCodigo,
        'usuarioCreacion': usuarioCreacion,
        'dispositivoId': dispositivoId
      }),
    );

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response.body}');

    List<Registro> registro = [];

    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      registro =
          List<Registro>.from(json.map((model) => Registro.fromJson(model)));

      print('Number of suggestion: ${registro.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(registro
        .map((e) => {
              'codeError': e.codeError.toString(),
              'msj': e.msj.toString(),
            })
        .toList());
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:unilene_app/model/ModelView.dart';
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendRegistro {
  static Future<List<Map<String, String>>> getRegistro(
      String numeroDocumento,
      String fechaGestion,
      String tipoGestion,
      String tipoCanal,
      String tipoResultado,
      String tipoRiesgo,
      String tipoMotivo,
      String usuarioCreacion,
      String dispositivoId,
      String tipoMda,
      String precio,
      String codPostor,
      String itemCodigos) async {
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
          '${ApiConstant.url}/movil/comercial/api/cotizacion/RegistroGestion'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, String>{
        'numeroDocumento': numeroDocumento,
        'fechaGestion': fechaGestion,
        'tipoGestion': tipoGestion,
        'tipoCanal': tipoCanal,
        'tipoResultado': tipoResultado,
        'tipoRiesgo': tipoRiesgo,
        'tipoMotivo': tipoMotivo,
        'usuarioCreacion': usuarioCreacion,
        'dispositivoId': dispositivoId,
        'tipoMda': tipoMda,
        'precio': precio,
        'codPostor': codPostor,
        'itemCodigos': itemCodigos,
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

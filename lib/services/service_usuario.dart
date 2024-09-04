import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendUsuario {
  static Future<Map<String, dynamic>> getUsuario() async {
    Map<String, dynamic> dataMap = {};

    final token = await SessionManager().get('token');
    print('Token Session Products: $token');

    final response = await http.get(
        Uri.parse(
            '${ApiConstant.url}/movil/recursosHumanos/api/usuario/datoUsuarioSesion'),
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

    //List<Comision> comision = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      int _codigo = body['content']['codigo'];
      String _apellidoPaterno = body['content']['apellidoPaterno'];
      String _apellidoMaterno = body['content']['apellidoMaterno'];
      String _nombre = body['content']['nombre'];
      String _correo = body['content']['correo'];
      String _celular = body['content']['celular'] ?? '';

      //insert data
      dataMap = <String, dynamic>{
        "codigo": _codigo,
        "apellidoPaterno": _apellidoPaterno,
        "apellidoMaterno": _apellidoMaterno,
        "nombre": _nombre,
        "correo": _correo,
        "celular": _celular,
      };

      print('Number of suggestion: ${dataMap.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return dataMap;
  }
}

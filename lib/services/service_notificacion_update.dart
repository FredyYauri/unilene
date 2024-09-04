import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/ModelView.dart';
import '../util/color_constant.dart';

class BackendActualizarNotificacion {
  static Future<List<Map<String, String>>> getActualizarNotificacion(
      int notificacionId) async {
    String _url;
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');
    _url =
        '${ApiConstant.url}/movil/comercial/api/cotizacion/ActualizarNotificacion?notificacionId=$notificacionId';

    final response = await http.get(Uri.parse(_url), headers: {
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

    //future = Future<List<Map<String, String>>>();
    List<Registro> registro = [];
    //List<PorTipoCliente> porTipoCliente = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body)['content'];

      registro =
          List<Registro>.from(json.map((model) => Registro.fromJson(model)));

      //gestiondetalle.sort((a, b) => b.fechaGestion.compareTo(a.fechaGestion));

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

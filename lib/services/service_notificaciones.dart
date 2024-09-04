import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/ModelView.dart';
import '../util/color_constant.dart';

class BackendNotificacion {
  static Future<List<Map<String, String>>> getNotificaciones(
      int vendedor) async {
    String _url;
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');
    _url =
        '${ApiConstant.url}/movil/comercial/api/cotizacion/ListarNotificaciones?vendedor=$vendedor';

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
    List<Notificaciones> notificaciones = [];
    //List<PorTipoCliente> porTipoCliente = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body)['content'];

      notificaciones = List<Notificaciones>.from(
          json.map((model) => Notificaciones.fromJson(model)));

      print('Number of suggestion: ${notificaciones.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(notificaciones
        .map((e) => {
              'notificacionId': e.notificacionId.toString(),
              'tipoNotificacion': e.tipoNotificacion.toString(),
              'tituloNotificacion': e.tituloNotificacion.toString(),
              'cuerpoNotificacion': e.cuerpoNotificacion.toString(),
              'valor': e.valor.toString(),
              'estado': e.estado.toString(),
              'fechaCreacion': e.fechaCreacion.toString(),
            })
        .toList());
  }
}

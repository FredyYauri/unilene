import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/ModelView.dart';
import '../util/color_constant.dart';

class BackendGestionCotizacion {
  static Future<List<Map<String, String>>> getGestionCotizacion(
      String numeroDocumento) async {
    String _url;
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');
    _url =
        '${ApiConstant.url}/movil/comercial/api/cotizacion/ListarGestionCotizaciones?numeroDocumento=$numeroDocumento';

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
    List<GestionCotizacion> gestion = [];
    //List<PorTipoCliente> porTipoCliente = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body)['content'];

      gestion = List<GestionCotizacion>.from(
          json.map((model) => GestionCotizacion.fromJson(model)));

      gestion.sort((a, b) => b.fechaGestion.compareTo(a.fechaGestion));

      print('Number of suggestion: ${gestion.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(gestion
        .map((e) => {
              'gestionId': e.gestionId.toString(),
              'numeroDocumento': e.numeroDocumento.toString(),
              'fechaGestion': e.fechaGestion.toString(),
              'tipoGestion': e.tipoGestion.toString(),
              'tipoCanal': e.tipoCanal.toString(),
              'tipoResultado': e.tipoResultado.toString(),
              'tipoRiesgo': e.tipoRiesgo.toString(),
              'tipoMotivo': e.tipoMotivo.toString(),
            })
        .toList());
  }
}

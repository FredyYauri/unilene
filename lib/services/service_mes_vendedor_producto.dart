import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/ModelView.dart';
import '../util/color_constant.dart';

class BackendVendedorProductoMes {
  /* 
  -- Parameters invoke option
  1 - porAgrupador
  2 - porTipoCliente
  */
  static Future<List<Map<String, String>>> getProductoMes() async {
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');

    final response = await http.get(
        Uri.parse(
            '${ApiConstant.url}/movil/comercial/api/presupuestoVsVentas/mensual_Vendedor'),
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

    //future = Future<List<Map<String, String>>>();
    List<PorAgrupador> porAgrupador = [];
    //List<PorTipoCliente> porTipoCliente = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body)['content']['porAgrupador'];
      porAgrupador = List<PorAgrupador>.from(
          json.map((model) => PorAgrupador.fromJson(model)));

      print('Number of suggestion: ${porAgrupador.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(porAgrupador
        .map((e) => {
              'codigoAgrupador': e.codigoAgrupador.toString(),
              'agrupador': e.agrupador.toString(),
              'presupuesto': e.presupuesto.toString(),
              'ventas': e.ventas.toString(),
              'avances': e.avances.toString(),
            })
        .toList());
  }

  //return future;
}

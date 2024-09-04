import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/ModelView.dart';
import '../util/color_constant.dart';

class BackendDetallePresupuestoMes {
  static Future<List<Map<String, String>>> getPresupuestoMes(
      int opcion, String tipoCliente, String query) async {
    String _url;
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');

    if (opcion == 1) {
      _url =
          '${ApiConstant.url}/movil/comercial/api/presupuestoVsVentas/vendedor_TipoCliente_Mensual?tipoCliente=$tipoCliente';
    } else {
      _url =
          '${ApiConstant.url}/movil/comercial/api/presupuestoVsVentas/vendedor_TipoCliente_Anual?tipoCliente=$tipoCliente';
    }

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
    List<DetallePresupuesto> detallePresupuesto = [];
    //List<PorTipoCliente> porTipoCliente = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body)['content'];

      detallePresupuesto = List<DetallePresupuesto>.from(
          json.map((model) => DetallePresupuesto.fromJson(model)));

      detallePresupuesto = List.from(detallePresupuesto
          .where((x) => x.cliente.contains(query.toUpperCase())));

      print('Number of suggestion: ${detallePresupuesto.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(detallePresupuesto
        .map((e) => {
              'codigoCliente': e.codigoCliente.toString(),
              'cliente': e.cliente.toString(),
              'presupuesto': e.presupuesto.toString(),
              'ventas': e.ventas.toString(),
              'avance': e.avance.toString(),
            })
        .toList());
  }
}

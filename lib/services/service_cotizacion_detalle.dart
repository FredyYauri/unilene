import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/ModelView.dart';
import '../util/color_constant.dart';

class BackendDetalleCotizacion {
  static Future<List<Map<String, String>>> getDetalleCotizacion(
      String numeroDocumento, int opcion) async {
    String _url;
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');
    _url =
        '${ApiConstant.url}/movil/comercial/api/cotizacion/ListarDetalleCotizaciones?numeroDocumento=$numeroDocumento';

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
    List<DetalleCotizacion> detalleCotizacion = [];
    //List<PorTipoCliente> porTipoCliente = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body)['content'];

      detalleCotizacion = List<DetalleCotizacion>.from(
          json.map((model) => DetalleCotizacion.fromJson(model)));

      if (opcion == 1) {
        detalleCotizacion = List.from(detalleCotizacion.where((x) =>
            x.estado.toString() != "CE" &&
            x.estado.toString() != "CO" &&
            x.estado.toString() != "AN"));
      }

      print('Number of suggestion: ${detalleCotizacion.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(detalleCotizacion
        .map((e) => {
              'numeroDocumento': e.numeroDocumento.toString(),
              'itemCodigo': e.itemCodigo.toString(),
              'descripcion': e.descripcion.toString(),
              'cantidadPedida': e.cantidadPedida.toString(),
              'precioUnitario': e.precioUnitario.toString(),
              'monto': e.monto.toString(),
              'estado': e.estado.toString(),
            })
        .toList());
  }
}

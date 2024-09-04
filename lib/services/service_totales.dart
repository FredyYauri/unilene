import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendTotales {
  static Future<Map<String, double>> getTotales(
      String periodo, String opcion) async {
    Map<String, double> dataMap = {};
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
            '${ApiConstant.url}/movil/comercial/api/comisiones/mensualesPorVendedor?periodo=$periodo'),
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

      /*
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(
          'comisionGanado', body['content']['totales']['comisionGanado']);
      await prefs.setDouble(
          'creditoCobrado', body['content']['totales']['creditoCobrado']);
      await prefs.setDouble(
          'creditoPendiente', body['content']['totales']['creditoPendiente']);
      */
      double _comisionGanado = body['content']['totales']['comisionGanado'];
      double _comisionesPendiente =
          body['content']['totales']['comisionesPendiente'];
      double _facturasCobradas = body['content']['totales']['facturasCobradas'];
      double _facturasPendientes =
          body['content']['totales']['facturasPendientes'];

      if (opcion == '0') {
        //insert data
        dataMap = <String, double>{
          "Comision Ganado": _comisionGanado,
          "Comision Pendiente": _comisionesPendiente,
          //"Facturas Cobradas": _facturasCobradas,
          //"Facturas Pendientes": _facturasPendientes,
        };
      } else {
        dataMap = <String, double>{
          //"Comision Ganado": _comisionGanado,
          //"Comision Pendiente": _comisionesPendiente,
          "Facturas Cobradas": _facturasCobradas,
          "Facturas Pendientes": _facturasPendientes,
        };
      }

      print('Number of suggestion: ${dataMap.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return dataMap;
  }
}

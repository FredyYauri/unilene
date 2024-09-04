import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendTotalesPresupuesto {
  static Future<Map<String, dynamic>> getTotalesPresupuesto() async {
    Map<String, dynamic> dataMap = {};

    final token = await SessionManager().get('token');
    print('Token Session Products: $token');

    double? _presupuestoDia;
    double? _ventasDia;
    double? _avanceDia;

    double? _presupuestoMes;
    double? _ventasMes;
    double? _avanceMes;

    double? _presupuestoAnual;
    double? _ventasAnual;
    double? _avanceAnual;

    final response = await http.get(
        Uri.parse(
            '${ApiConstant.url}/movil/comercial/api/presupuestoVsVentas/alDia_Vendedor'),
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

      _presupuestoDia = body['content']['presupuesto'] ?? 0;
      _ventasDia = body['content']['ventas'] ?? 0;
      _avanceDia = body['content']['avance'] ?? 0;

      print('Number of suggestion: ${dataMap.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    final response2 = await http.get(
        Uri.parse(
            '${ApiConstant.url}/movil/comercial/api/presupuestoVsVentas/mensual_Vendedor'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token,
        });

    print('Token Session: $token');
    print('Request URL: ${response2.request!.url}');
    print('Request headers: ${response2.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response2.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response2.body}');

    //List<Comision> comision = [];
    if (response2.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response2.body);

      _presupuestoMes = body['content']['presupuesto'];
      _ventasMes = body['content']['ventas'];
      _avanceMes = body['content']['avance'];

      print('Number of suggestion: ${dataMap.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    final response3 = await http.get(
        Uri.parse(
            '${ApiConstant.url}/movil/comercial/api/presupuestoVsVentas/anual_Vendedor'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token,
        });

    print('Token Session: $token');
    print('Request URL: ${response3.request!.url}');
    print('Request headers: ${response3.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response3.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response3.body}');

    //List<Comision> comision = [];
    if (response3.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response3.body);

      _presupuestoAnual = body['content']['presupuesto'];
      _ventasAnual = body['content']['ventas'];
      _avanceAnual = body['content']['avance'];

      print('Number of suggestion: ${dataMap.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    //insert data
    dataMap = <String, dynamic>{
      "presupuestoDia": _presupuestoDia,
      "ventasDia": _ventasDia,
      "avanceDia": _avanceDia,
      "presupuestoMes": _presupuestoMes,
      "ventasMes": _ventasMes,
      "avanceMes": _avanceMes,
      "presupuestoAnual": _presupuestoAnual,
      "ventasAnual": _ventasAnual,
      "avanceAnual": _avanceAnual,
    };

    return dataMap;
  }
}

import 'dart:async';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendComision {
  static Future<List<Map<String, String>>> getComision(
      String periodo, int opcion) async {
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

    List<Comision> comision = [];
    if (response.statusCode == 200) {
      //Map<String, dynamic> body = jsonDecode(response.body);
      Iterable json = [];
      switch (opcion) {
        case 1:
          json =
              convert.jsonDecode(response.body)['content']['facturasCobradas'];
          break;
        case 2:
          json = convert.jsonDecode(response.body)['content']
              ['facturasPendientes'];
          break;
        /*
        case 3:
          json = convert.jsonDecode(response.body)['content']['criticos'];
          break;
          */
      }

      comision =
          List<Comision>.from(json.map((model) => Comision.fromJson(model)));

      print('Number of suggestion: ${comision.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(comision
        .map((e) => {
              'documento': e.documento.toString(),
              'cliente': e.cliente.toString(),
              'fechaDocumento': e.fechaDocumento.toString(),
              'fechaVencimiento': e.fechaVencimiento.toString(),
              'diferenciaDias': e.diferenciaDias.toString(),
              'comision': e.comision.toString(),
              'estado': e.pagado.toString()
            })
        .toList());
  }
}

class Comision {
  final String documento;
  final String cliente;
  final String fechaDocumento;
  final String fechaVencimiento;
  final int diferenciaDias;
  final double comision;
  final bool pagado;

  Comision({
    required this.documento,
    required this.cliente,
    required this.fechaDocumento,
    required this.fechaVencimiento,
    required this.diferenciaDias,
    required this.comision,
    required this.pagado,
  });

  factory Comision.fromJson(Map<String, dynamic> json) {
    return Comision(
      documento: json['documento'],
      cliente: json['cliente'],
      fechaDocumento: json['fechaDocumento'],
      fechaVencimiento: json['fechaVencimiento'],
      diferenciaDias: json['diferenciaDias'],
      comision: json['comision'],
      pagado: json['pagado'] ?? '',
    );
  }
}

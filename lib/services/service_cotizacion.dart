import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendCotizacion {
  static Future<List<Map<String, String>>> getCotizaciones(
      String vendedor,
      String descripcion,
      int periodo,
      int cliente,
      String agrupador,
      String subAgrupador,
      int orden,
      int opcion) async {
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

    final response = await http.post(
      Uri.parse(
          '${ApiConstant.url}movil/comercial/api/cotizacion/ListarCotizaciones'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, String>{
        'vendedor': vendedor,
        'descripcion': descripcion,
        'periodo': periodo.toString(),
        'cliente': cliente.toString(),
        'agrupador': agrupador,
        'subAgrupador': subAgrupador,
        'orden': orden.toString()
      }),
    );

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request URL: ${response.request}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response.body}');

    List<Cotizacion> cotizacion = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      cotizacion = List<Cotizacion>.from(
          json.map((model) => Cotizacion.fromJson(model)));

      if (opcion == 1) {
        //Oportunidad, osea tiene gestion
        //cotizacion = List.from(
        //cotizacion.where((x) => x.estadoGestion.toString() == ""));
        cotizacion = cotizacion;
      } else {
        cotizacion = List.from(cotizacion
            .where((x) => x.estadoGestion.toString() == "SIN GESTIÓN"));
      }

      print('Number of suggestion: ${cotizacion.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(cotizacion
        .map((e) => {
              'numeroDocumento': e.numeroDocumento.toString(),
              'cliente': e.cliente.toString(),
              'fechaDocumento': e.fechaDocumento.toString(),
              'fechaVencimiento': e.fechaVencimiento.toString(),
              'montoTotal': e.montoTotal.toString(),
              'estado': e.estado.toString(),
              'diasVencido': e.diasVencido.toString(),
              'estadoGestion': e.estadoGestion.toString(),
              'porcentajeTotal': e.porcentajeTotal.toString(),
              'fechaUltimaGestion': e.fechaUltimaGestion.toString(),
              'preparadoPor': e.preparadoPor.toString(),
            })
        .toList());
  }
}

class Cotizacion {
  final String numeroDocumento;
  final String cliente;
  final String fechaDocumento;
  final String fechaVencimiento;
  final double montoTotal;
  final String estado;
  final int diasVencido;
  final String estadoGestion;
  final String porcentajeTotal;
  final String fechaUltimaGestion;
  final String preparadoPor;

  Cotizacion(
      {required this.numeroDocumento,
      required this.cliente,
      required this.fechaDocumento,
      required this.fechaVencimiento,
      required this.montoTotal,
      required this.estado,
      required this.diasVencido,
      required this.estadoGestion,
      required this.porcentajeTotal,
      required this.fechaUltimaGestion,
      required this.preparadoPor});

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      numeroDocumento: json['numeroDocumento'],
      cliente: json['cliente'],
      fechaDocumento: json['fechaDocumento'],
      fechaVencimiento: json['fechaVencimiento'],
      montoTotal: json['montoTotal'],
      estado: json['estado'],
      diasVencido: json['diasVencido'],
      estadoGestion: json['estadoGestion'],
      porcentajeTotal: json['porcentajeTotal'],
      fechaUltimaGestion: json['fechaUltimaGestion'],
      preparadoPor: json['preparadoPor'],
    );
  }
}

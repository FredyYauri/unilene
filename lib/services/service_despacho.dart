import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendDespacho {
  static Future<List<Map<String, String>>> getDespacho(String query) async {
    /*
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
          '${ApiConstant.url}movil/almacen/api/despacho/detalleGuiaDespacho?guiaDespacho=$query'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      /*
      body: jsonEncode(<String, String>{
        'guiaDespacho': query,
      }),
      */
    );

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response.body}');

    List<Despacho> despacho = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      despacho =
          List<Despacho>.from(json.map((model) => Despacho.fromJson(model)));

      print('Number of suggestion: ${despacho.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(despacho
        .map((e) => {
              'idDispensacion': e.idDispensacion.toString(),
              'ordenFabricacion': e.ordenFabricacion.toString(),
              'secuencia': e.secuencia.toString(),
              'item': e.item.toString(),
              'descripcion': e.descripcion.toString(),
              'lote': e.lote.toString(),
              'documento': e.documento.toString(),
              'cantidad': e.cantidad.toString(),
              'estado': e.estado.toString(),
              'isChecked': e.isChecked.toString(),
            })
        .toList());
  }
}

class Despacho {
  final int idDispensacion;
  final String ordenFabricacion;
  final int secuencia;
  final String item;
  final String descripcion;
  final String lote;
  final String documento;
  final double cantidad;
  final String estado;
  final bool isChecked;

  Despacho(
      {required this.idDispensacion,
      required this.ordenFabricacion,
      required this.secuencia,
      required this.item,
      required this.descripcion,
      required this.lote,
      required this.documento,
      required this.cantidad,
      required this.estado,
      this.isChecked = false});

  factory Despacho.fromJson(Map<String, dynamic> json) {
    return Despacho(
        idDispensacion: json['idDispensacion'],
        ordenFabricacion: json['ordenFabricacion'],
        secuencia: json['secuencia'],
        item: json['item'],
        descripcion: json['descripcion'],
        lote: json['lote'],
        documento: json['documento'],
        cantidad: json['cantidad'],
        estado: json['estado']);
  }
}

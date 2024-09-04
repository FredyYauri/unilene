import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:unilene_app/model/ModelView.dart';
import 'dart:convert' as convert;

import '../util/color_constant.dart';

class BackendToken {
  static Future<List<Map<String, String>>> getRegistroToken(
      int vendedor, String tokenID) async {
    final token = await SessionManager().get('token');
    print('Token Session Products: $token');

    final response = await http.post(
      Uri.parse(
          '${ApiConstant.url}/movil/comercial/api/cotizacion/RegistrarToken'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, String>{
        'vendedor': vendedor.toString(),
        'tokenID': tokenID
      }),
    );

    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    print('Request body: ${response.body}');

    List<Registro> registro = [];

    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body)['content'];
      registro =
          List<Registro>.from(json.map((model) => Registro.fromJson(model)));

      print('Number of suggestion: ${registro.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(registro
        .map((e) => {
              'codeError': e.codeError.toString(),
              'msj': e.msj.toString(),
            })
        .toList());
  }
}

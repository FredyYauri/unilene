import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:unilene_app/model/optionModel.dart';
import 'package:unilene_app/util/color_constant.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../../core/widgets/dialog_services.dart';
class BackendOption{
  static Future<List<Map<String, String>>> getOption(BuildContext context,String name) async{
    String _url;
    final token = await SessionManager().get('token');
    _url =
        '${ApiConstant.url_dev}/movil/comercial/api/ConfiguracionesCRM/obtenerListaOpcionesCombo?campo=$name';
    final response = await http.get(Uri.parse(_url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    });
    List<OptionModel> options = [];
     Iterable json = [];
    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body);
      options = List<OptionModel>.from(
          json.map((model) => OptionModel.fromJson(model)));
    } else {
      showCustomDialog(context, 'Ocurrión Un Error Interno', DialogType.error);
    }

    return Future.value(options
        .map((e) => {
              'codigo': e.codigo.toString(),
              'descripcion': e.descripcion.toString(),
              'auxiliar': e.auxiliar.toString(),              
            })
        .toList());
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:unilene_app/model/tuitionModel.dart';
import '../../core/widgets/dialog_services.dart';
import '../../util/color_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BackendTuition {
  static Future<List<Map<String, String>>> getTuitionContact(BuildContext context,
      String nombres, String codigo) async {
    String _url;
    final token = await SessionManager().get('token');
    print('BackendTuition nombres=$nombres&cuenta=$codigo');
    _url =
        '${ApiConstant.url_dev}/movil/comercial/api/ColegiaturaCRM/consultaColegiatura?codigo=$codigo&nombres=$nombres';

    final response = await http.get(Uri.parse(_url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    });

    print('response BackendTuition body: ${response.body}');

    List<TuitionModel> contacts = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body);
      contacts = List<TuitionModel>.from(
          json.map((model) => TuitionModel.fromJson(model)));
    } else {
      showCustomDialog(context, 'Ocurrión Un Error Interno', DialogType.error);
    }

    return Future.value(contacts
        .map((e) => {
              'tipoCodigo': e.tipoCodigo.toString(),
              'codigo': e.codigo.toString(),
              'apellidoPaterno': e.apellidoPaterno.toString(),
              'apellidoMaterno': e.apellidoMaterno.toString(),
              'nombres': e.nombres.toString(),
              'especialidad': e.especialidad.toString(),              
            })
        .toList());
  }
}

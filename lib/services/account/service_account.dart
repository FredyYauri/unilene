import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:unilene_app/model/AccountsModel.dart';
import 'package:unilene_app/core/widgets/dialog_services.dart';
import '../../util/color_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BackendAccount {
  static Future<List<Map<String, String>>> getAccounts(BuildContext context,
      String nombres) async {
    String _url;
    final token = await SessionManager().get('token');
    _url =
        '${ApiConstant.url_dev}/movil/comercial/api/CuentasCRM/listarCuentas?nombreCuenta=$nombres';

    final response = await http.get(Uri.parse(_url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    });

    print('Request body: ${response.body}');

    List<AccountsModel> accounts = [];
    Iterable json = [];
    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body);
      accounts = List<AccountsModel>.from(
          json.map((model) => AccountsModel.fromJson(model)));
    } else {
      showCustomDialog(context, 'Ocurrión Un Error Interno', DialogType.error);
    }

    return Future.value(accounts
        .map((e) => {
              'codCliente': e.codCliente.toString(),
              'tipoDocumento': e.tipoDocumento.toString(),
              'documento': e.documento.toString(),
              'razonSocial': e.razonSocial.toString(), 
              'tipoCliente': e.tipoCliente.toString(),
              'codVendedor': e.codVendedor.toString(),
              'vendedor': e.vendedor.toString(), 
              'promotor': e.promotor.toString(), 
            })
        .toList());
  }
}

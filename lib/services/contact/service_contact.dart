import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:unilene_app/core/widgets/dialog_services.dart';
import 'package:unilene_app/model/ContactModel.dart';
import '../../util/color_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BackendContact {
  static Future<List<Map<String, dynamic>>> getDetalleContact(
      BuildContext context, String nombres, String cuenta) async {
    String _url;
    final token = await SessionManager().get('token');
    _url =
        '${ApiConstant.url_dev}/movil/comercial/api/ContactosCRM/listarContactos?nombres=$nombres&cuenta=$cuenta';

    final response = await http.get(Uri.parse(_url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    });

    List<ContactModel> contacts = [];
    Iterable json = [];

    if (response.statusCode == 200) {
      json = convert.jsonDecode(response.body);
      contacts = List<ContactModel>.from(
          json.map((model) => ContactModel.fromJson(model)));
    } else {
      showCustomDialog(context, 'Ocurrión Un Error Interno', DialogType.error);
    }
    // print("BackendContact contacts response:${response.body} ");

    return Future.value(contacts
        .map((e) => {
              'codigo': e.codigo.toString(),
              'nombre': e.nombre.toString(),
              'apellidoPaterno': e.apellidoPaterno.toString(),
              'apellidoMaterno': e.apellidoMaterno.toString(),
              'codTipoDocumento': e.codTipoDocumento.toString(),
              'tipoDocumento': e.tipoDocumento.toString(),
              'numeroDocumento': e.numeroDocumento.toString(),
              'genero': e.genero.toString(),
              'correo': e.correo.toString(),
              'cuenta': e.cuenta.toString(),
              'cuentaDescripcion': e.cuentaDescripcion.toString(),
              'redAsistencial': e.redAsistencial?.toString() ?? '',
              'codArea': e.codArea.toString(),
              'area': e.area.toString(),
              'codTipoArea': e.codTipoArea.toString(),
              'tipoArea': e.tipoArea.toString(),
              'codCargo': e.codCargo.toString(),
              'cargo': e.cargo.toString(),
              'celular': e.celular.toString(),
              'cumpleanios': e.cumpleanios?.toString(),
              'notas': e.notas.toString(),
              'estado': e.estado.toString(),
            })
        .toList());
  }

  Future<String> postSaveContact(Map<String, dynamic> contact) async {
    String _url;
    String stringResponse;
    final token = await SessionManager().get('token');
    _url =
        '${ApiConstant.url_dev}/movil/comercial/api/ContactosCRM/crearContacto';
    final body = jsonEncode(contact);
    print(body);
    final response = await http.post(Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: body);
        print(response.body);
    if (response.statusCode == 200) {
      stringResponse = "Datos guardados exitosamente";
    } else {
      stringResponse = "Error Al Registrar Los Datos Del Contacto";
    }
    return stringResponse;
  }

  static Future<bool> postUpdateContact(
      BuildContext context, Map<String, dynamic> contact) async {
    String _url;
    bool boolResponse;
    final token = await SessionManager().get('token');
    _url =
        '${ApiConstant.url_dev}/movil/comercial/api/ContactosCRM/actualizarContacto';
    final body = jsonEncode(contact);
    print(body);
    final response = await http.post(Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token,
        },
        body: body);
        
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      boolResponse =  jsonResponse["success"] ?? false;
    } else {
      boolResponse = false;
    }
    return boolResponse;
  }
}

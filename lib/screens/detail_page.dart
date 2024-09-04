import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:unilene_app/screens/products_page.dart';
import 'package:http/http.dart' as http;

import '../model/ModelView.dart';
import '../util/color_constant.dart';

class DetailScreen extends StatefulWidget {
  final String item;
  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? descripcion;
  String? numeroParte;
  String? marca;
  String? unidad;
  String? color;
  String? presentacion;
  String? linea;
  String? familia;
  String? subFamilia;
  double? stockActual;
  double? stockComprometido;
  double? stockDisponible;
  String? fechaReposicion;
  double? precioBase;
  double? precioRef;
  //List<Map<String, dynamic>> _reposiciones = [];
  List _reposiciones = [];

  @override
  void initState() {
    super.initState();
    getProductData();
  }

  Future<void> getProductData() async {
    final token = await SessionManager().get('token');
    final url = Uri.parse(
        '${ApiConstant.url}/movil/almacen/api/stock/detalleItemStock?item=${widget.item}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final content = jsonResponse['content'];
      final datosItem = content['datosItem'];
      final reposiciones = content['reposiciones'];
      setState(() {
        descripcion = datosItem['descripcion'];
        numeroParte = datosItem['numeroParte'];
        marca = datosItem['marca'];
        unidad = datosItem['unidad'];
        color = (datosItem['color'] ?? '-');
        presentacion = datosItem['presentacion'];
        linea = datosItem['linea'];
        familia = datosItem['familia'];
        subFamilia = datosItem['subFamilia'];
        stockActual = double.parse(datosItem['stockActual'].toString());
        stockComprometido =
            double.parse(datosItem['stockComprometido'].toString());
        stockDisponible = double.parse(datosItem['stockDisponible'].toString());
        fechaReposicion = (datosItem['fechaReposicion'] ?? '-');
        precioBase = double.parse(datosItem['precioBase'].toString());
        precioRef = double.parse(datosItem['precioRef'].toString());
        _reposiciones = reposiciones;
      });
    } else {
      throw Exception('Failed to load product data');
    }
  }

//class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Producto'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    widget.item,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              */
              SizedBox(height: 10),
              _buildDetailItem('Codigo Item :', '${widget.item}'),
              _buildDetailItem('Descripcion :', '${descripcion}'),
              _buildDetailItem('Número Parte :', '${numeroParte}'),
              _buildDetailItem('Marca :', '${marca}'),
              _buildDetailItem('Unidad :', '${unidad}'),
              _buildDetailItem('Color :', '${color}'),
              _buildDetailItem('Presentacion :', '${presentacion}'),
              _buildDetailItem('Linea :', '$linea'),
              _buildDetailItem('Familia :', '${familia}'),
              _buildDetailItem('SubFamilia :', '${subFamilia}'),
              _buildDetailItem('Stock Actual :',
                  NumberFormat('#,###.00').format(stockActual)),
              _buildDetailItem('Stock Comprometido :',
                  NumberFormat('#,###.00').format(stockComprometido)),
              _buildDetailItem('Stock Disponible :',
                  NumberFormat('#,###.00').format(stockDisponible)),
              //_buildDetailItem('Stock en transito :', '${widget.item.item}'),
              _buildDetailItem('Fecha Repos. :', '${fechaReposicion}'),
              //_buildDetailItem('Precio Base :', '${precioBase}'),
              //_buildDetailItem('Precio Referencia :', '${precioRef}'),
              SizedBox(height: 10),
              _listview(),
            ],
          ),
        ));
  }

  Widget _buildDetailItem(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  detail,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  Widget _listview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              'Detalle en Orden Fabricación',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: _reposiciones.isEmpty
                    ? Center(
                        child: Text(
                          'No se tiene informacion para el producto',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            //color: Colors.blue
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _reposiciones.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _reposiciones[index];
                          return GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              title: Text(
                                item['fechaComprometida'].toString(),
                                //' ' +
                                //item['almacen'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold,
                                  //color: Colors.blue
                                ),
                              ),
                              subtitle: Text(item['almacen'].toString()),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    NumberFormat('#,###.00')
                                        .format(item['cantidad']),
                                    //item['cantidad'].toString(),
                                  ),
                                  SizedBox(height: 4),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }
}

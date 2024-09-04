import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../util/color_constant.dart';

class DetailComision extends StatefulWidget {
  final String item;
  const DetailComision({Key? key, required this.item}) : super(key: key);

  @override
  _DetailComisionState createState() => _DetailComisionState();
}

class _DetailComisionState extends State<DetailComision> {
  String? numeroDocumento;
  String? cliente;
  String? tipoVenta;
  String? formadePago;
  String? moneda;
  String? ordenCompra;
  String? pedidoNumero;
  String? preparadoPor;
  String? fechaEmision;
  String? fechaVencimiento;
  String? fechaCancelacion;
  int? diasAtraso;
  double? montoAfecto;
  double? montoImpuesto;
  double? montoTotal;
  double? totalComision;
  double? margen;
  double? margenPorciento;
  double? montoPagado;
  double? saldo;
  double? comisionGanado;
  List _cobranzas = [];

  @override
  void initState() {
    super.initState();
    getComisionData();
  }

  Future<void> getComisionData() async {
    final token = await SessionManager().get('token');
    final url = Uri.parse(
        '${ApiConstant.url}/movil/comercial/api/comisiones/detalleDocumentoVenedor?documento=${widget.item}');
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
      //final content = jsonResponse['content'];
      final datosItem = jsonResponse['content'];
      final cobranzas = jsonResponse['content']['cobranzas'];
      setState(() {
        numeroDocumento = datosItem['numeroDocumento'];
        cliente = datosItem['cliente'];
        tipoVenta = datosItem['tipoVenta'];
        formadePago = (datosItem['formadePago'] ?? '-');
        moneda = datosItem['moneda'];
        ordenCompra = (datosItem['ordenCompra'] ?? '-');
        pedidoNumero = (datosItem['pedidoNumero'] ?? '-');
        preparadoPor = datosItem['preparadoPor'];
        fechaEmision = datosItem['fechaEmision'];
        fechaVencimiento = datosItem['fechaVencimiento'];

        if (datosItem['fechaCancelacion'] != null) {
          fechaCancelacion = DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(datosItem['fechaCancelacion']));
        } else {
          fechaCancelacion = '-';
        }

        diasAtraso = int.parse(datosItem['diasAtraso'].toString());
        montoAfecto = double.parse(datosItem['montoAfecto'].toString());
        montoImpuesto = double.parse(datosItem['montoImpuesto'].toString());
        montoTotal = double.parse(datosItem['montoTotal'].toString());
        totalComision = double.parse(datosItem['totalComision'].toString());
        //margen = double.parse(datosItem['margen'].toString());
        //margenPorciento = double.parse(datosItem['margenPorciento'].toString());
        montoPagado = double.parse(datosItem['montoPagado'].toString());
        saldo = double.parse(datosItem['saldo'].toString());
        comisionGanado = double.parse(datosItem['comisionGanado'].toString());
        _cobranzas = cobranzas;
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
          title: Text('Detalle Movimiento'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    widget.item,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildDetailItem('Documento :', '${numeroDocumento}'),
              _buildDetailItem('Cliente :', '${cliente}'),
              _buildDetailItem('Tipo Venta :', '${tipoVenta}'),
              _buildDetailItem('Forma Pago :', '${formadePago}'),
              _buildDetailItem('Moneda :', '${moneda}'),
              _buildDetailItem('Orden Compra :', '${ordenCompra}'),
              _buildDetailItem('Nro. Pedido :', '${pedidoNumero}'),
              _buildDetailItem('Preparado por :', '${preparadoPor}'),
              _buildDetailItem(
                  'Fecha Emision :',
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(fechaEmision.toString()))),
              _buildDetailItem(
                  'Fecha Vencimiento :',
                  DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(fechaVencimiento.toString()))),
              _buildDetailItem('Fecha Cancelacion :', '$fechaCancelacion'),
              _buildDetailItem(
                  'Dias Atraso :', NumberFormat('#,###').format(diasAtraso)),
              _buildDetailItem('Monto Afecto :',
                  NumberFormat('#,###.00').format(montoAfecto)),
              _buildDetailItem('Monto Impuesto :',
                  NumberFormat('#,###.00').format(montoImpuesto)),
              _buildDetailItem(
                  'Monto Total :', NumberFormat('#,###.00').format(montoTotal)),
              _buildDetailItem('Total Comision :', '${totalComision}'),
              //_buildDetailItem('Margen :', '${margen}'),
              //_buildDetailItem('Margen(%) :', '${margenPorciento}'),
              _buildDetailItem('Monto Pagado :',
                  NumberFormat('#,###.00').format(montoPagado)),
              _buildDetailItem(
                  'Saldo :', NumberFormat('#,##0.00').format(saldo)),
              _buildDetailItem('Comision Ganado :', '${comisionGanado}'),
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
              'Detalle Pagos',
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
                child: _cobranzas.isEmpty
                    ? Center(
                        child: Text(
                          'No se tiene informacion para el documento',
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
                        itemCount: _cobranzas.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _cobranzas[index];
                          final monto = double.parse(item['monto'].toString());
                          return GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              title: Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                        item['fecha'].toString())) +
                                    ' Comisión ' +
                                    item['comision'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold,
                                  //color: Colors.blue
                                ),
                              ),
                              /*
                                  subtitle: Text(DateFormat('dd/MM/yyyy')
                                          .format(DateTime.parse(
                                              item['fechaDocumento']
                                                  .toString())) +
                                      ' | ' +
                                      item['documento'].toString()),
                                      */
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(NumberFormat('#,###.00').format(monto)),
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

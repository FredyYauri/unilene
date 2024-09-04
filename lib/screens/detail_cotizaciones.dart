import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unilene_app/screens/gestion_new.dart';
import 'package:unilene_app/services/service_cotizacion_detalle.dart';
import 'package:unilene_app/services/service_cotizacion_gestion.dart';

import '../util/color_constant.dart';

class DetailCotizacion extends StatefulWidget {
  final String item;
  final String numeroDocumento;
  final String estado;
  final double monto;
  final String fechaGestion;
  final String preparadoPor;
  const DetailCotizacion(
      {Key? key,
      required this.item,
      required this.numeroDocumento,
      required this.estado,
      required this.monto,
      required this.fechaGestion,
      required this.preparadoPor})
      : super(key: key);

  @override
  _DetailCotizacionState createState() => _DetailCotizacionState();
}

class _DetailCotizacionState extends State<DetailCotizacion> {
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
  List<Map<String, String>> _detalleProductos = [];
  List<Map<String, String>> _detalleGestion = [];

  @override
  void initState() {
    super.initState();
    //getComisionData();
    BackendDetalleCotizacion.getDetalleCotizacion(widget.numeroDocumento, 0)
        .then((value) => setState(() {
              _detalleProductos = value;
            }));
    BackendGestionCotizacion.getGestionCotizacion(widget.numeroDocumento)
        .then((value) => setState(() {
              _detalleGestion = value;
            }));
  }

/*
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
  */

//class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Cotización'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Center(
                  child: Text(
                    widget.item,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 10),
              //_buildDetailItem('Nro. Cotización :', widget.numeroDocumento),
              //_buildDetailItem('Estado :', widget.estado),
              _buildDetailItem('Monto Total :',
                  NumberFormat('#,###.00').format(widget.monto)),
              _buildDetailItem('Fecha Ult. Gestión :',
                  widget.fechaGestion.toString() ?? 'N/A'),
              _buildDetailItem('Preparado por :', widget.preparadoPor),
              SizedBox(height: 2),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Productos'),
                          Tab(text: 'Gestión'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: TabBarView(
                          children: [
                            //Center(child: Text('texto1')), // Content for Tab 1
                            _buildDetalleCotizacionListView(),
                            //Center(child: Text('texto2')), // Content for Tab 2
                            _buildDetalleGestionListView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom:
                16.0, // Ajusta la posición vertical del botón flotante según tus necesidades
            right:
                16.0, // Ajusta la posición horizontal del botón flotante según tus necesidades
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to the desired screen here
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewGestionCotizacion(
                              item: widget.item.toString(),
                              numeroDocumento:
                                  widget.numeroDocumento.toString(),
                              estado: widget.estado,
                              monto: widget.monto,
                              fechaGestion: widget.fechaGestion,
                              preparadoPor: widget.preparadoPor,
                              gestionId: 0,
                              mode: "R",
                            )));
              },
              child: Icon(Icons.add), // Customize the icon as needed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //SizedBox(height: 5),
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
              //SizedBox(width: 10),
              Expanded(
                child: Text(
                  detail,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        //SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  Widget _buildDetalleCotizacionListView() {
    // ... your existing _listview() code
    return _listview();
  }

  Widget _buildDetalleGestionListView() {
    // ... your existing _listviewGestion() code
    return _listviewGestion();
  }

  Widget _listview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //SizedBox(height: 5),
        /*
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              'Detalle Cotizacion',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        */
        //SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 385,
                    child: _detalleProductos.isEmpty
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
                            itemCount: _detalleProductos.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _detalleProductos[index];
                              final cantidad = double.parse(
                                  item['cantidadPedida'].toString());
                              final precioUnitario = double.parse(
                                  item['precioUnitario'].toString());
                              final monto =
                                  double.parse(item['monto'].toString());

                              String estado = item['estado'].toString();
                              String descripcion = "";

                              switch (estado) {
                                case "CO":
                                  descripcion = "COMPLETADO";
                                  break;
                                case "PR":
                                  descripcion = "EN PREPARACIÓN";
                                  break;
                                case "PE":
                                  descripcion = "PENDIENTE";
                                  break;
                                case "CE":
                                  descripcion = "CERRADO";
                                  break;
                                case "AN":
                                  descripcion = "ANULADO";
                                  break;
                                default:
                                  descripcion = "";
                                  break;
                              }

                              return GestureDetector(
                                onTap: () {},
                                child: ListTile(
                                  title: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*
                                      Text(
                                        'Item : ' +
                                            item['itemCodigo'].toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      */
                                      Text(
                                        item['descripcion'].toString(),
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          'Unds: ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.0),
                                        ),
                                        Text(
                                            NumberFormat('#,###')
                                                .format(cantidad),
                                            style: TextStyle(fontSize: 13.0)),
                                        Spacer(),
                                        Text(
                                          'Precio Unitario: ',
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                        Text(
                                            NumberFormat('#,###.00')
                                                .format(precioUnitario),
                                            style: TextStyle(fontSize: 13.0)),
                                        //Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          'Monto: ',
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                        Text(
                                            NumberFormat('#,###.00')
                                                .format(monto),
                                            style: TextStyle(fontSize: 13.0)),
                                        Spacer(),
                                        Text(
                                          'Mto IGV: ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.0),
                                        ),
                                        Text(
                                            NumberFormat('#,###.00')
                                                .format(monto * 1.18),
                                            style: TextStyle(fontSize: 13.0)),
                                        //Spacer(),
                                        //Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        //Spacer(),
                                        Text(
                                          'Pend: ',
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                        Text(
                                            NumberFormat('#,###.00')
                                                .format(monto),
                                            style: TextStyle(fontSize: 13.0)),
                                        Spacer(),
                                        Text(descripcion,
                                            style: TextStyle(fontSize: 13.0)),
                                      ],
                                    )
                                  ]),

                                  /*
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(NumberFormat('#,###.00')
                                      .format(precioUnitario)),
                                  SizedBox(height: 4),
                                ],
                              ),
                              */
                                ),
                              );
                            }),
                  ),
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

  Widget _listviewGestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //SizedBox(height: 5),
        /*
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              'Detalle Gestion',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        */
        //SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 385,
                    child: _detalleGestion.isEmpty
                        ? Center(
                            child: Text(
                              'No se tiene informacion de gestión.',
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
                            itemCount: _detalleGestion.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _detalleGestion[index];
                              return GestureDetector(
                                onTap: () {
                                  if (item['tipoGestion'].toString() ==
                                      "DETALLADO") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewGestionCotizacion(
                                                    item:
                                                        widget.item.toString(),
                                                    numeroDocumento: widget
                                                        .numeroDocumento
                                                        .toString(),
                                                    estado: widget.estado,
                                                    monto: widget.monto,
                                                    fechaGestion:
                                                        widget.fechaGestion,
                                                    preparadoPor:
                                                        widget.preparadoPor,
                                                    gestionId: int.parse(
                                                        item['gestionId']
                                                            .toString()),
                                                    mode: "E")));
                                  }
                                },
                                child: ListTile(
                                  title: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['fechaGestion'].toString() +
                                            ' - ' +
                                            item['tipoGestion'].toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4)
                                    ],
                                  ),
                                  subtitle: Column(children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          'Tipo Resultado : ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.0),
                                        ),
                                        Text(item['tipoResultado'].toString(),
                                            style: TextStyle(fontSize: 13.0)),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    if (item['tipoResultado'].toString() ==
                                        'PERDIDO') ...[
                                      // Show "Motivo" when tipoResultado is Perdido
                                      Row(
                                        children: [
                                          Text(
                                            'Motivo : ',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          Text(
                                            item['tipoMotivo'].toString(),
                                            style: TextStyle(fontSize: 13.0),
                                          ),
                                        ],
                                      ),
                                    ] else ...[
                                      // Show "Tipo Riesgo" when tipoResultado is not Perdido
                                      Row(
                                        children: [
                                          Text(
                                            'Tipo Riesgo : ',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          Text(
                                            item['tipoRiesgo'].toString(),
                                            style: TextStyle(fontSize: 13.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ]),

                                  /*
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(NumberFormat('#,###.00')
                                      .format(precioUnitario)),
                                  SizedBox(height: 4),
                                ],
                              ),
                              */
                                ),
                              );
                            }),
                  ),
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
}

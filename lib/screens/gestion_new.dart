import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unilene_app/screens/cotizaciones_page.dart';
import 'package:unilene_app/screens/detail_cotizaciones.dart';
import 'package:unilene_app/services/service_cotizacion_detalle.dart';
import 'package:unilene_app/services/service_cotizacion_gestion.dart';
import 'package:unilene_app/services/service_cotizacion_gestion_detalle.dart';
import 'package:unilene_app/services/service_listado.dart';
import 'package:unilene_app/services/service_registro.dart';
import 'package:unilene_app/services/service_registro_detalle.dart';
import 'package:unilene_app/services/service_usuario.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../util/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewGestionCotizacion extends StatefulWidget {
  final String item;
  final String numeroDocumento;
  final String estado;
  final double monto;
  final String fechaGestion;
  final String preparadoPor;
  final int gestionId;
  final String mode;
  //const NewGestionCotizacion({Key? key, required this.item}) : super(key: key);
  const NewGestionCotizacion(
      {Key? key,
      required this.item,
      required this.numeroDocumento,
      required this.estado,
      required this.monto,
      required this.fechaGestion,
      required this.preparadoPor,
      required this.gestionId,
      required this.mode})
      : super(key: key);

  @override
  _NewGestionCotizacionState createState() => _NewGestionCotizacionState();
}

class _NewGestionCotizacionState extends State<NewGestionCotizacion> {
  List<Map<String, String>> _registro = [];
  bool _selectedButtonGeneral = false;
  //int _selectedButtonDetallado = 2;
  String _selectedValueCanal = 'V';
  String _selectedValueResultado = 'C';

  final _monedaController = TextEditingController();
  String _monedaValue = '';

  String selectedDetail = "Visita";
  String selectedDetailResultado = "-- SELECCIONE --";
  String selectedDetailRiesgo = "-- SELECCIONE --";
  String selectedDetailMotivo = "-- SELECCIONE --";
  String selectedDetailMotivoParcial = "-- SELECCIONE --";
  String selectedMoneda = "S/";
  String selectedDetailProveedor = "-- SELECCIONE --";

  bool _showRiesgo = false; // Flag to control Riesgo visibility
  bool _showMotivo = false; // Flag to control Motivo visibility
  bool _showMotivoParcial = false;
  bool _showMoneda = false;

  List<Map<String, String>> _detalleProductos = [];
  List<Map<String, String>> _detalleGestion = [];
  List<Map<String, String>> _listado = [];

  int codeError = 0;
  int id = 0;
  List<String> myDispatch = [];

  List<String> checkedItemCodigos = [];
  String? _id = "";

  String tipo = "";
  String strResultado = "";
  String strRiesgo = "";
  String strMotivo = "";
  String strMoneda = "";
  String strProveedor = "";

  Map<String, dynamic> _datosUsuario = {};
  String vendedor = "";
  String? androidId = "";

  //String? _selectOption;
  //int? _selectedIndex;
  bool _isSpecificMotivoSelected = false;
  int _selectedProductIndex = -1;

  List<Map<String, String>> _motivoItems = [];
  List<Map<String, String>> _proveedorItems = [];
  List<Map<String, String>> _motivoParcialItems = [];
  int _currentDialogType = 0;

  List<SimpleDialogOption> _buildDialogOptions(
      List<Map<String, String>> list, int tipo) {
    return list.map((item) {
      return SimpleDialogOption(
        child: Text(item['descripcion'].toString()),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            switch (tipo) {
              case 1:
                selectedDetailMotivo = item['descripcion'].toString();
                strMotivo = item['codigo'].toString();
                if (strMotivo == "1") {
                  //_selectOption = "P";
                  _isSpecificMotivoSelected = true;
                  _showMoneda = true;
                  //PopulateItems(4);
                } else {
                  //_selectOption = "";
                  _isSpecificMotivoSelected = false;
                  _showMoneda = false;
                  //PopulateItems(1);
                }
                break;
              case 2:
                selectedDetailRiesgo = item['descripcion'].toString();
                strRiesgo = item['codigo'].toString();
                break;
              case 3:
                selectedDetailResultado = item['descripcion'].toString();
                strResultado = item['codigo'].toString();
                break;
              case 4:
                selectedMoneda = item['descripcion'].toString();
                strMoneda = item['codigo'].toString();
                break;
              case 5:
                selectedDetailProveedor = item['descripcion'].toString();
                strProveedor = item['codigo'].toString();
                break;
              case 6:
                selectedDetailMotivo = item['descripcion'].toString();
                strMotivo = item['codigo'].toString();
                break;
              default:
                // Retornar un valor predeterminado si no coincide ningún caso
                break;
            }

            // Update detail here (if needed)
            //_showRiesgo = true; // Show Riesgo widget
            //_showMotivo = false; // Hide Motivo widget
          });
        },
      );
    }).toList();
  }

  void PopulateItems(int tiporetorno) {
    BackendListadoCatalogo.getListadoCatalogo(tiporetorno)
        .then((value) => setState(() {
              switch (tiporetorno) {
                case 1:
                  _motivoItems = value;
                  _currentDialogType = 1;
                  break;
                case 2:
                  _listado = value;
                  _currentDialogType = 2;
                  break;
                case 5:
                  _proveedorItems = value;
                  _currentDialogType = 5;
                  break;
                case 6:
                  _motivoParcialItems = value;
                  _currentDialogType = 6;
                  break;
                default:
                  _listado = value;
                  print('_listado: $_listado');
              }
            }));
  }

  @override
  void initState() {
    super.initState();

    BackendUsuario.getUsuario().then((value) => setState(() {
          _datosUsuario = value;
          print('_datos usuario: $_datosUsuario');
          vendedor = _datosUsuario['codigo'].toString();
          print('_datos _vendedor: $vendedor');
        }));

    if (widget.mode == "E") {
      setState(() {
        _selectedButtonGeneral = true;

        //selectedDetailResultado = "";
        //selectedDetailRiesgo = "RIESGO";
        //selectedDetailMotivo = "MOTIVO";

        BackendGestionCotizacion.getGestionCotizacion(widget.numeroDocumento)
            .then((value) => setState(() {
                  _detalleGestion = value;
                  List<Map<String, String>> listaFiltrada = _detalleGestion
                      .where((item) =>
                          item['gestionId'] == widget.gestionId.toString())
                      .toList();
                  selectedDetailResultado =
                      listaFiltrada[0]['tipoResultado'].toString();
                  selectedDetailRiesgo =
                      listaFiltrada[0]['tipoRiesgo'].toString();
                  selectedDetailMotivo =
                      listaFiltrada[0]['tipoMotivo'].toString();

                  if (selectedDetailResultado == "EN CURSO") {
                    _showRiesgo = true;
                  } else {
                    _showMotivo = true;
                  }
                }));

        BackendGestionCotizacionDetalle.getGestionCotizacionDetalle(
                widget.gestionId.toString())
            .then((value) => setState(() {
                  checkedItemCodigos = value
                      .map((item) => item['itemCodigo'].toString().trim())
                      .toList();
                  print('Valor de checkedItemCodigos : ${checkedItemCodigos}');
                }));
      });
    }

    //_showSingleDialogResultado();
    //getComisionData();
    BackendDetalleCotizacion.getDetalleCotizacion(widget.numeroDocumento, 1)
        .then((value) => setState(() {
              _detalleProductos = value;
            }));
  }

  Future<void> _setSessionId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = value;
    });
    await prefs.setString('id', value);
  }

  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }

  Future<bool> registro() async {
    //Obtener el AndroidID

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo =
        await deviceInfoPlugin.androidInfo; // Wait for the future to complete

    androidId = androidInfo.id; // Access ID from the AndroidDeviceInfo object

    // Handle potential null value
    if (androidId != null) {
      print('Android ID: $androidId');
    } else {
      print('Android ID unavailable');
    }

    bool _validar = true;

    switch (selectedDetailResultado) {
      case 'En Curso':
        strResultado = 'C';
        break;
      case 'Perdido':
        strResultado = 'P';
        break;
      case 'Completado Parcial':
        strResultado = 'CP';
        break;
      default:
        strResultado = 'X';
    }

    /*
    switch (selectedDetailRiesgo) {
      case 'Bajo':
        strRiesgo = 'B';
        break;
      case 'Medio':
        strRiesgo = 'M';
        break;
      case 'Alto':
        strRiesgo = 'A';
        break;
      default:
        strRiesgo = '';
    }
    */

    // switch (selectedDetailMotivo) {
    //   case 'Por precio':
    //     strMotivo = '1';
    //     break;
    //   case 'Por licitación':
    //     strMotivo = '2';
    //     break;
    //   case 'SobreStock':
    //     strMotivo = '3';
    //     break;
    //   case 'Abastecimiento por otras entidades':
    //     strMotivo = '4';
    //     break;
    //   case 'No pasa validación muestra':
    //     strMotivo = '5';
    //     break;
    //   case 'Por relación logística':
    //     strMotivo = '6';
    //     break;
    //   case 'Por presentar cotización fuera de fecha':
    //     strMotivo = '7';
    //     break;
    //   default:
    //     strMotivo = '';
    // }

    if (_selectedButtonGeneral == true) {
      tipo = "D";
    } else {
      tipo = "G";
    }

    print('Valor de strResultado : ${strResultado}');

    if (strResultado == 'X') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Falta seleccionar un RESULTADO para realizar el registro.'),
          duration: Duration(seconds: 3),
        ),
      );
      _validar = false;
      //return;
    }

    if (strResultado != 'X') {
      if (strResultado == 'C') {
        if (strRiesgo == '') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Falta seleccionar un RIESGO para realizar el registro.'),
              duration: Duration(seconds: 3),
            ),
          );
          _validar = false;
          //return;
        }
      } else {
        if (strMotivo == '') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Falta seleccionar un MOTIVO para realizar el registro.'),
              duration: Duration(seconds: 3),
            ),
          );
          _validar = false;
          //return;
        }
      }
    }

    return _validar;
  }

  void registroGestion() {
    print('myDispacth str: ${_registro.join(',')}');
    BackendRegistro.getRegistro(
            widget.numeroDocumento,
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(DateTime.now().toString())),
            tipo,
            'V',
            strResultado,
            strRiesgo,
            strMotivo,
            vendedor,
            androidId ?? '',
            strMoneda,
            _monedaController.text,
            strProveedor,
            myDispatch.join(','))
        .then((value) => setState(() {
              _registro = value;
              codeError = int.parse(_registro[0]['codeError'].toString());
              codeError = codeError + 1;
              _setSessionId(codeError.toString());
              if (codeError != 0 && _selectedButtonGeneral == false) {
                print('Request body: ${_registro}');
                print(
                    'Valor de registro: ${_registro[0]['codeError'].toString()}');
              }
            }));
  }

  // void registroDetalle(
  //     int gestionId, String numeroDocumento, String itemCodigo) {
  //   BackendRegistroDetalle.getRegistroDetalle(
  //           gestionId, numeroDocumento, itemCodigo, vendedor, androidId ?? '')
  //       .then((value) => setState(() {
  //             _registro = value;
  //             int codeError = int.parse(_registro[0]['codeError'].toString());
  //             if (codeError == 0 && _selectedButtonGeneral == true) {
  //               print('Request body: ${_registro}');
  //               print(
  //                   'Valor de registro: ${_registro[0]['codeError'].toString()}');
  //             }
  //           }));
  // }

/*
  Future<void> getComisionData() async {
    final token = await SessionManager().get('token');
    final url = Uri.parse(
        '${ApiConstant.url}/movil/comercial/api/comisiones/detalleDocumentoVenedor?documento=${0}');
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
        title: Text('Nueva Gestión'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.mode != "E",
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedButtonGeneral = false;
                        });
                      },
                      icon: _selectedButtonGeneral == 1
                          ? Icon(Icons.description_sharp)
                          : const SizedBox.shrink(),
                      label: Text('General',
                          style: TextStyle(
                            color: _selectedButtonGeneral == false
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedButtonGeneral == false
                            ? Colors.blue
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2.2,
                            40.0), // Adjust width based on screen size
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.mode != "E",
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedButtonGeneral = true;
                        });
                      },
                      icon: _selectedButtonGeneral == true
                          ? Icon(Icons.density_medium_sharp)
                          : const SizedBox.shrink(),
                      label: Text('Detallado',
                          style: TextStyle(
                            color: _selectedButtonGeneral == true
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedButtonGeneral == true
                            ? Colors.blue
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2.2,
                            40.0), // Adjust width based on screen size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Cotización ' + int.parse(widget.numeroDocumento).toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildDetailItem(
                'Fecha :',
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(DateTime.now().toString()))),
            //_buildDetailItemCanal('Canal :', selectedDetail),
            _buildDetailItemResultado('Resultado :', selectedDetailResultado),
            /*
            _buildDetailItemRiesgo('Riesgo', selectedDetailRiesgo),
            _buildDetailItemMotivo('Motivo', selectedDetailMotivo),
            */
            _showRiesgo
                ? _buildDetailItemRiesgo('Riesgo', selectedDetailRiesgo)
                : SizedBox(),
            _showMotivo
                ? _buildDetailItemMotivo('Motivo', selectedDetailMotivo)
                : SizedBox(),
            _showMotivoParcial
                ? _buildDetailItemMotivoParcial(
                    'Motivo Parcial', selectedDetailMotivoParcial)
                : SizedBox(),
            _showMoneda && _selectedButtonGeneral
                ? _buildDetailItemProveedor('Proveedor', selectedDetailMotivo)
                : SizedBox(),
            _showMoneda && _selectedButtonGeneral
                ? _buildDetailItemMoneda('Precio', selectedMoneda)
                : SizedBox(),
            //SizedBox(height: 5),
            //_listview(),
            _selectedButtonGeneral ? _listview() : SizedBox(),

            SizedBox(
              child: Center(
                child: Visibility(
                  // Hide the button if mode is "E"
                  visible: widget.mode != "E",
                  child: ElevatedButton(
                    onPressed: () async {
                      // Tu código aquí
                      if (_selectedButtonGeneral == false) {
                        //registro();
                        bool registroExitoso =
                            await registro().then((value) => value);
                        if (registroExitoso) {
                          registroGestion();
                          if (strResultado == 'P') {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Registro Exitoso'),
                                    content: Text(
                                        'Se ha registrado la gestión correctamente'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyCotizacionPage()),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Registro Exitoso'),
                                    content: Text(
                                        'Se ha registrado la gestión correctamente'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailCotizacion(
                                                        item: widget.item,
                                                        numeroDocumento: widget
                                                            .numeroDocumento,
                                                        estado: widget.estado,
                                                        monto: widget.monto,
                                                        fechaGestion:
                                                            widget.fechaGestion,
                                                        preparadoPor: widget
                                                            .preparadoPor)),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      } else {
                        if (myDispatch.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Debes seleccionar al menos un producto del listado.'),
                              duration: Duration(
                                  seconds: 3), // Adjust duration as needed
                            ),
                          );
                        } else {
                          bool registroExitoso =
                              await registro().then((value) => value);
                          print('_session registroExitoso: $registroExitoso');
                          if (registroExitoso) {
                            registroGestion();
                            //if (_selectedButtonGeneral == true) {
                            //print('_session id entro al for: $_id');

                            // for (var item in myDispatch) {
                            //   print('_session id entro: $_id');
                            //   // Invocar al método registro() para cada item
                            //   print('_session id para grabar: $_id');
                            //   registroDetalle(1, widget.numeroDocumento, item);
                            // }
                            // print('_session termino: $_id');
                            //}
                            /*
                            getId().then((value) {
                              setState(() {
                                _id = value;
                                print('_session id: $_id');
                                print(
                                    '_session button: $_selectedButtonGeneral');
                              });
                              print('_session button: $_selectedButtonGeneral');
                              print('_session id 2: $_id');
                              if (_selectedButtonGeneral ==
                                  true /*&& id != 0*/) {
                                print('_session id entro al for: $_id');

                                for (var item in myDispatch) {
                                  print('_session id entro: $_id');
                                  // Invocar al método registro() para cada item
                                  print('_session id para grabar: $_id');
                                  registroDetalle(int.parse(_id.toString()),
                                      widget.numeroDocumento, item);
                                }
                                print('_session termino: $_id');
                              }
                            });
                            */

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Registro Exitoso'),
                                    content: Text(
                                        'Se ha registrado la gestión correctamente'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailCotizacion(
                                                        item: widget.item,
                                                        numeroDocumento: widget
                                                            .numeroDocumento,
                                                        estado: widget.estado,
                                                        monto: widget.monto,
                                                        fechaGestion:
                                                            widget.fechaGestion,
                                                        preparadoPor: widget
                                                            .preparadoPor)),
                                          );
                                          // Navigator.pushReplacement(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           MyCotizacionPage()),
                                          // );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(350, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      textStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    child: Text('Confirmar'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildDetailItemCanal(String title, String detail) {
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
              GestureDetector(
                onTap: () => _showSingleDialog(),
                child: Text(
                  selectedDetail,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
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

  void _showSingleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //backgroundColor: Colors.transparent,
          //elevation: 0.0,
          // Title can be added if desired
          title: Text('Selecciona Canal'),
          children: [
            SimpleDialogOption(
              child: Text('Visita'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetail = 'Visita'; // Update detail here (if needed)
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItemResultado(String title, String detail) {
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
              GestureDetector(
                onTap: () => _showSingleDialogResultado(),
                child: Text(
                  selectedDetailResultado,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
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

  void _showSingleDialogResultado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //backgroundColor: Colors.transparent,
          //elevation: 0.0,
          // Title can be added if desired
          title: Text('Seleccione Resultado'),
          children: [
            SimpleDialogOption(
              child: Text('En Curso'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailResultado =
                      'En Curso'; // Update detail here (if needed)
                  _showRiesgo = true; // Show Riesgo widget
                  _showMotivo = false; // Hide Motivo widget
                  _showMoneda = false;
                  PopulateItems(2);
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Perdido'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailResultado = 'Perdido';
                  _showRiesgo = false; // Hide Riesgo widget
                  _showMotivo = true;
                  _showMotivoParcial =
                      false; // Show Motivo widget // Update detail here (if needed)
                  PopulateItems(1);
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Completado Parcial'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailResultado = 'Completado Parcial';
                  _showRiesgo = false;
                  _showMotivo = false; // Hide Riesgo widget
                  _showMotivoParcial =
                      true; // Show Motivo widget // Update detail here (if needed)
                  _showMoneda = false;
                  PopulateItems(6);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItemRiesgo(String title, String detail) {
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
              GestureDetector(
                //onTap: () => _showSingleDialogRiesgo(),
                onTap: () => _showSingleDialogItems(2),
                child: Text(
                  selectedDetailRiesgo,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
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

/*
  void _showSingleDialogRiesgo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //backgroundColor: Colors.transparent,
          //elevation: 0.0,
          // Title can be added if desired
          title: Text('Seleccione Riesgo'),
          children: [
            SimpleDialogOption(
              child: Text('Bajo'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailRiesgo =
                      'Bajo'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Medio'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailRiesgo =
                      'Medio'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Alto'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailRiesgo =
                      'Alto'; // Update detail here (if needed)
                });
              },
            ),
          ],
        );
      },
    );
  }
  */

  void _showSingleDialogItems(int tipo) {
    _currentDialogType = tipo;
    PopulateItems(tipo);
    String title = "";
    switch (tipo) {
      case 1:
        title = "Seleccione motivo";
        _currentDialogType = 1;
        break;
      case 2:
        title = "Seleccione riesgo";
        _currentDialogType = 2;
        break;
      case 3:
        title = "Seleccione resultado";
        break;
      case 4:
        title = "Seleccione moneda";
        break;
      case 5:
        title = "Seleccione proveedor";
        if (strMotivo == "1") {
          _currentDialogType = 5;
          PopulateItems(5);
        } else {
          _currentDialogType = 0;
        }
        break;
      case 6:
        title = "Seleccione motivo";
        _currentDialogType = 6;
        break;
      default:
        // Retornar un valor predeterminado si no coincide ningún caso
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Widget> dialogOptions;
        switch (_currentDialogType) {
          case 1:
            dialogOptions =
                _buildDialogOptions(_motivoItems, _currentDialogType);
            break;
          case 2:
            dialogOptions = _buildDialogOptions(_listado, _currentDialogType);
            break;
          case 5:
            dialogOptions =
                _buildDialogOptions(_proveedorItems, _currentDialogType);
            break;
          case 6:
            dialogOptions =
                _buildDialogOptions(_motivoParcialItems, _currentDialogType);
            break;
          default:
            dialogOptions = [];
            break;
        }
        return SimpleDialog(
          //backgroundColor: Colors.transparent,
          //elevation: 0.0,
          // Title can be added if desired
          title: Text(title),
          //children: _buildDialogOptions(_listado, tipo),
          children: dialogOptions,
        );
      },
    ).then((_) {
      setState(() {
        _currentDialogType = 0; // Restablecer el tipo de diálogo
      });
    });
  }

  Widget _buildDetailItemMotivo(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  //onTap: () => _showSingleDialogMotivo(),
                  onTap: () {
                    //_currentDialogType = 1;
                    _showSingleDialogItems(1);
                  },
                  child: Text(
                    selectedDetailMotivo,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.right,
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

  Widget _buildDetailItemMotivoParcial(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  //onTap: () => _showSingleDialogMotivo(),
                  onTap: () {
                    //_currentDialogType = 1;
                    _showSingleDialogItems(6);
                  },
                  child: Text(
                    selectedDetailMotivo,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.right,
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

  Widget _buildDetailItemProveedor(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  //onTap: () => _showSingleDialogMotivo(),
                  onTap: () {
                    //_currentDialogType = 5;
                    _showSingleDialogItems(5);
                  },
                  child: Text(
                    selectedDetailProveedor,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.right,
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

  Widget _buildDetailItemMoneda(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              //SizedBox(width: 10),
              // Expanded(
              //   child: GestureDetector(
              //     //onTap: () => _showSingleDialogMotivo(),
              //     onTap: () => _showSingleDialogItems(4),
              //     child: Text(
              //       selectedMoneda,
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 16.0,
              //       ),
              //       textAlign: TextAlign.right,
              //     ),
              //   ),
              // ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showSingleDialogItems(4),
                        child: Text(
                          selectedMoneda,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 80,
                      child: TextFormField(
                        controller: _monedaController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.right,
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(),
                        // ),
                        inputFormatters: [
                          LimitDecimalTextInputFormatter(2),
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          // Capturar el valor del campo de texto
                          _monedaValue = value;
                        },
                      ),
                    ),
                  ],
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

  void _showSingleDialogMotivo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //backgroundColor: Colors.transparent,
          //elevation: 0.0,
          // Title can be added if desired
          title: Text('Seleccione Motivo'),
          children: [
            SimpleDialogOption(
              child: Text('Por precio'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailMotivo =
                      'Por precio'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Por licitación'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailMotivo =
                      'Por licitación'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('SobreStock'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailMotivo =
                      'SobreStock'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Abastecimiento por otras entidades'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailMotivo =
                      'Abastecimiento por otras entidades'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('No pasa validación muestra'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailMotivo =
                      'No pasa validación muestra'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Por relación logística'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailMotivo =
                      'Por relación logística'; // Update detail here (if needed)
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Por presentar cotización fuera de fecha'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedDetailMotivo =
                      'Por presentar cotización fuera de fecha'; // Update detail here (if needed)
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _listview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2),
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
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 320,
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
                              final monto =
                                  double.parse(item['monto'].toString());
                              bool isChecked;
                              if (widget.mode == "E") {
                                isChecked = checkedItemCodigos
                                    .contains(item['itemCodigo']);
                              } else {
                                isChecked =
                                    item['isChecked'].toString() == 'true'
                                        ? true
                                        : false;
                              }
                              return CheckboxListTile(
                                title: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['descripcion'].toString(),
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
                                      /*
                                      Text(
                                        'Adj : ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13.0),
                                      ),
                                      Text('0.00',
                                          style: TextStyle(fontSize: 13.0)),
                                          */
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        'Pend : ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13.0),
                                      ),
                                      Text(
                                          NumberFormat('#,###.00')
                                              .format(monto),
                                          style: TextStyle(fontSize: 13.0)),
                                    ],
                                  ),
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
                                value: isChecked,
                                //enabled: !(_isSpecificMotivoSelected &&
                                //index != _selectedProductIndex),
                                //value: index,
                                onChanged: _isSpecificMotivoSelected
                                    ? (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            // Deseleccionar todos los productos
                                            for (var i = 0;
                                                i < _detalleProductos.length;
                                                i++) {
                                              _detalleProductos[i]
                                                  ['isChecked'] = 'false';
                                              myDispatch.remove(
                                                  _detalleProductos[i]
                                                          ['itemCodigo']
                                                      .toString());
                                            }
                                            // Seleccionar el producto actual
                                            _detalleProductos[index]
                                                ['isChecked'] = 'true';
                                            myDispatch.add(
                                                _detalleProductos[index]
                                                        ['itemCodigo']
                                                    .toString());
                                            _selectedProductIndex = index;
                                          } else {
                                            // Deseleccionar el producto actual
                                            _detalleProductos[index]
                                                ['isChecked'] = 'false';
                                            myDispatch.remove(
                                                _detalleProductos[index]
                                                        ['itemCodigo']
                                                    .toString());
                                            _selectedProductIndex = -1;
                                          }
                                          print('Check Value: $myDispatch');
                                        });
                                      }
                                    : (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                          if (value == true) {
                                            _detalleProductos[index]
                                                ['isChecked'] = 'true';
                                            myDispatch.add(
                                                _detalleProductos[index]
                                                        ['itemCodigo']
                                                    .toString());
                                          } else {
                                            _detalleProductos[index]
                                                ['isChecked'] = 'false';
                                            myDispatch.remove(
                                                _detalleProductos[index]
                                                        ['itemCodigo']
                                                    .toString());
                                          }
                                          print('Check Value: $myDispatch');
                                        });
                                      },
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

class LimitDecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  LimitDecimalTextInputFormatter(this.decimalRange)
      : assert(decimalRange != null);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains(".")) {
      final parts = newValue.text.split(".");
      if (parts[1].length > decimalRange) {
        return oldValue;
      }
    }
    return newValue;
  }
}

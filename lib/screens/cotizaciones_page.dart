import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:unilene_app/screens/detail_comision_page.dart';
import 'package:unilene_app/screens/detail_cotizaciones.dart';
import 'package:unilene_app/screens/dialog_cotizacion.dart';
import 'package:unilene_app/services/service_comision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unilene_app/services/service_cotizacion.dart';
import 'package:unilene_app/services/service_totales.dart';
import 'package:unilene_app/services/service_usuario.dart';
import 'package:unilene_app/util/color_constant.dart';
import 'chart.dart';

class MyCotizacionPage extends StatefulWidget {
  //const MyComisionPage({Key? key}) : super(key: key);

  @override
  _MyCotizacionPageState createState() => _MyCotizacionPageState();
}

class _MyCotizacionPageState extends State<MyCotizacionPage> {
  Timer? _timer;
  final TextEditingController _controller = TextEditingController();
  //set _comision(List<Map<String, String>> _comision) {}
  List<Map<String, String>> _cotizaciones = [];
  List<Map<String, String>> _cotizacionesSinGestion = [];
  Map<String, dynamic> _datosUsuario = {};

  final _scrollController = ScrollController();
  bool _showGraphic = true;

  int strOrden = 1;
  int _periodo = 0;
  String vendedor = "";

  void _showPopupMenu(BuildContext context) async {
    //int strOrden = 1;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate the bottom-center position for the menu
    final bottomCenter = Offset(screenSize.width / 2, screenSize.height);

    // Calculate the desired menu size
    final menuSize = Size(screenSize.width * 0.9, 200.0);

    // Create a Rect for the menu's position, ensuring correct types
    final menuPositionRect = Rect.fromCenter(
      center: bottomCenter,
      width: menuSize.width,
      height: menuSize.height,
    );

    final selectedValue = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        // Use the Rect created for the menu's position
        menuPositionRect,
        // Use an Rect covering the entire screen for alignment
        Rect.fromLTRB(0, 0, screenSize.width, screenSize.height),
      ),
      items: [
        //PopupMenuDivider(),
        // Create a Text widget for the title
        PopupMenuItem(
          enabled: false, // Disable selection for the title
          child: Text(
            'ORDENAR POR : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.monetization_on,
                size: 16.0,
              ),
              SizedBox(width: 4.0),
              Text(
                'Por monto',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          // Asignar un valor único a cada opción
          value: 1,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.expand_more,
                size: 16.0,
              ),
              SizedBox(width: 4.0),
              Text(
                'Por vencimiento',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          // Asignar un valor único a cada opción
          value: 2,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.safety_check,
                size: 16.0,
              ),
              SizedBox(width: 4.0),
              Text(
                'Por estado',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          // Asignar un valor único a cada opción
          value: 3,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.expand_less,
                size: 16.0,
              ),
              SizedBox(width: 4.0),
              Text(
                'Por Fecha Emisión',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          // Asignar un valor único a cada opción
          value: 4,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.star_half,
                size: 16.0,
              ),
              SizedBox(width: 4.0),
              Text(
                'Por prioridad CG',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          // Asignar un valor único a cada opción
          value: 5,
        ),
      ],
      initialValue: 1,
      elevation: 20.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
    );
    if (selectedValue != null) {
      setState(() {
        strOrden = selectedValue;
      });
      print('El valor seleccionado es: $selectedValue');
      filterCotizacion(vendedor, "", 0, 0, "", "", strOrden, 1);
      filterCotizacion(vendedor, "", 0, 0, "", "", strOrden, 2);
    }
  }

  //final dataMap = Map<String, double>;
  Map<String, double> dataMap = {};
  Map<String, double> dataMapDatos = {};
  double total = 0;

  final colorList = <Color>[
    Color.fromRGBO(12, 44, 79, 50),
    Color.fromRGBO(1, 121, 255, 50),
    Color.fromRGBO(10, 85, 169, 50)
    //Colors.blueAccent,
  ];

  Future<int> getPeriodo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _periodo = prefs.getInt('periodo') ?? 0;
    });
    return _periodo;
  }

  @override
  void initState() {
    super.initState();

    // setState(() {
    //   getPeriodo().then((value) {
    //     setState(() {
    //       _periodo = value;
    //       print('_session periodo: $_periodo');
    //     });
    //   });
    // });

    BackendUsuario.getUsuario().then((value) => setState(() {
          _datosUsuario = value;
          print('_datos usuario: $_datosUsuario');
          vendedor = _datosUsuario['codigo'].toString();
          print('_datos _vendedor: $vendedor');
          filterCotizacion(vendedor, "", 0, 0, "", "", strOrden, 1);
          filterCotizacion(vendedor, "", 0, 0, "", "", strOrden, 2);
        }));

    //print('_datos usuario: $_datosUsuario['codigo']);
    //final year = DateTime.now().year;
    //final monthStr = _currentMonth.toString().padLeft(2, '0');
    //final dateStr = '$year$monthStr';
    //_comision = BackendComision.getComision('202305', 1);

    /*
    BackendCotizacion.getCotizaciones(123, 1).then((value) => setState(() {
          _cotizaciones = value;
        }));
    BackendCotizacion.getCotizaciones(123, 2).then((value) => setState(() {
          _cotizacionesSinGestion = value;
        }));
        */

    //getSession();
  }

  void filterCotizacion(
      String vendedor,
      String descripcion,
      int periodo,
      int cliente,
      String agrupador,
      String subAgrupador,
      int orden,
      int opcion) {
    //print('Imprime valor de linea $_linea');
    //print('Imprime valor de Pre-Filtro $pre');
    //print('Imprime valor de stock $stock');
    print('Imprime valor de descripcion ' + _controller.text);
    if (periodo == '') {
      periodo = 0;
    }
    if (cliente == '') {
      cliente = 0;
    }
    if (orden == '') {
      orden = 1;
    }
    //print('Imprime valor de cliente $cliente');
    //print('Imprime valor de marca $marca');
    //super.initState();
    //setState(() {
    if (opcion == 1) {
      BackendCotizacion.getCotizaciones(vendedor, descripcion, periodo, cliente,
              agrupador, subAgrupador, orden, opcion)
          .then((value) => setState(() {
                _cotizaciones = value;
              }));
    } else {
      BackendCotizacion.getCotizaciones(vendedor, descripcion, periodo, cliente,
              agrupador, subAgrupador, orden, opcion)
          .then((value) => setState(() {
                _cotizacionesSinGestion = value;
              }));
    }
    //});
  }

  void _showDialogCotizacion() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //String filterValue = '';
          //return MyDialog();
          return MyDialogCotizacion(
            onProcess: (cliente, agrupador, subagrupador, periodo) {
              Navigator.of(context).pop();

              filterCotizacion(vendedor, "", 0, 0, "", "", strOrden, 1);

              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //List<Map<String, String>> comision;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotizaciones'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        //prefixIcon: Icon(Icons.search),

                        /*
                      prefixIcon: IconButton(
                        icon: Icon(_type == false
                            ? Icons.search
                            : Icons.playlist_play),
                        onPressed: () {
                          //_setSessionCliente('');
                          //_typeAheadControllerCliente.text = '';                          
                        },
                      ),
                      */
                        contentPadding: EdgeInsets.all(5.0),
                      ),
                      onChanged: (value) {
                        //_controller.text = value;
                        // getStock().then((value) {
                        //   setState(() {
                        //     _stock = value;
                        //     print('_session Stock: $_stock');
                        //   });
                        // });
                        if (_timer?.isActive ?? false) _timer?.cancel();
                        _timer = Timer(const Duration(milliseconds: 500), () {
                          setState(() {
                            // getCodAgrupador().then((value) {
                            //   setState(() {
                            //     _agrupador = value;
                            //     print('_session Agrupador: $_agrupador');
                            //   });
                            // });
                            if (value.length >= 2) {
                              filterCotizacion(vendedor, _controller.text, 0, 0,
                                  "", "", 1, 1);
                              filterCotizacion(vendedor, _controller.text, 0, 0,
                                  "", "", 1, 2);
                            } else {
                              filterCotizacion(
                                  vendedor, "", 0, 0, "", "", 1, 1);
                              filterCotizacion(
                                  vendedor, "", 0, 0, "", "", 1, 2);
                            }
                            /*
                        if (value.length >= 4) {
                          _fetchProducts('', '0', 'T', 'C', '',
                                  _controller.text, '0', '1')
                              .then((value) => _products = value);
                        } else {
                          _fetchProducts('', '0', 'T', 'C', '', '', '0', '1')
                              .then((value) => _products = value);
                        }
                        */
                          });
                        });
                      }),
                ),
                // Expanded(
                //   flex: 1,
                //   child: IconButton(
                //     color: ColorConstants.primaryColor,
                //     icon: Icon(Icons.filter_list_sharp),
                //     //onPressed: (null),
                //     onPressed: _showDialogCotizacion,
                //   ),
                // ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: ColorConstants.primaryColor,
                    icon: Icon(Icons.outbox_rounded),
                    onPressed: () {
                      // Mostrar el PopupMenuButton
                      _showPopupMenu(context);
                    },
                    /*onPressed: () {
                      setState(() {
                        /*
                        _fetchProducts(
                                '0', 'P', 'R', _controller.text, '0', '1')
                            .then((value) => _products = value);
                        */
                        //showPopup(context);
                        /*showDialog(
                            context: context, builder: (context) => MyDialog());*/
                            
                      });
                    },*/
                  ),
                ),
              ],
            ),
          ),
          /*
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,          
              children: [
                */
          /* -- Este es el arreglo de botones --
          RawScrollbar(
            controller: _scrollController,
            thickness: 8,
            radius: Radius.circular(5),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 35,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final month = index + 1 + 5;
                    final isSelected = month == _currentMonth;
                    final buttonColor = isSelected
                        ? Colors.blue
                        : Color.fromARGB(236, 220, 220, 230);

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      //width: 120,
                      //height: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          final year = DateTime.now().year;
                          final monthStr = month.toString().padLeft(2, '0');
                          final dateStr = '$year$monthStr';
                          print(dateStr); // YYYYMM format
                          setState(() {
                            _currentMonth = month;
                            BackendComision.getComision(dateStr, 1)
                                .then((value) => setState(() {
                                      _comisionCancelados = value;
                                    }));
                            BackendComision.getComision(dateStr, 2)
                                .then((value) => setState(() {
                                      _comisionPorCobrar = value;
                                    }));
                            BackendComision.getComision(dateStr, 3)
                                .then((value) => setState(() {
                                      _comisionCriticos = value;
                                    }));
                            BackendTotales.getTotales(dateStr)
                                .then((value) => setState(() {
                                      dataMap = value;
                                    }));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          _getMonthName(month),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          */

          /*
                ElevatedButton(
                  onPressed: () {
                    print('Button 1 pressed');
                  },
                  child: Text(
                    '${DateTime.now().year} - ${DateTime.now().month - 2}',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  //background: Colors.white,
                  //padding: EdgeInsets.all(10),
                ),
                */

          //SizedBox(height: 5),
          /*
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                print('View graphic button pressed');
              },
              child: Text('View graphic'),
              //color: Colors.blue,
              //textColor: Colors.white,
              //padding: EdgeInsets.all(10),
            ),
          ),
          */
          //SizedBox(height: 20),
          //SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text('**'),
                Icon(Icons.monetization_on, color: Colors.green),
                SizedBox(width: 8),
                Text('Adj. Parcial'),
              ],
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Oportunidad'),
                      Tab(text: 'Sin Gestión'),
                      //Tab(text: 'Críticos'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView.builder(
                            itemCount: _cotizaciones.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _cotizaciones[index];
                              String porcentaje =
                                  double.parse(item['porcentajeTotal'] ?? '')
                                      .toStringAsFixed(2)
                                      .toString();
                              double montoTotal =
                                  double.parse(item['montoTotal'].toString());
                              double dias =
                                  double.parse(item['diasVencido'].toString());
                              String dia = item['fechaDocumento']
                                  .toString()
                                  .substring(0, 2);
                              String mes = item['fechaDocumento']
                                  .toString()
                                  .substring(3, 5);
                              String formattedDate = dia + "." + mes;

                              Color textColor = Colors.purple;
                              if (dias < 0) {
                                textColor = Colors.purple; // lead colored
                              } else if (dias >= 0 && dias <= 3) {
                                textColor = Colors.red;
                              } else if (dias >= 4 && dias <= 7) {
                                textColor = Colors.yellowAccent;
                              } else if (dias > 7) {
                                textColor = Colors.lightBlue;
                              }

                              return GestureDetector(
                                onTap: () {
                                  /*
                                  final message =
                                      'You selected item ${item['documento'].toString()}';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                      */

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailCotizacion(
                                                  item: item['cliente']
                                                      .toString(),
                                                  numeroDocumento:
                                                      item['numeroDocumento']
                                                          .toString(),
                                                  estado:
                                                      item['estado'].toString(),
                                                  monto: double.parse(
                                                      item['montoTotal']
                                                          .toString()),
                                                  fechaGestion:
                                                      item['fechaUltimaGestion']
                                                          .toString(),
                                                  preparadoPor:
                                                      item['preparadoPor']
                                                          .toString())));
                                },
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: formattedDate + ' | ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item['cliente'].toString(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Monto s/. ' +
                                            NumberFormat('#,###.00')
                                                .format(montoTotal),
                                      ),
                                      //SizedBox(height: 4),
                                      // Text(
                                      //   item['diasVencido'].toString(),
                                      //   style: TextStyle(
                                      //       fontSize: 13.0,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: textColor),
                                      // ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        porcentaje + '%',
                                      ),
                                      //SizedBox(height: 4),
                                      Visibility(
                                        visible:
                                            item['diasVencido'].toString() ==
                                                "1",
                                        child: Icon(Icons.monetization_on,
                                            color: Colors.green),
                                      ),
                                      //Text(item['estadoGestion'].toString()),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ListView.builder(
                            itemCount: _cotizacionesSinGestion.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _cotizacionesSinGestion[index];
                              double dias =
                                  double.parse(item['diasVencido'].toString());
                              double montoTotal =
                                  double.parse(item['montoTotal'].toString());
                              String dia = item['fechaDocumento']
                                  .toString()
                                  .substring(0, 2);
                              String mes = item['fechaDocumento']
                                  .toString()
                                  .substring(3, 5);
                              String formattedDate = dia + "." + mes;

                              Color textColor = Colors.purple;
                              if (dias < 0) {
                                textColor = Colors.purple; // lead colored
                              } else if (dias >= 0 && dias <= 3) {
                                textColor = Colors.red;
                              } else if (dias >= 4 && dias <= 7) {
                                textColor = Colors.yellowAccent;
                              } else if (dias > 7) {
                                textColor = Colors.lightBlue;
                              }
                              return GestureDetector(
                                onTap: () {
                                  /*
                                  final message =
                                      'You selected item ${item['documento'].toString()}';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                      */

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailCotizacion(
                                                  item: item['cliente']
                                                      .toString(),
                                                  numeroDocumento:
                                                      item['numeroDocumento']
                                                          .toString(),
                                                  estado:
                                                      item['estado'].toString(),
                                                  monto: double.parse(
                                                      item['montoTotal']
                                                          .toString()),
                                                  fechaGestion:
                                                      item['fechaUltimaGestion']
                                                          .toString(),
                                                  preparadoPor:
                                                      item['preparadoPor']
                                                          .toString())));
                                },
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: formattedDate + ' | ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item['cliente'].toString(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Monto s/. ' +
                                            NumberFormat('#,###.00')
                                                .format(montoTotal),
                                      ),
                                      //SizedBox(height: 4),
                                      // Text(
                                      //   item['diasVencido'].toString(),
                                      //   style: TextStyle(
                                      //       fontSize: 13.0,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: textColor),
                                      // ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Visibility(
                                        visible:
                                            item['diasVencido'].toString() ==
                                                "1",
                                        child: Icon(Icons.monetization_on,
                                            color: Colors.green),
                                      ),
                                      /*
                                      Text(
                                        'SIN GESTIÓN',
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      */
                                    ],
                                  ),
                                ),
                              );
                            }),
                        /*
                        ListView.builder(
                            itemCount: _comisionCriticos.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _comisionCriticos[index];
                              return GestureDetector(
                                onTap: () {
                                  final message =
                                      'You selected item ${item['documento'].toString()}';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailComision(
                                              item: item['documento']
                                                  .toString())));
                                },
                                child: ListTile(
                                  title: Text(item['cliente'].toString(),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                  subtitle: Text(DateFormat('dd/MM/yyyy')
                                          .format(DateTime.parse(
                                              item['fechaDocumento']
                                                  .toString())) +
                                      ' | ' +
                                      item['documento'].toString()),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'S/.' + item['comision'].toString(),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                          item['diferenciaDias'].toString() +
                                              ' días',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            color: int.parse(item[
                                                            'diferenciaDias']
                                                        .toString()) >
                                                    0
                                                ? Colors.red
                                                : int.parse(item[
                                                                'diferenciaDias']
                                                            .toString()) ==
                                                        0
                                                    ? const Color.fromARGB(
                                                        255, 216, 204, 98)
                                                    : Colors.green,
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            */
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

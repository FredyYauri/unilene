import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unilene_app/model/ModelView.dart';
import 'package:unilene_app/services/service_totales_presupuesto.dart';

import '../services/service_anual_vendedor_cliente.dart';
import '../services/service_anual_vendedor_producto.dart';
import '../services/service_dia_vendedor.dart';
import '../services/service_mes_vendedor_cliente.dart';
import '../services/service_mes_vendedor_producto.dart';
import 'detail_presupuesto_page.dart';

class MyPresupuestoPage extends StatefulWidget {
  @override
  _MyPresupuestoPageState createState() => _MyPresupuestoPageState();
}

class _MyPresupuestoPageState extends State<MyPresupuestoPage> {
  List<Map<String, String>> _presupuestodia = [];
  List<Map<String, String>> _presupuestoMensualProducto = [];
  List<Map<String, String>> _presupuestoMensualCliente = [];
  List<Map<String, String>> _presupuestoAnualProducto = [];
  List<Map<String, String>> _presupuestoAnualCliente = [];

  Map<String, dynamic> _datosTotales = {};
  double _avanceDia = 0;
  double _avanceMes = 0;
  double _avanceAnual = 0;

  Color textColor1 = Colors.grey;
  Color textColor2 = Colors.grey;
  Color textColor3 = Colors.grey;

  final PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    BackendVendedor.getVendedorDia().then((value) => setState(() {
          _presupuestodia = value;
        }));
    BackendVendedorProductoMes.getProductoMes().then((value) => setState(() {
          _presupuestoMensualProducto = value;
        }));
    BackendVendedorClienteMes.getClienteMes().then((value) => setState(() {
          _presupuestoMensualCliente = value;
        }));
    BackendVendedorProductoAnual.getProductoAnual()
        .then((value) => setState(() {
              _presupuestoAnualProducto = value;
            }));
    BackendVendedorClienteAnual.getClienteAnual().then((value) => setState(() {
          _presupuestoAnualCliente = value;
        }));
    BackendTotalesPresupuesto.getTotalesPresupuesto()
        .then((value) => setState(() {
              _datosTotales = value;
              //valores del ppto
              _avanceDia = _datosTotales['avanceDia'];
              _avanceMes = _datosTotales['avanceMes'];
              _avanceAnual = _datosTotales['avanceAnual'];
              //color

              //Color textColor1 = Colors.grey;
              if (_avanceDia >= 0 && _avanceDia <= 0.99) {
                textColor1 = Colors.grey; // lead colored
              } else if (_avanceDia >= 1 && _avanceDia <= 89.9) {
                textColor1 = Colors.red;
              } else if (_avanceDia >= 90 && _avanceDia <= 104) {
                textColor1 = Colors.white;
              } else if (_avanceDia > 104.1) {
                textColor1 = Color.fromRGBO(66, 250, 57, 1.0);
              }

              //Color textColor2 = Colors.grey;
              if (_avanceMes >= 0 && _avanceMes <= 0.99) {
                textColor2 = Colors.grey; // lead colored
              } else if (_avanceMes >= 1 && _avanceMes <= 89.9) {
                textColor2 = Colors.red;
              } else if (_avanceMes >= 90 && _avanceMes <= 104) {
                textColor2 = Colors.white;
              } else if (_avanceMes > 104.1) {
                textColor2 = Color.fromRGBO(66, 250, 57, 1.0);
              }

              //Color textColor2 = Colors.grey;
              if (_avanceAnual >= 0 && _avanceAnual <= 0.99) {
                textColor3 = Colors.grey; // lead colored
              } else if (_avanceAnual >= 1 && _avanceAnual <= 89.9) {
                textColor3 = Colors.red;
              } else if (_avanceAnual >= 90 && _avanceAnual <= 104) {
                textColor3 = Colors.white;
              } else if (_avanceAnual > 104.1) {
                textColor3 = Color.fromRGBO(66, 250, 57, 1.0);
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageView Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Mi Presupuesto')),
        body: PageView(
          controller: controller,
          children: [
            //Center(child: Text('Page 1')),
            Column(children: [
              Container(
                height: MediaQuery.of(context).size.height / 4.0,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Venta',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        NumberFormat('#,###.00')
                            .format(_datosTotales['ventasDia'] ?? 0.00),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Presupuesto al día',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        NumberFormat('#,###.00')
                            .format(_datosTotales['presupuestoDia'] ?? 0.0),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        NumberFormat('#,###.00')
                                .format(_datosTotales['avanceDia'] ?? 0.0) +
                            '%',
                        style: TextStyle(
                            color: textColor1,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lista de Seguimiento',
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                  child: ListView.builder(
                      itemCount: _presupuestodia.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _presupuestodia[index];
                        double ventas = double.parse(item['ventas'].toString());
                        double presupuesto =
                            double.parse(item['presupuesto'].toString());
                        double avances =
                            double.parse(item['avances'].toString());

                        Color textColor = Colors.grey;
                        if (avances >= 0 && avances <= 0.99) {
                          textColor = Colors.grey; // lead colored
                        } else if (avances >= 1 && avances <= 89.9) {
                          textColor = Colors.red;
                        } else if (avances >= 90 && avances <= 104) {
                          textColor = Colors.blue;
                        } else if (avances > 104.1) {
                          textColor = Colors.green;
                        }
                        return GestureDetector(
                          /*
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
                                */
                          child: ListTile(
                            title: Text(
                              item['agrupador'].toString(),
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            subtitle: Text('S/.' +
                                NumberFormat('#,###.00').format(ventas)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'S/.' +
                                      NumberFormat('#,###.00')
                                          .format(presupuesto),
                                ),
                                //SizedBox(height: 4),
                                Text(
                                  //item['avances'].toString() + '%',
                                  NumberFormat('#,##0.00').format(avances) +
                                      '%',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ]),
/********** Mensual por vendedor **********/
            //Center(child: Text('Page 2')),
            Column(children: [
              Container(
                height: MediaQuery.of(context).size.height / 4.0,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Venta Mensual',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        NumberFormat('#,###.00')
                            .format(_datosTotales['ventasMes'] ?? 0.0),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Presupuesto Mensual',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        NumberFormat('#,###.00')
                            .format(_datosTotales['presupuestoMes'] ?? 0.0),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        NumberFormat('#,###.00')
                                .format(_datosTotales['avanceMes'] ?? 0.0) +
                            '%',
                        style: TextStyle(
                            color: textColor2,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lista de Seguimiento',
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Producto'),
                          Tab(text: 'Cliente'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView.builder(
                                itemCount: _presupuestoMensualProducto.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item =
                                      _presupuestoMensualProducto[index];
                                  double ventas =
                                      double.parse(item['ventas'].toString());
                                  double presupuesto = double.parse(
                                      item['presupuesto'].toString());
                                  double avances =
                                      double.parse(item['avances'].toString());
                                  Color textColor = Colors.grey;
                                  if (avances >= 0 && avances <= 0.99) {
                                    textColor = Colors.grey; // lead colored
                                  } else if (avances >= 1 && avances <= 89.9) {
                                    textColor = Colors.red;
                                  } else if (avances >= 90 && avances <= 104) {
                                    textColor = Colors.blue;
                                  } else if (avances > 104.1) {
                                    textColor = Colors.green;
                                  }
                                  return GestureDetector(
                                    /*
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
                                */
                                    child: ListTile(
                                      title: Text(
                                        item['agrupador'].toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      subtitle: Text('S/.' +
                                          NumberFormat('#,###.00')
                                              .format(ventas)),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'S/.' +
                                                NumberFormat('#,###.00')
                                                    .format(presupuesto),
                                          ),
                                          //SizedBox(height: 4),
                                          Text(
                                            NumberFormat('#,##0.00')
                                                    .format(avances) +
                                                '%',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            //Text('hola'),
                            //Segun Tab
                            ListView.builder(
                                itemCount: _presupuestoMensualCliente.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item =
                                      _presupuestoMensualCliente[index];
                                  double ventas =
                                      double.parse(item['ventas'].toString());
                                  double presupuesto = double.parse(
                                      item['presupuesto'].toString());
                                  double avances =
                                      double.parse(item['avances'].toString());
                                  Color textColor = Colors.grey;
                                  if (avances >= 0 && avances <= 0.99) {
                                    textColor = Colors.grey; // lead colored
                                  } else if (avances >= 1 && avances <= 89.9) {
                                    textColor = Colors.red;
                                  } else if (avances >= 90 && avances <= 104) {
                                    textColor = Colors.blue;
                                  } else if (avances > 104.1) {
                                    textColor = Colors.green;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      /*
                                      final message =
                                          'You selected item ${item['tipoCliente'].toString()}';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(message)));
                                              */

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailPresupuestoPage(
                                                      opcion: 1,
                                                      item: item['tipoCliente']
                                                          .toString())));
                                    },
                                    child: ListTile(
                                      title: Text(
                                        item['tipoCliente'].toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      subtitle: Text('S/.' +
                                          NumberFormat('#,###.00')
                                              .format(ventas)),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'S/.' +
                                                NumberFormat('#,###.00')
                                                    .format(presupuesto),
                                          ),
                                          //SizedBox(height: 4),
                                          Text(
                                            NumberFormat('#,##0.00')
                                                    .format(avances) +
                                                '%',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),

/********** Anual por vendedor **********/
            //Center(child: Text('Page 3')),

            Column(children: [
              Container(
                height: MediaQuery.of(context).size.height / 4.0,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Venta Acumulada',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        NumberFormat('#,###.00')
                            .format(_datosTotales['ventasAnual'] ?? 0.0),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Presupuesto Acumulado',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        NumberFormat('#,###.00')
                            .format(_datosTotales['presupuestoAnual'] ?? 0.0),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        NumberFormat('#,###.00')
                                .format(_datosTotales['avanceAnual'] ?? 0.0) +
                            '%',
                        style: TextStyle(
                            color: textColor3,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lista de Seguimiento',
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Producto'),
                          Tab(text: 'Cliente'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView.builder(
                                itemCount: _presupuestoAnualProducto.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = _presupuestoAnualProducto[index];
                                  double ventas =
                                      double.parse(item['ventas'].toString());
                                  double presupuesto = double.parse(
                                      item['presupuesto'].toString());
                                  double avances =
                                      double.parse(item['avances'].toString());
                                  Color textColor = Colors.grey;
                                  if (avances >= 0 && avances <= 0.99) {
                                    textColor = Colors.grey; // lead colored
                                  } else if (avances >= 1 && avances <= 89.9) {
                                    textColor = Colors.red;
                                  } else if (avances >= 90 && avances <= 104) {
                                    textColor = Colors.blue;
                                  } else if (avances > 104.1) {
                                    textColor = Colors.green;
                                  }
                                  return GestureDetector(
                                    /*
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
                                */
                                    child: ListTile(
                                      title: Text(
                                        item['agrupador'].toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      subtitle: Text('S/.' +
                                          NumberFormat('#,###.00')
                                              .format(ventas)),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'S/.' +
                                                NumberFormat('#,###.00')
                                                    .format(presupuesto),
                                          ),
                                          //SizedBox(height: 4),
                                          Text(
                                            NumberFormat('#,##0.00')
                                                    .format(avances) +
                                                '%',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            //Text('hola'),
                            //Segun Tab
                            ListView.builder(
                                itemCount: _presupuestoAnualCliente.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = _presupuestoAnualCliente[index];
                                  double ventas =
                                      double.parse(item['ventas'].toString());
                                  double presupuesto = double.parse(
                                      item['presupuesto'].toString());
                                  double avances =
                                      double.parse(item['avances'].toString());
                                  Color textColor = Colors.grey;
                                  if (avances >= 0 && avances <= 0.99) {
                                    textColor = Colors.grey; // lead colored
                                  } else if (avances >= 1 && avances <= 89.9) {
                                    textColor = Colors.red;
                                  } else if (avances >= 90 && avances <= 104) {
                                    textColor = Colors.blue;
                                  } else if (avances > 104.1) {
                                    textColor = Colors.green;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      /*
                                      final message =
                                          'You selected item ${item['tipoCliente'].toString()}';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(message)));
                                              */

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailPresupuestoPage(
                                                      opcion: 2,
                                                      item: item['tipoCliente']
                                                          .toString())));
                                    },
                                    child: ListTile(
                                      title: Text(
                                        item['tipoCliente'].toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      subtitle: Text('S/.' +
                                          NumberFormat('#,###.00')
                                              .format(ventas)),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'S/.' +
                                                NumberFormat('#,###.00')
                                                    .format(presupuesto),
                                          ),
                                          //SizedBox(height: 4),
                                          Text(
                                            NumberFormat('#,##0.00')
                                                    .format(avances) +
                                                '%',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}

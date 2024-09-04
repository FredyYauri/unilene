import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:unilene_app/screens/detail_comision_page.dart';
import 'package:unilene_app/services/service_comision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unilene_app/services/service_totales.dart';
import 'chart.dart';

class MyComisionPage extends StatefulWidget {
  //const MyComisionPage({Key? key}) : super(key: key);

  @override
  _MyComisionPageState createState() => _MyComisionPageState();
}

class _MyComisionPageState extends State<MyComisionPage> {
  //set _comision(List<Map<String, String>> _comision) {}
  List<Map<String, String>> _comisionCancelados = [];
  List<Map<String, String>> _comisionPorCobrar = [];
  List<Map<String, String>> _comisionCriticos = [];

  final _scrollController = ScrollController();
  int _currentMonth = DateTime.now().month;
  bool _showGraphic = true;

  //final dataMap = Map<String, double>;
  Map<String, double> dataMap = {};
  Map<String, double> dataMapDatos = {};
  double total = 0;

  String _comisionGanado = '';
  String _creditoCobrado = '';
  String _creditoPendiente = '';

  final colorList = <Color>[
    Color.fromRGBO(12, 44, 79, 50),
    Color.fromRGBO(1, 121, 255, 50),
    Color.fromRGBO(10, 85, 169, 50)
    //Colors.blueAccent,
  ];

/*
  void getSession() {
    setState(() {
      getComisionGanado().then((value) {
        setState(() {
          _comisionGanado = value.toString();
          print('session _comisionGanado: $_comisionGanado');
        });
      });

      getCreditoCobrado().then((value) {
        setState(() {
          _creditoCobrado = value.toString();
          print('session _creditoCobrado: $_creditoCobrado');
        });
      });

      getCreditoPendiente().then((value) {
        setState(() {
          _creditoPendiente = value.toString();
          print('session _creditoPendiente: $_creditoPendiente');
        });

        dataMap = <String, double>{
          "Cred. Cobrado": double.parse(_creditoCobrado),
          "Contado": 0,
          "Cred. por cobrar": double.parse(_creditoPendiente),
        };
      });
    });
  }
*/
  @override
  void initState() {
    super.initState();
    final year = DateTime.now().year;
    final monthStr = _currentMonth.toString().padLeft(2, '0');
    final dateStr = '$year$monthStr';
    //_comision = BackendComision.getComision('202305', 1);
    BackendComision.getComision(dateStr, 1).then((value) => setState(() {
          _comisionCancelados = value;
        }));
    BackendComision.getComision(dateStr, 2).then((value) => setState(() {
          _comisionPorCobrar = value;
        }));
    BackendComision.getComision(dateStr, 3).then((value) => setState(() {
          _comisionCriticos = value;
        }));
    BackendTotales.getTotales(dateStr, "0").then((value) => setState(() {
          dataMap = value;
          total = double.parse(dataMap['Comision Ganado'].toString()) +
              double.parse(dataMap['Comision Pendiente'].toString());
        }));
    BackendTotales.getTotales(dateStr, "1").then((value) => setState(() {
          dataMapDatos = value;
        }));

    //getSession();
  }

  @override
  Widget build(BuildContext context) {
    //List<Map<String, String>> comision;
    return Scaffold(
      appBar: AppBar(
        title: Text('Comisiones del Mes'),
      ),
      body: Column(
        children: [
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
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showGraphic = !_showGraphic;
                    });
                  },
                  child: Row(
                    children: [
                      Text('Ver Estadistica'),
                      Icon(_showGraphic
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _showGraphic,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(
                        child: PieChart(
                          totalValue: total,
                          dataMap: dataMap,
                          animationDuration: Duration(milliseconds: 1000),
                          initialAngleInDegree: 10,
                          ringStrokeWidth: 20,
                          chartRadius: MediaQuery.of(context).size.width / 2.0,
                          centerText: 'Ganado \n' +
                              NumberFormat('#,###.00')
                                  .format(dataMap['Comision Ganado'] ?? 0.0) +
                              '\n Pendiente \n ' +
                              NumberFormat('#,###.00')
                                  .format(dataMap['Comision Pendiente'] ?? 0.0),
                          chartType: ChartType.ring,
                          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                          colorList: colorList,
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: false,
                            showChartValues: false,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 2,
                            chartValueStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cred. Cobrado',
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            NumberFormat('#,###.00').format(
                                dataMapDatos['Facturas Cobradas'] ?? 0.0),
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    /*
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Contado',
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '0.00',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    */
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cred. por cobrar',
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            //var formatter = NumberFormat('#,###.00');
                            NumberFormat('#,###.00').format(
                                dataMapDatos['Facturas Pendientes'] ?? 0.0),
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
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
                      Tab(text: 'Fact. Cobradas'),
                      Tab(text: 'Fact. Pendientes'),
                      //Tab(text: 'Críticos'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView.builder(
                            itemCount: _comisionCancelados.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _comisionCancelados[index];
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
                                          builder: (context) => DetailComision(
                                              item: item['documento']
                                                  .toString())));
                                },
                                child: ListTile(
                                  title: Text(
                                    item['cliente'].toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
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
                                      /*
                                      Text(
                                          item['diferenciaDias'].toString() +
                                              ' días',
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: int.parse(
                                                          item['diferenciaDias']
                                                              .toString()) >=
                                                      30
                                                  ? Colors.red
                                                  : const Color.fromARGB(
                                                      255, 216, 204, 98))),
                                                      */
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ListView.builder(
                            itemCount: _comisionPorCobrar.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _comisionPorCobrar[index];
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
                                            color: int.parse(
                                                        item['diferenciaDias']
                                                            .toString()) >=
                                                    30
                                                ? Colors.red
                                                : const Color.fromARGB(
                                                    255, 216, 204, 98),
                                          )),
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

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Setiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
      default:
        return '';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unilene_app/screens/detail_page.dart';
import 'package:unilene_app/screens/dialog_page.dart';
import 'dart:convert';
import 'package:unilene_app/util/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/service_detalle_presupuesto_mes.dart';

class DetailPresupuestoPage extends StatefulWidget {
  final int opcion;
  final String item;
  const DetailPresupuestoPage(
      {Key? key, required this.opcion, required this.item})
      : super(key: key);

  @override
  _DetailPresupuestoPageState createState() => _DetailPresupuestoPageState();
}

class _DetailPresupuestoPageState extends State<DetailPresupuestoPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _detallePresupuestoMes = [];

  @override
  void initState() {
    super.initState();
    BackendDetallePresupuestoMes.getPresupuestoMes(
            widget.opcion, widget.item, '')
        .then((value) => setState(() {
              _detallePresupuestoMes = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.opcion == 1
            ? 'Detalle de Clientes por Mes'
            : 'Detalle de Clientes por Año'),
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
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.all(5.0),
                    ),
                    onChanged: (value) {
                      //_controller.text = value;
                      setState(() {
                        //llamar al metodo de busqueda
                        BackendDetallePresupuestoMes.getPresupuestoMes(
                                widget.opcion, widget.item, _controller.text)
                            .then((value) => setState(() {
                                  _detallePresupuestoMes = value;
                                }));
                      });
                    },
                  ),
                ),
                /*
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: ColorConstants.primaryColor,
                    icon: Icon(Icons.filter_list_sharp),
                    onPressed: _showDialog,
                    
                  ),
                ),
                */
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
                itemCount: _detallePresupuestoMes.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _detallePresupuestoMes[index];
                  double presupuesto =
                      double.parse(item['presupuesto'].toString());
                  double ventas = double.parse(item['ventas'].toString());
                  double avances = double.parse(item['avance'].toString());

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
                        item['cliente'].toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      subtitle:
                          Text('S/.' + NumberFormat('#,##0.00').format(ventas)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'S/.' +
                                NumberFormat('#,##0.00').format(presupuesto),
                          ),
                          //SizedBox(height: 4),
                          Text(
                            NumberFormat('#,##0.00').format(avances) + '%',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          //),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unilene_app/screens/confirm_page.dart';
import 'package:unilene_app/services/service_confirmacion_despacho.dart';
import 'package:unilene_app/services/service_despacho.dart';

class DespachoPage extends StatefulWidget {
  final String barcodeValue;
  const DespachoPage({Key? key, required this.barcodeValue}) : super(key: key);

  @override
  _DespachoPageState createState() => _DespachoPageState();
}

class _DespachoPageState extends State<DespachoPage> {
  List<Map<String, String>> _detalleGuia = [];
  List<int> myDispatch = [];
  String _confirm = '';

  Map<String, int> selectedAnswer = {};

  bool isSelected(String qustion, int answerID) {
    if (selectedAnswer.containsKey(qustion) &&
        selectedAnswer[qustion] == answerID) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    BackendDespacho.getDespacho(widget.barcodeValue)
        .then((value) => setState(() {
              _detalleGuia = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle Guía  ' + widget.barcodeValue),
        actions: [
          IconButton(
            icon: Icon(Icons.checklist_rtl),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Alerta'),
                    content:
                        Text('¿Desea confirmar los despachos seleccionados?'),
                    actions: [
                      ElevatedButton(
                        child: Text('Aceptar'),
                        onPressed: () {
                          BackendConfirmarDespacho.registrarDespacho(
                                  widget.barcodeValue.toString(),
                                  myDispatch.toList())
                              .then((value) => setState(() {
                                    _confirm = value;
                                    if (_confirm == "Registrado") {
                                      /*
                                      final message =
                                          'Los despachos seleccionados fueron confirmados';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(message)));
                                              */
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmPage()),
                                        //BarCodePage()),
                                      );
                                    }
                                  }));
                          //Navigator.of(context).pop();
                          //Direccionar a ventana de confirmacion
                          /*
                          if (_confirm == "Registrado") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ConfirmPage()),
                              //BarCodePage()),
                            );
                          }
                          */
                          //Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /*
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
              ],
            ),
          ),
          */

          Expanded(
            child: _detalleGuia.isEmpty
                ? Center(
                    child: Text('No hay información para mostrar.'),
                  )
                : ListView.builder(
                    itemCount: _detalleGuia.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _detalleGuia[index];
                      double cantidad =
                          double.parse(item['cantidad'].toString());
                      bool isChecked =
                          item['isChecked'].toString() == 'true' ? true : false;

                      return CheckboxListTile(
                        title: Text(
                          item['ordenFabricacion'].toString(),
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                item['item'].toString() +
                                    ' - ' +
                                    item['descripcion'].toString(),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child:
                                        Icon(Icons.pending_actions, size: 12),
                                  ),
                                  TextSpan(
                                      text:
                                          ' Lote : ' + item['lote'].toString(),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: Colors.black54)),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child:
                                        Icon(Icons.receipt_outlined, size: 12),
                                  ),
                                  TextSpan(
                                      text: ' Documento : ' +
                                          item['documento'].toString(),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: Colors.black54)),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.shopping_cart_outlined,
                                        size: 13),
                                  ),
                                  TextSpan(
                                      text: ' Cantidad : ' +
                                          NumberFormat('#,##0.00')
                                              .format(cantidad),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          color: Colors.black54)),
                                ],
                              ),
                            ),
                            //Text('Lote : ' + item['lote'].toString()),
                            //SizedBox(height: 4),
                            //Text('Documento : ' + item['documento'].toString()),
                          ],
                        ),
                        /*
                    trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            NumberFormat('#,##0.00').format(cantidad),
                            textAlign: TextAlign.justify,
                          ),
                        ]),
                        */
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                            if (value == true) {
                              item['isChecked'] = 'true';
                              myDispatch.add(
                                  int.parse(item['idDispensacion'].toString()));
                            } else {
                              item['isChecked'] = 'false';
                              myDispatch.remove(
                                  int.parse(item['idDispensacion'].toString()));
                            }
                          });
                        },
                      );
                    }),
          ),
          //),
        ],
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanned Value'),
      ),
      body: Center(
        child: Text('Scanned Value: $widget.barcodeValue'),
      ),
    );
  }
  */
}

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:unilene_app/services/service_subagrupador.dart';
import '../services/service_agrupador.dart';
import '../services/service_cliente.dart';
import '../services/service_marca.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDialog extends StatefulWidget {
  final Function(String, String, String, String, String, String, String)
      onProcess;
  const MyDialog({Key? key, required this.onProcess}) : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  String _cliente = '';
  String _agrupador = '';
  String _subagrupador = '';
  String _marca = '';

  String? _nomcliente = '';
  String? _nomagrupador = '';
  String? _nomsubagrupador = '';
  String? _nommarca = '';

  TextEditingController _typeAheadControllerCliente = TextEditingController();
  TextEditingController _typeAheadControllerAgrupador = TextEditingController();
  TextEditingController _typeAheadControllerSubAgrupador =
      TextEditingController();
  TextEditingController _typeAheadControllerMarca = TextEditingController();

  String? _pre = '';
  String? _stock = '';
  String? _linea = '';

  int _selectedButtonPre = 11;
  int _selectedButtonStock = 21;
  int _selectedButtonLinea = 33;

  //String _selectedCity = '';

  Future<void> _setSessionPreFiltro(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pre = value;
    });
    await prefs.setString('preFiltro', value);
  }

  Future<void> _setSessionStock(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stock = value;
    });
    await prefs.setString('stock', value);
  }

  Future<void> _setSessionLinea(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _linea = value;
    });
    await prefs.setString('linea', value);
  }

  //Fijando los demas valores
  Future<void> _setSessionCliente(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomcliente = value;
    });
    await prefs.setString('cliente', value);
  }

  Future<void> _setSessionCodAgrupador(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _agrupador = value;
    });
    await prefs.setString('codagrupador', value);
  }

  Future<void> _setSessionAgrupador(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomagrupador = value;
    });
    await prefs.setString('agrupador', value);
  }

  Future<void> _setSessionSubAgrupador(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomsubagrupador = value;
    });
    await prefs.setString('subagrupador', value);
  }

  Future<void> _setSessionMarca(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nommarca = value;
    });
    await prefs.setString('marca', value);
  }

  @override
  void initState() {
    super.initState();
    _getSessionPreFiltro();
    _getSessionStock();
    _getSessionLinea();
    _getSessionCliente();
    _getSessionAgrupador();
    _getSessionSubAgrupador();
    _getSessionMarca();
  }

  @override
  void dispose() {
    _typeAheadControllerCliente.dispose();
    super.dispose();
  }

  Future<void> _getSessionPreFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('preFiltro');
    setState(() {
      _pre = value;
    });
    print('valor session dialog $_pre');
    if (_pre == 'P') {
      _selectedButtonPre = 11;
    } else {
      _selectedButtonPre = 12;
    }
    print('new valor button: $_selectedButtonPre');
  }

  Future<void> _getSessionStock() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('stock');
    setState(() {
      _stock = value;
    });
    print('valor session dialog $_stock');
    switch (_stock) {
      case 'C':
        _selectedButtonStock = 21;
        break;
      case 'S':
        _selectedButtonStock = 22;
        break;
      case 'R':
        _selectedButtonStock = 23;
        break;
      default:
        break;
    }
  }

  Future<void> _getSessionLinea() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('linea');
    setState(() {
      _linea = value;
    });
    print('valor session dialog $_linea');
    switch (_linea) {
      case 'P':
        _selectedButtonLinea = 31;
        break;
      case 'D':
        _selectedButtonLinea = 32;
        break;
      case '':
        _selectedButtonLinea = 33;
        break;
      default:
        break;
    }
  }

  Future<void> _getSessionCliente() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('cliente');
    setState(() {
      _nomcliente = value!;
      //print('valor session _type _cliente $_nomcliente');
      _typeAheadControllerCliente = TextEditingController(text: _nomcliente);
    });
  }

  Future<void> _getSessionCodAgrupador() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('codagrupador');
    setState(() {
      _agrupador = value!;
    });
  }

  Future<void> _getSessionAgrupador() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('agrupador');
    setState(() {
      _nomagrupador = value!;
      //print('valor session _type _cliente $_nomcliente');
      _typeAheadControllerAgrupador =
          TextEditingController(text: _nomagrupador);
    });
  }

  Future<void> _getSessionSubAgrupador() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('subagrupador');
    setState(() {
      _nomsubagrupador = value!;
      //print('valor session _type _cliente $_nomcliente');
      _typeAheadControllerSubAgrupador =
          TextEditingController(text: _nomsubagrupador);
    });
  }

  Future<void> _getSessionMarca() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('marca');
    setState(() {
      _nommarca = value!;
      //print('valor session _type _cliente $_nomcliente');
      _typeAheadControllerMarca = TextEditingController(text: _nommarca);
    });
  }

  //final Function(String) onFilter;

  //final Function(String) onProcess;

  //MyDialog({required this.onProcess});

  //valores de la sesion

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          //contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Container(
            color: Colors.white,
            //padding: EdgeInsets.all(1.0),
            child: Text(
              'Busqueda',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Container(
                  //var width = MediaQuery.of(context).size.width;
                  width: MediaQuery.of(context).size.width - 50,
                  //height: MediaQuery.of(context).size.height - 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pre-Filtros',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _pre = 'P';
                              _setSessionPreFiltro(_pre!);
                              setState(() {
                                _selectedButtonPre = 11;
                              });
                              print('Select session $_pre');
                              print('Select Button $_selectedButtonPre');
                            },
                            child: Text('Productos Asignados',
                                style: TextStyle(
                                  color: _selectedButtonPre == 11
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonPre == 11
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pre = 'T';
                              _setSessionPreFiltro(_pre!);
                              setState(() {
                                _selectedButtonPre = 12;
                              });
                              print('Select session $_pre');
                              print('Select Button $_selectedButtonPre');
                            },
                            child: Text('Todos',
                                style: TextStyle(
                                  color: _selectedButtonPre == 12
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonPre == 12
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Estado Stock',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _stock = 'C';
                              _setSessionStock(_stock!);
                              setState(() {
                                _selectedButtonStock = 21;
                              });
                              print('Select session stock $_stock');
                              print('Select Button $_selectedButtonStock');
                            },
                            child: Text('Con Stock',
                                style: TextStyle(
                                  color: _selectedButtonStock == 21
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonStock == 21
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _stock = 'S';
                              _setSessionStock(_stock!);
                              setState(() {
                                _selectedButtonStock = 22;
                              });
                              print('Select session stock $_stock');
                              print('Select Button $_selectedButtonStock');
                            },
                            child: Text('Sin Stock',
                                style: TextStyle(
                                  color: _selectedButtonStock == 22
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonStock == 22
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _stock = 'R';
                              _setSessionStock(_stock!);
                              setState(() {
                                _selectedButtonStock = 23;
                              });
                              print('Select session stock $_stock');
                              print('Select Button $_selectedButtonStock');
                            },
                            child: Text('Rep. 7 dias',
                                style: TextStyle(
                                  color: _selectedButtonStock == 23
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonStock == 23
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Linea',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _linea = 'P';
                              _setSessionLinea(_linea!);
                              setState(() {
                                _selectedButtonLinea = 31;
                              });
                              print('Select session linea $_linea');
                              print('Select Button $_selectedButtonLinea');
                            },
                            child: Text('Producto \n Terminado',
                                style: TextStyle(
                                  color: _selectedButtonLinea == 31
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonLinea == 31
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _linea = 'D';
                              _setSessionLinea(_linea!);
                              setState(() {
                                _selectedButtonLinea = 32;
                              });
                              print('Select session linea $_linea');
                              print('Select Button $_selectedButtonLinea');
                            },
                            child: Text('Droguería',
                                style: TextStyle(
                                  color: _selectedButtonLinea == 32
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonLinea == 32
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _linea = '';
                              _setSessionLinea(_linea!);
                              setState(() {
                                _selectedButtonLinea = 33;
                              });
                              print('Select session linea $_linea');
                              print('Select Button $_selectedButtonLinea');
                            },
                            child: Text('Ambos',
                                style: TextStyle(
                                  color: _selectedButtonLinea == 33
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedButtonLinea == 33
                                  ? Colors.blue
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(40.0, 40.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cuenta Cliente',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            //autofocus: true,
                            /*
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontStyle: FontStyle.italic),
                              */
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: 'Cuenta Cliente',
                              contentPadding: EdgeInsets.all(10.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  _setSessionCliente('');
                                  _typeAheadControllerCliente.text = '';
                                },
                              ),
                            ),
                            controller: this._typeAheadControllerCliente),
                        suggestionsCallback: (pattern) async {
                          return await BackendCliente.getCliente(pattern);
                        },
                        itemBuilder: (context, Map<String, String> cliente) {
                          return ListTile(
                            title: Text(cliente['nombres']!),
                            //subtitle: Text('${cliente['codigo']}'),
                          );
                        },
                        onSuggestionSelected: (Map<String, String> cliente) {
                          // your implementation here
                          setState(() {
                            this._typeAheadControllerCliente.text =
                                cliente['nombres'].toString();
                            _cliente = cliente['codigo'].toString();
                            _setSessionCliente(cliente['nombres'].toString());
                            print(cliente['nombres'].toString());
                            print('Select session type $_cliente');
                          });
                        },

                        //keepSuggestionsOnSuggestionSelected: true,

                        //onSaved: (value) => this._selectedCity = value!,
                      ),
                      /*
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Cuenta Cliente',
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                      */
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Agrupador',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      /*
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Agrupador',
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                      */
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            //autofocus: true,
                            /*
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontStyle: FontStyle.italic),
                              */
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: 'Agrupador',
                              contentPadding: EdgeInsets.all(10.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  _setSessionAgrupador('');
                                  _setSessionCodAgrupador('');
                                  _typeAheadControllerAgrupador.text = '';
                                },
                              ),
                            ),
                            controller: this._typeAheadControllerAgrupador),
                        suggestionsCallback: (pattern) async {
                          return await BackendAgrupador.getAgrupador(pattern);
                        },
                        itemBuilder: (context, Map<String, String> agrupador) {
                          return ListTile(
                            title: Text(agrupador['descripcion']!),
                            //subtitle: Text('${agrupador['codigo']}'),
                          );
                        },
                        onSuggestionSelected: (Map<String, String> agrupador) {
                          // your implementation here
                          this._typeAheadControllerAgrupador.text =
                              agrupador['descripcion'].toString();
                          _agrupador = agrupador['codigo'].toString();
                          _setSessionCodAgrupador(
                              agrupador['codigo'].toString());
                          _setSessionAgrupador(
                              agrupador['descripcion'].toString());
                        },
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'SubAgrupador',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            //autofocus: true,
                            /*
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontStyle: FontStyle.italic),
                              */
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: 'SubAgrupador',
                              contentPadding: EdgeInsets.all(10.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  _setSessionSubAgrupador('');
                                  _typeAheadControllerSubAgrupador.text = '';
                                },
                              ),
                            ),
                            controller: this._typeAheadControllerSubAgrupador),
                        suggestionsCallback: (pattern) async {
                          var agrup = "";
                          if (_agrupador == '') {
                            agrup = "";
                          } else {
                            agrup = _agrupador;
                          }
                          return await BackendSubAgrupador.getSubAgrupador(
                              _linea!, agrup, pattern);
                        },
                        itemBuilder:
                            (context, Map<String, String> subagrupador) {
                          return ListTile(
                            title: Text(subagrupador['descripcion']!),
                            //subtitle: Text('${subagrupador['codigo']}'),
                          );
                        },
                        onSuggestionSelected:
                            (Map<String, String> subAgrupador) {
                          // your implementation here
                          this._typeAheadControllerSubAgrupador.text =
                              subAgrupador['descripcion'].toString();
                          _subagrupador = subAgrupador['codigo'].toString();
                          _setSessionSubAgrupador(
                              subAgrupador['descripcion'].toString());
                        },
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Marca',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            //autofocus: true,
                            /*
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontStyle: FontStyle.italic),
                              */
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: 'Ingrese Marca',
                              contentPadding: EdgeInsets.all(10.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  _setSessionMarca('');
                                  _typeAheadControllerMarca.text = '';
                                },
                              ),
                            ),
                            controller: this._typeAheadControllerMarca),
                        suggestionsCallback: (pattern) async {
                          return await BackendMarca.getMarca(pattern);
                        },
                        itemBuilder: (context, Map<String, String> marca) {
                          return ListTile(
                            title: Text(marca['descripcion']!),
                            //subtitle: Text('${marca['codigo']}'),
                          );
                        },
                        onSuggestionSelected: (Map<String, String> marca) {
                          // your implementation here
                          this._typeAheadControllerMarca.text =
                              marca['descripcion'].toString();
                          _marca = marca['codigo'].toString();
                          _setSessionMarca(marca['descripcion'].toString());
                        },
                      ),
                      //],
                      //),
                      /*
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Marca',
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                      */
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Aplicar'),
                                actions: [
                                  TextButton(
                                    onPressed: widget.onProcess(
                                        _linea!,
                                        _agrupador,
                                        _subagrupador,
                                        _cliente,
                                        _pre!,
                                        _stock!,
                                        _marca),
                                    /*() {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        //_text = _textFieldController.text;
                                        _linea = 'D';
                                      });
                                      /*
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('OK'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      */
                                    },
                                    */
                                    child: Text('Aplicar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Aplicar'),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:unilene_app/screens/account/account_page.dart';
import 'package:unilene_app/screens/comision_page.dart';
import 'package:unilene_app/screens/contact/contact_page.dart';
import 'package:unilene_app/screens/cotizaciones_page.dart';
import 'package:unilene_app/screens/products_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unilene_app/core/widgets/card_menu.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  String? _nomcliente = '';
  String? _codagrupador = '';
  String? _nomagrupador = '';
  String? _nomsubagrupador = '';
  String? _nommarca = '';

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
      _codagrupador = value;
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
    _getSessionCliente();
    _getSessionCodAgrupador();
    _getSessionAgrupador();
    _getSessionSubAgrupador();
    _getSessionMarca();
  }

  Future<void> _getSessionCliente() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('cliente');
    setState(() {
      _nomcliente = value!;
    });
  }

  Future<void> _getSessionCodAgrupador() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('codagrupador');
    setState(() {
      _codagrupador = value!;
    });
  }

  Future<void> _getSessionAgrupador() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('agrupador');
    setState(() {
      _nomagrupador = value!;
    });
  }

  Future<void> _getSessionSubAgrupador() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('subagrupador');
    setState(() {
      _nomsubagrupador = value!;
    });
  }

  Future<void> _getSessionMarca() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('marca');
    setState(() {
      _nommarca = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Aplicaciones'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _setSessionCliente('');
                      _setSessionCodAgrupador('');
                      _setSessionAgrupador('');
                      _setSessionSubAgrupador('');
                      _setSessionMarca('');
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductPage()),
                    );
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      //color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 30,
                      //width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.format_indent_decrease_outlined,
                              color: Colors.grey),
                          SizedBox(height: 5),
                          Text(
                            'Productos',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyComisionPage()),
                    );
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      //color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 30,
                      //width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.paste_rounded, color: Colors.grey),
                          SizedBox(height: 5),
                          Text(
                            'Comisiones',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              //DespachoPage(barcodeValue: "00000002")),
                              MyCotizacionPage()),
                    );
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      //color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 30,
                      //width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.border_outer_rounded, color: Colors.grey),
                          SizedBox(height: 5),
                          Text(
                            'Cotizaciones',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
          Row(children: [
            CustomCard(
                icon: Icons.contact_page,
                text: 'Contacto',
                color: Colors.grey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountPage(),
                    ),
                  );
                },
              ),
            Expanded(child: Container()),
            Expanded(child: Container()),
          ])
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unilene_app/screens/detail_page.dart';
import 'package:unilene_app/screens/dialog_page.dart';
import 'dart:convert';
import 'package:unilene_app/util/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../model/ModelView.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _MyProductPageState createState() => _MyProductPageState();
}

class _MyProductPageState extends State<ProductPage> {
  Timer? _timer;
  final TextEditingController _controller = TextEditingController();
  List<Product> _products = [];

  bool _type = false;

  int _page = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  int _totalRegistros = 0;

  final int _limit = 30;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  List _posts = [];
  List _paginado = [];

  String _preFiltro = '';
  String _stock = '';
  String _linea = '';

  String _agrupador = '';

  /*
  @override
  setState(() async {
  _preFiltro = await SessionManager().get('preFiltro');
  _stock = await SessionManager().get('stock');
  _linea = await SessionManager().get('linea');
  });
  */

  void _firstLoad() async {
    print('valor de type: ' + _type.toString());
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final token = await SessionManager().get('token');
      final res = await http.post(
        Uri.parse(
            '${ApiConstant.url}/movil/almacen/api/stock/consultaStockVendedor'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token,
        },
        body: jsonEncode(<String, dynamic>{
          'linea': _linea,
          'agrupador': '',
          'subagrupador': '',
          'cliente': '0',
          'preFiltro': _preFiltro,
          'estadoStock': _stock,
          'marca': '',
          'flagNroParteSutura': _type,
          'descripcionItem': '',
          'vendedor': '0',
          'pagina': _page.toString(),
        }),
      );
      setState(() {
        _posts = json.decode(res.body)['content']['contenido'];
        //_paginado = json.decode(res.body)['content']['paginado'];
        _totalRegistros =
            json.decode(res.body)['content']['paginado']['totalRegistros'];
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    print('_controller1.position.extentAfter ' +
        _controller1.position.extentAfter.toString());
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller1.position.extentAfter < 300 &&
        _totalRegistros > 30 /*_controller1.position.extentAfter < 0*/) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        String valText = '';
        if (_controller.text.length >= 2) {
          valText = _controller.text;
        } else {
          valText = '';
        }
        final token = await SessionManager().get('token');
        final res = await http.post(
          Uri.parse(
              '${ApiConstant.url}/movil/almacen/api/stock/consultaStockVendedor'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + token,
          },
          body: jsonEncode(<String, dynamic>{
            'linea': _linea,
            'cliente': '0',
            'preFiltro': _preFiltro,
            'estadoStock': _stock,
            'marca': '',
            'flagNroParteSutura': _type,
            'descripcionItem': valText,
            'vendedor': '0',
            'pagina': _page.toString(),
          }),
        );
        print('pageeeeee $_page');
        final List fetchedPosts = json.decode(res.body)['content']['contenido'];
        //final List fetchedPaginado =
        json.decode(res.body)['content']['paginado'];
        _totalRegistros =
            json.decode(res.body)['content']['paginado']['totalRegistros'];
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
            //_paginado.addAll(fetchedPaginado);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller1;

  Future<String> getPreFiltro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _preFiltro = prefs.getString('preFiltro') ?? '';
    });
    return _preFiltro;
  }

  Future<String> getStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('stock') ?? '';
  }

  Future<String> getLinea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('linea') ?? '';
  }

  Future<String> getCodAgrupador() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('codagrupador') ?? '';
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getPreFiltro().then((value) {
        setState(() {
          _preFiltro = value;
          print('_session preFiltro: $_preFiltro');
        });
      });

      getStock().then((value) {
        setState(() {
          _stock = value;
          print('_session Stock: $_stock');
        });
      });

      getCodAgrupador().then((value) {
        setState(() {
          _agrupador = value;
          print('_session Agrupador: $_agrupador');
        });
      });

      getLinea().then((value) {
        setState(() {
          _linea = value;
          print('_session Linea: $_linea');
        });
        //print('Token Session 31: $_preFiltro');
        //print('Token Session 32: $_stock');
        //print('Token Session 33: $_linea');
        /*
        _fetchProducts(
                _linea, '0', _preFiltro, _stock, '', '', '0', _page.toString())
            .then((value) => setState(() {
                  _products = value;
                }));
                */
        _firstLoad();
        _controller1 = ScrollController()..addListener(_loadMore);
      });
    });
    //print('Token Session 45: $_linea');
    setState(() {
      //_isLoading = true;
    });
  }

  @override
  void dispose() {
    _controller1.removeListener(_loadMore);
    super.dispose();
  }

  Future<List<dynamic>> _fetchProducts(
      String linea,
      String agrupador,
      String subagrupador,
      String cliente,
      String preFiltro,
      String estadoStock,
      String marca,
      String descripcionItem,
      String vendedor,
      String pagina) async {
    /*
    setState(() {
      _isLoading = true;
    });
    */

    final token = await SessionManager().get('token');
    print('Token Session Products: $token');
    //Variables de filtro

    final response = await http.post(
      Uri.parse(
          '${ApiConstant.url}/movil/almacen/api/stock/consultaStockVendedor'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode(<String, dynamic>{
        'linea': linea,
        'agrupador': agrupador,
        'subagrupador': subagrupador,
        'cliente': cliente,
        'preFiltro': preFiltro,
        'estadoStock': estadoStock,
        'marca': marca,
        'flagNroParteSutura': _type,
        'descripcionItem': descripcionItem,
        'vendedor': vendedor,
        'pagina': pagina,
      }),
    );
    print('jsonEncode: ' +
        jsonEncode(<String, dynamic>{
          'linea': linea,
          'agrupador': agrupador,
          'subagrupador': subagrupador,
          'cliente': cliente,
          'preFiltro': preFiltro,
          'estadoStock': estadoStock,
          'marca': marca,
          'flagNroParteSutura': _type,
          'descripcionItem': descripcionItem,
          'vendedor': vendedor,
          'pagina': pagina,
        }));
    print('Token Session: $token');
    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');
    //print('query: ${query}');
    //print('Request body: ${response.body}');

    //print('Request body: ${response.request!.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      _totalPages = body['content']['paginado']['totalPaginas'];
      _totalRegistros = body['content']['paginado']['totalRegistros'];
      print('Request data pages: ${_page}');
      print('Request data total pages: ${_totalPages}');
      //_isLoading = false;

      //List<dynamic> data = body['contenido'];
      List<dynamic> data = ((body['content']['contenido'] ?? []) as List);
      print('Request data: ${data}');

      /*
      List<Product> products = data
          .map((dynamic item) => Product(
              item: item['item'],
              descripcion: item['descripcion'],
              stockDisponible: item['stockDisponible'],
              fechaReposicion: "N/A"))
          .toList();
          */
      _posts = json.decode(response.body)['content']['contenido'];
      setState(() {
        //_page++;
        _isLoading = false;
      });

      //print('Request products: ${products}');
      return _posts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProducts(String linea, String agrupador, String subagrupador,
      String cliente, String pre, String stock, String marca) {
    print('Imprime valor de linea $_linea');
    print('Imprime valor de Pre-Filtro $pre');
    print('Imprime valor de stock $stock');

    print('Imprime valor de descripcion ' + _controller.text);

    if (cliente == '') {
      cliente = '0';
    }
    print('Imprime valor de cliente $cliente');
    print('Imprime valor de marca $marca');
    //super.initState();
    //setState(() {
    _fetchProducts(linea, agrupador, subagrupador, cliente, pre, stock, marca,
            _controller.text, '0', '1')
        .then((value) => setState(() {
              _posts = value;
            }));
    //});
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //String filterValue = '';
          //return MyDialog();
          return MyDialog(
            onProcess:
                (linea, agrupador, subagrupador, cliente, pre, stock, marca) {
              Navigator.of(context).pop();
              filterProducts(
                  linea, agrupador, subagrupador, cliente, pre, stock, marca);
              //dispose();
              //_firstLoad();
              //_controller1 = ScrollController()..addListener(_loadMore);
              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
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
                      prefixIcon: IconButton(
                        icon: Icon(_type == false
                            ? Icons.search
                            : Icons.playlist_play),
                        onPressed: () {
                          //_setSessionCliente('');
                          //_typeAheadControllerCliente.text = '';
                          setState(() {
                            if (_type == false) {
                              _type = true;
                            } else {
                              _type = false;
                            }
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(5.0),
                    ),
                    onChanged: (value) {
                      //_controller.text = value;
                      getStock().then((value) {
                        setState(() {
                          _stock = value;
                          print('_session Stock: $_stock');
                        });
                      });
                      if (_timer?.isActive ?? false) _timer?.cancel();
                      _timer = Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          getCodAgrupador().then((value) {
                            setState(() {
                              _agrupador = value;
                              print('_session Agrupador: $_agrupador');
                            });
                          });
                          if (value.length >= 2) {
                            _page = 1;
                            _fetchProducts(
                                    _linea,
                                    _agrupador,
                                    '',
                                    '0',
                                    _preFiltro,
                                    _stock,
                                    '',
                                    _controller.text,
                                    '0',
                                    _page.toString())
                                .then((value) => setState(() {
                                      _posts = value;
                                    }));
                          } else {
                            _fetchProducts(
                                    _linea,
                                    _agrupador,
                                    '',
                                    '0',
                                    _preFiltro,
                                    _stock,
                                    '',
                                    '',
                                    '0',
                                    _page.toString())
                                .then((value) => setState(() {
                                      _posts = value;
                                    }));
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
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: ColorConstants.primaryColor,
                    icon: Icon(Icons.filter_list_sharp),
                    onPressed: _showDialog,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total Registros: ' + _totalRegistros.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    //color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          _isFirstLoadRunning
              ? const Center(
                  child: const CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    controller: _controller1,
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      //final item = _products[index];

                      return GestureDetector(
                        onTap: () {
                          /*
                          final message =
                              'You selected item ${_posts[index]['item']}';
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(message)));
                              */
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      item: _posts[index]['item'])));
                        },
                        child: ListTile(
                          title: Text(
                            //'$_page ' +
                            //    '$index ' +
                            _posts[index]['descripcion'].toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'Stock: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.0,
                                  color: _posts[index]['stockDisponible'] > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                  NumberFormat('#,###')
                                      .format(_posts[index]['stockDisponible']),
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: _posts[index]['stockDisponible'] > 0
                                        ? Colors.green
                                        : Colors.red,
                                  )),
                              Spacer(),
                              Text(
                                'Fecha Rep: ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: _posts[index]['fechaReposicion']
                                          .toString()
                                          .contains('N/A')
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                              Text((_posts[index]['fechaReposicion'] ?? 'N/A'),
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: (_posts[index]['fechaReposicion'] ??
                                                'N/A')
                                            .isNotEmpty
                                        ? Colors.red
                                        : Colors.green,
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

          // when the _loadMore function is running
          if (_isLoadMoreRunning == true)
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),

          /*
          if (_hasNextPage == false)
          
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 40),
              color: Colors.amber,
              child: const Center(
                child: Text('You have fetched all of the content'),
              ),
            ),
            */
        ],
      ),
    );
  }
}

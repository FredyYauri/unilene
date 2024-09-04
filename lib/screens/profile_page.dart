import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unilene_app/services/service_usuario.dart';
import 'package:unilene_app/util/app_state.dart';
//import 'package:mi_app/screens/product_screen.dart';
//import 'package:mi_app/screens/filter_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _datosUsuario = {};

  @override
  void initState() {
    super.initState();
    //_comision = BackendComision.getComision('202305', 1);
    BackendUsuario.getUsuario().then((value) => setState(() {
          _datosUsuario = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final token = AppState.token;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.blue, Colors.white],
            stops: [0.5, 1.0],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: ExactAssetImage('assets/images/user_icon.png'),
              radius: 100.0,
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Nombre :',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                                _datosUsuario['nombre'].toString() +
                                    ' ' +
                                    _datosUsuario['apellidoPaterno']
                                        .toString() +
                                    ' ' +
                                    _datosUsuario['apellidoMaterno'].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Email :',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _datosUsuario['correo'].toString(),
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Celular :',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(_datosUsuario['celular'].toString()),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'IMEI :',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text('###'),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Codigo ID :',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(_datosUsuario['codigo'].toString()),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Firebase ID :',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: token.toString()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'El texto se copio al portapapeles.')),
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      token.toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.content_copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: token.toString()));
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(
                                      //   SnackBar(
                                      //       content: Text(
                                      //           'El texto se copio al portapapeles.')),
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

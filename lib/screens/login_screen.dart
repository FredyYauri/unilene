import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';
import 'package:unilene_app/screens/home_page.dart';
import 'package:unilene_app/services/service_registro_token.dart';
import 'package:unilene_app/services/service_usuario.dart';
import 'package:unilene_app/util/app_state.dart';
import 'package:unilene_app/util/color_constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberUsername = false;
  bool _rememberPassword = false;

  Map<String, dynamic> _datosUsuario = {};
  int vendedor = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    //_loadCredentials();
    _checkCredentials();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hasCredentials =
        prefs.containsKey('usname') && prefs.containsKey('password');
    if (hasCredentials) {
      _usernameController.text = prefs.getString('usname') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _login();
    }
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberUsername = prefs.getBool('rememberUsername') ?? false;
      _rememberPassword = prefs.getBool('rememberPassword') ?? false;
      if (_rememberUsername) {
        _usernameController.text = prefs.getString('usname') ?? '';
        String uname = prefs.getString('usname').toString();
        print('usname: $uname');
      }
      if (_rememberPassword) {
        _passwordController.text = prefs.getString('password') ?? '';
        String upass = prefs.getString('password').toString();
        print('uspass: $upass');
      }
    });
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberUsername) {
      prefs.setString('usname', _usernameController.text);
    } else {
      prefs.remove('usname');
    }
    if (_rememberPassword) {
      prefs.setString('password', _passwordController.text);
    } else {
      prefs.remove('password');
    }
    prefs.setBool('rememberUsername', _rememberUsername);
    prefs.setBool('rememberPassword', _rememberPassword);
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    //final hmac = Hmac(Sha512, utf8.encode('my_secret_key'));
    //final signature = await hmac.calculateMac(utf8.encode(password));

    final message = password;
    final secretKey = r'hV#RbJ*JLNr^obuBfgR44Tmhv&^!VJxdO*,&]_J8L@|,^.X$Pe';
    //final hmac = Hmac.sha512();
    //final mac = await hmac.calculateMac(message, secretKey: secretKey);
    //final signature = base64.encode(mac.bytes);
    //final signature = "08dbbc0c6b151dbbbbc7af3d1f61cf84d358e6c125d16aedf966ae1c25490e56de168bedbfe8a89052f54585750bf5556f5c0cdb9e1bd48a64a527b41fc63fa4";
    //final hmac = Hmac(Sha512, utf8.encode('my_secret_key'));
    //final signature = sha512.convert([...secretKey, ...message]).toString();
    final hmacSha512 = Hmac(sha512, utf8.encode(secretKey));
    final digest = hmacSha512.convert(utf8.encode(password));
    final signature = digest.toString();

    print('Username: $username');
    print('Password: $password');
    print('Password: $message');
    print('Secret Key: $secretKey');
    print('Signature: $signature');

    final response = await http.post(
      Uri.parse(
          '${ApiConstant.url}/movil/seguridad/api/Autenticacion/InicioSesion'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'usuario': username,
        'clave': signature,
      }),
    );

    print('Request URL: ${response.request!.url}');
    print('Request headers: ${response.request!.headers}');
    //print('Request body: ${response.body}');
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['content']['token'];
      await SessionManager().set('token', token);
      final value = await SessionManager().get('token');
      print('token ss: $token');
      print('token de la session: $value');

      //Enviando los parametros de Firebase

      String _fireBaseTokenID = AppState.token.toString();
      BackendUsuario.getUsuario().then((value) => setState(() {
            _datosUsuario = value;
            print('_datos usuario: $_datosUsuario');
            vendedor = int.parse(_datosUsuario['codigo'].toString());
            print('_datos _vendedor: $vendedor');

            //Enviando el token del vendedor
            BackendToken.getRegistroToken(vendedor, _fireBaseTokenID);
          }));

      //Seteando los variables de Session de busqueda
      String _preFiltro = 'T';
      String _stock = 'C';
      String _linea = '';
      //Definiendo variables de filtro:
      //await SessionManager().set('preFiltro', _preFiltro);
      //await SessionManager().set('stock', _stock);
      //await SessionManager().set('linea', _linea);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('preFiltro', _preFiltro);
      await prefs.setString('stock', _stock);
      await prefs.setString('linea', _linea);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Alerta',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )),
          content: Text('El usuario o contraseña no son válidos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          height: MediaQuery.of(context).size.height * 0.75,
          //width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: StaggeredAnimation(
            animation: _animation,
            child: Column(
              children: [
                Image.asset('assets/images/logo_transparent.png'),
                //SizedBox(height: 10),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Usuario',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                //SizedBox(height: 5),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberPassword,
                      onChanged: (value) {
                        setState(() {
                          _rememberUsername = value!;
                          _rememberPassword = value!;
                          _saveCredentials();
                        });
                      },
                    ),
                    Text('Permanecer conectado'),
                  ],
                ),
                SizedBox(
                  width: 350.0,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    //color: Colors.blue,
                    /*
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  */
                    child: Text(
                      'Ingresar',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StaggeredAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
//const DetailScreen({Key? key, required this.item}) : super(key: key);
  const StaggeredAnimation(
      {Key? key, required this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, child) {
        return Material(
          child: Opacity(
            opacity: 1,
            child: Transform.translate(
              offset: Offset(0, (1 - animation.value) * 100),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

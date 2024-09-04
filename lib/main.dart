import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unilene_app/model/ModelView.dart';
import 'package:unilene_app/screens/cotizaciones_page.dart';
import 'package:unilene_app/screens/notificaciones.dart';
import 'package:unilene_app/screens/splash_screen.dart';
import 'package:unilene_app/util/push_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsService.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void initState() {
    super.initState();

    //Context!
    PushNotificationsService.messageStream.listen((message) {
      print('MyApp: $message');

      navigatorKey.currentState?.pushNamed('NotificationsPage');
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      routes: {
        //'/': (context) => MyCotizacionPage(),
        '/detalle-cotizacion': (context) => MyCotizacionPage(),
        'NotificationsPage': (context) => NotificationsScreen(),
        //'/detalle-cotizacion-total': (context) => DetailCotizacionTotal(),
      },
      home: SplashScreen(),
    );
  }
}

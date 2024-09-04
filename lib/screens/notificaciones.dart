import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:unilene_app/model/ModelView.dart';
import 'package:unilene_app/screens/notificacion_detalle.dart';
import 'package:unilene_app/services/service_despacho.dart';
import 'package:unilene_app/services/service_notificaciones.dart';
import 'package:unilene_app/services/service_usuario.dart';
import 'package:collection/collection.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Create an instance of the plugin

  List<Map<String, String>> _notificaciones = [];
  Map<String, dynamic> _datosUsuario = {};
  int vendedor = 0;
  List<GroupedNotification> _groupedNotifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize local notifications plugin
    _initializeNotifications();
    //showNotification('Título de la notificación', '¡Hola!');

    BackendUsuario.getUsuario().then((value) => setState(() {
          _datosUsuario = value;
          print('_datos usuario: $_datosUsuario');
          vendedor = int.parse(_datosUsuario['codigo'].toString());
          print('_datos _vendedor: $vendedor');

          BackendNotificacion.getNotificaciones(vendedor)
              .then((value) => setState(() {
                    _notificaciones = value;
                    //_showNotificationsSequentially(_notificaciones);
                    // for (var notification in _notificaciones) {
                    //   Future.delayed(const Duration(seconds: 3));
                    //   showNotification(notification['tituloNotificacion'].toString(),
                    //       notification['cuerpoNotificacion'].toString());
                    // }
                  }));
        }));
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.paused) {
  //     _showNotificationsSequentially(_notificaciones);
  //   }
  // }

  void _showNotificationsSequentially(
      List<Map<String, dynamic>> notifications) {
    int delay = 0;
    for (var i = 0; i < notifications.length; i++) {
      Future.delayed(Duration(seconds: delay), () {
        showNotification(notifications[i]['tituloNotificacion'].toString(),
            notifications[i]['cuerpoNotificacion'].toString());
      });
      delay += 2; // Ajusta el valor de retraso según tus necesidades
    }
  }

  Future<void> _createNotificationChannel() async {
    const androidNotificationChannel = AndroidNotificationChannel(
      'your_channel_id', // Use a unique channel ID
      'general', // Channel name
      description: 'General notifications', // Channel description
      importance: Importance.max, // Set appropriate importance
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> _initializeNotifications() async {
    // Initialization settings for Android and iOS
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _createNotificationChannel();
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Pantalla de Notificaciones'),
            ElevatedButton(
              onPressed: () {
                // Función para mostrar una notificación
                showNotification('Título de la notificación', '¡Hola!');
              },
              child: Text('Mostrar Notificación'),
            ),
          ],
        ),
      ),
    );
  }
  */

  String _getGroupKey(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hoy';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Ayer';
    } else if (date.isAfter(now.subtract(Duration(days: now.weekday))) &&
        date.isBefore(now)) {
      return 'Esta Semana';
    } else {
      return 'Este Mes';
    }
  }

  Widget build(BuildContext context) {
    Map<String, List<Map<String, String>>> groupedNotifications = {};

    _notificaciones.forEach((notification) {
      DateTime notificationDate =
          DateTime.parse(notification['fechaCreacion'].toString());
      String groupKey = _getGroupKey(notificationDate);

      if (!groupedNotifications.containsKey(groupKey)) {
        groupedNotifications[groupKey] = [];
      }

      groupedNotifications[groupKey]?.add(notification);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groupedNotifications.length,
              itemBuilder: (BuildContext context, int index) {
                String groupKey = groupedNotifications.keys.elementAt(index);
                List<Map<String, String>>? notifications =
                    groupedNotifications[groupKey];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        groupKey,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: notifications?.length,
                      itemBuilder: (BuildContext context, int innerIndex) {
                        final item = notifications?[innerIndex];
                        Color backgroundColor =
                            item!['estado'].toString() == 'A'
                                ? Colors.grey.shade300
                                : Colors.white;

                        return GestureDetector(
                            onTap: () {
                              // Código a ejecutar cuando se hace clic en el registro
                              //String valor = item!['notificacionId'].toString();
                              //print('Valor item: $valor');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailNotificacion(
                                          id: int.parse(item['notificacionId']
                                              .toString()),
                                          fecha: DateFormat('dd/MM/yyyy')
                                              .format(DateTime.parse(
                                                  item['fechaCreacion']
                                                      .toString())),
                                          titulo: item['tituloNotificacion']
                                              .toString(),
                                          notificacion:
                                              item['cuerpoNotificacion']
                                                  .toString())));
                            },
                            child: Container(
                                color: backgroundColor,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/icon_unilene.png', // Ruta del ícono
                                        width: 30, // Ancho de la imagen
                                        height: 30, // Alto de la imagen
                                        fit:
                                            BoxFit.cover, // Ajuste de la imagen
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    item!['tituloNotificacion'].toString(),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item['cuerpoNotificacion'].toString(),
                                  ),
                                  // trailing: Image.asset(
                                  //   'assets/images/icon_unilene.png', // Ruta del ícono
                                  //   width: 35, // Ancho de la imagen
                                  //   height: 35, // Alto de la imagen
                                  //   fit: BoxFit.cover, // Ajuste de la imagen
                                  // ),
                                )));
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar una notificación
  void showNotification(String title, String body) async {
    const androidNotificationDetail = AndroidNotificationDetails(
      'your_channel_id', // Use a unique channel ID
      'general',
      channelDescription: 'General notifications',
      importance: Importance.max,
      // actions: <AndroidNotificationAction>[
      //   AndroidNotificationAction(
      //     'ACTION_DEFAULT',
      //     'Default Action',
      //   ),
      // ], // Set appropriate importance
    );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
    // var notificationDetails = NotificationDetails(
    //   android: AndroidNotificationDetails(
    //     'channel_id',
    //     'channel_name',
    //     importance: Importance.max
    //   ),
    //   iOS: DarwinNotificationDetails(),
    // );

    // await flutterLocalNotificationsPlugin.show(
    //     0, title, body, notificationDetails);
  }
}

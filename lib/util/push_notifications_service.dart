import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unilene_app/model/ModelView.dart';
import 'package:unilene_app/screens/notificaciones.dart';
import 'package:unilene_app/util/app_state.dart';
import 'package:provider/provider.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStreamController =
      new StreamController.broadcast();
  static Stream<String> get messageStream => _messageStreamController.stream;
  static RemoteMessage? _lastBackgroundMessage;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future _backgroundHandler(RemoteMessage message) async {
    print('onBackground Handler ${message.messageId}');
    _lastBackgroundMessage = message;
    _messageStreamController.add(message.notification?.title ?? 'No title');

/*
    final navigatorKey = GlobalKey<NavigatorState>();

    //Utiliza la navegación para abrir la página NewPage()
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => NotificationsScreen(),
      ),
    );
    */
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessage Handler ${message.messageId}');
    _messageStreamController.add(message.notification?.title ?? 'No title');
    if (_lastBackgroundMessage != message) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        //sound: RawResourceAndroidNotificationSound('notification_sound'),
        styleInformation: BigTextStyleInformation(''),
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: message.data['data'],
      );
    }
    _lastBackgroundMessage = message;
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp Handler ${message.messageId}');
    _messageStreamController.add(message.notification?.title ?? 'No title');
  }

  static Future initializeApp() async {
    //Push
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token FireBase: $token');

    AppState.token = token;

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local Notifications

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static closeStreams() {
    _messageStreamController.close();
  }
}

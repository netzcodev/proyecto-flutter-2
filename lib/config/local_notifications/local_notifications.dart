// import 'package:cars_app/config/config.dart';
// import 'package:cars_app/features/notificactions/presentation/blocs/notifications/notifications_bloc.dart';
// import 'package:cars_app/features/notificactions/presentation/screens/notifications_details_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LocalNotifications {
  static Future<void> requestPermissionLocalNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    //TODO: configuración de ios

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static StreamController<String> selectNotificationStream =
      StreamController<String>.broadcast();

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: data,
    );
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    // final String? payload = notificationResponse.payload;
    // if (notificationResponse.payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    // final notitificationAppLauncDetails =
    //     await flutterLocalNotificationPlugin.getNotificationAppLaunchDetails();
    // // await Navigator.push(
    // //   context,
    // //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // // );

    selectNotificationStream.add(notificationResponse.payload!);
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

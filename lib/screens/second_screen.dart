import 'dart:convert';
import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/notification_data_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SecondScreen extends StatelessWidget {

  static const String route = "/second";

  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    triggerNotificationsListeners(context);
    return Scaffold(
      appBar: AppBar(title: const Text('second')),
      body: const Center(child: Text('this is the second screen'),),
    );
  }

  void triggerNotificationsListeners(BuildContext context) async {
    // local notification
    NotificationAppLaunchDetails? initialNotification = await NotificationsApi.localNotificationsPlugin.getNotificationAppLaunchDetails();
    // fcm notification
    RemoteMessage? message;
    await Future.delayed(Duration.zero, () => message = getRemoteMessage(context));
    // local notification was tapped while the app is in foreground
    NotificationsApi.notificationStream.stream.listen((payload) {
      Future.delayed(Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: payload));
    });
    // firebase notification was tapped while the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Map<String, dynamic> payload = message.data;
      Future.delayed(Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: jsonEncode(payload)));
    });
    // local notification was tapped while the app is in background
    if (initialNotification != null && initialNotification.didNotificationLaunchApp == true) {
      String? payload = initialNotification.notificationResponse?.payload;
      // avoid using context across an async gap by ensuring that the context is used after the current frame is rendered
      Future.delayed(Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: payload));
    }
    // firebase notification was tapped while the app is terminated
    else if (message != null) {
      Future.delayed(
          Duration.zero, () => Navigator.pushNamed(context, NotificationDataScreen.route, arguments: jsonEncode(message!.data)));
    }
  }

  RemoteMessage? getRemoteMessage(BuildContext context){
    return ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
  }
}
